#include <linux/kernel.h>
#include <linux/module.h>
#include <asm/segment.h>
#include <asm/uaccess.h> /* Needed for copy_from_user */
#include <asm/io.h> /* Needed for IO Read/Write Functions */
#include <linux/proc_fs.h> /* Needed for Proc File System Functions */
#include <linux/seq_file.h> /* Needed for Sequence File Operations */
#include <linux/platform_device.h> /* Needed for Platform Driver Functions */
#include <linux/delay.h>	/* Needed for udelay function */
#include <linux/fs.h>
#include <linux/proc_fs.h> /* Needed for Proc File System Functions */
#include <linux/buffer_head.h>
#include <linux/signal.h>
#include <linux/slab.h> /* Needed for kmalloc and kfree */

/* Define Driver Name */
#define DRIVER_NAME	"dft"
#define MAX_SIZE 50000
#define SUCCESS 0

//unsigned long *base_addr;	/* Vitual Base Address */
unsigned long *reg_addr;
struct resource *res;		/* Device Resource Structure */
unsigned long remap_size;	/* Device Memory Size */

static u64 data_read[MAX_SIZE];

//Flags
static int Device_written = 0;
static int written_count = 0;

static int FT_SIZE = 128;

module_param(FT_SIZE, int, 0644);
MODULE_PARM_DESC(FT_SIZE, "Size of the Fourier Transformation");

/* Write operation for /proc/dft
* -----------------------------------
* When user echo a string to /proc/dft file, the string will be stored in
* const char __user *buf. The string will be send to the dft 
* unit in the logic fabric.
*/
static ssize_t proc_dft_write(struct file *file, const char __user * buf, size_t count, loff_t * ppos)
{	
	char input[64];
	int ret;
	u64 data;
		
	if ((Device_written == 1) && (written_count == 0)) {
		printk(KERN_INFO "Read the result first before writing again!\n");
		return -EBUSY;
	}
		
	if (count < 64) {
		if (copy_from_user(input, buf, count))
			return -EFAULT;
		input[count-1] = '\0';
	}
	
	//Convert input hex string to integer
	ret = kstrtoull(input, 16, &data);
	if (ret) {
		printk("Input %s is invalid\n", input);
		return ret;
	}	
		
	//Write data to fourier transformation
	wmb();
	iowrite64(data, reg_addr);
	
	//Increment the written count
	written_count++;
	
	if (written_count == FT_SIZE) {
		//reset written count
		written_count = 0;
		
		//Increment the ready count
		Device_written++;
	}
	
	return count;
}

/* Callback function when reading file /proc/dft
* ------------------------------------------------------
* Return the transformed data
*/

static int proc_dft_show(struct seq_file *p, void *v)
{
	int i;
		
	if (Device_written == 0) {
		printk(KERN_INFO "Write the input first before reading!\n");
		return 0;
	}
		
	for (i = 0; i < (FT_SIZE); i++)
	{		
		wmb();	
		//Read data from fourier transformation
		data_read[i] = ioread64(reg_addr);	
		//Write data to seq_file (console)
		seq_printf(p, "%016llx\n", data_read[i]);
	}
			
	//Decrement the ready count
	Device_written--;
	
	return SUCCESS;
}

/* Read operation for /proc/dft
* ------------------------------------
* When user want to read /proc/dft (i.e. cat /proc/dft), the open function
* will be called first. In the open function, a seq_file will be prepared and the
* status of dft will be filled into the seq_file by proc_dft_show function.
*/
//~ static ssize_t proc_dft_read(struct file *file, char * buf, size_t count, loff_t * ppos)
static int proc_dft_open(struct inode *inode, struct file *file)
{	
	unsigned int size = FT_SIZE*18;
	char *buf;
	struct seq_file *m;
	int res;

	buf = (char *)kmalloc(size * sizeof(u64), GFP_KERNEL);
	if (!buf)
		return -ENOMEM;
		
	res = single_open(file, proc_dft_show, NULL);
	if (!res) {
		m = file->private_data;
		m->buf = buf;
		m->size = size;
	} else {
		kfree(buf);
		return res;
	}
	
	return SUCCESS;
}

/* File Operations for /proc/dft */
static const struct file_operations proc_dft_operations = {
	.open = proc_dft_open,
	.read = seq_read,
	.write = proc_dft_write,
	.llseek = seq_lseek,
	.release = single_release
};

/* Remove function for dft
* ----------------------------------
* When dft module is removed, release virtual address and the memory
* region requested.
*/
static int dft_remove(struct platform_device *pdev)
{
	/* Remove /proc/dft entry */
	remove_proc_entry(DRIVER_NAME, NULL);
	/* Release mapped virtual address */
	iounmap(reg_addr);
	/* Release the region */
	release_mem_region(res->start, remap_size);
	return 0;
}

/* Device Probe function for dft
* ------------------------------------
* Get the resource structure from the information in device tree.
* request the memory regioon needed for the controller, and map it into
* kernel virtual memory space. Create an entry under /proc file system
* and register file operations for that entry.
*/
static int dft_probe(struct platform_device *pdev)
{
	struct proc_dir_entry *dft_proc_entry;
	int ret = 0;
			
	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (!res) {
		dev_err(&pdev->dev, "No memory resource\n");
		return -ENODEV;
	}
	remap_size = res->end - res->start + 1;
	if (!request_mem_region(res->start, remap_size, pdev->name)) {
		dev_err(&pdev->dev, "Cannot request IO\n");
	return -ENXIO;
	}
	printk("base_addr is at %#x, device is %#x bytes long\n", (unsigned int)res->start, (unsigned int)remap_size);
	reg_addr = ioremap_nocache(res->start, 0x4);
	if (reg_addr == NULL) {
		dev_err(&pdev->dev, "Couldn't ioremap memory at 0x%08lx\n", (unsigned long)res->start);
		ret = -ENOMEM;
		goto err_release_region;
	}
	dft_proc_entry = proc_create(DRIVER_NAME, 0, NULL,
	&proc_dft_operations);
	if (dft_proc_entry == NULL) {
		dev_err(&pdev->dev, "Couldn't create proc entry\n");
		ret = -ENOMEM;
		goto err_create_proc_entry;
	}
	printk(KERN_INFO DRIVER_NAME " probed at VA 0x%08lx\n",(unsigned long) reg_addr);
	printk(KERN_INFO DRIVER_NAME " is configured with FT_SIZE = %d\n", FT_SIZE);
	return 0;

err_create_proc_entry:
	iounmap(reg_addr);
err_release_region:
	release_mem_region(res->start, remap_size);
	return ret;
}

/* -----------------------------------
* Before dft shutdown, turn-off all the leds
*/
static void dft_shutdown(struct platform_device *pdev)
{
	printk("Exit dft Module. \n");	// print unload message
}

/* device match table to match with device node in device tree */
static const struct of_device_id dft_of_match[] = {
	{.compatible = "xlnx,fourier-transform-dft-v1-0-1.0"},
	{},
};

MODULE_DEVICE_TABLE(of, dft_of_match);

/* platform driver structure for dft driver */
static struct platform_driver dft_driver = {
	.driver = {
		.name = DRIVER_NAME,
		.owner = THIS_MODULE,
		.of_match_table = dft_of_match},
		.probe = dft_probe,
		.remove = dft_remove,
		.shutdown = dft_shutdown
};

/* Register dft platform driver */
module_platform_driver(dft_driver);

/* Module Infomations */
MODULE_AUTHOR("Andreas Dejmek");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION(DRIVER_NAME ": dft driver");
MODULE_ALIAS(DRIVER_NAME);