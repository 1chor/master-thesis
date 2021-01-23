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
#define DRIVER_NAME	"fourier_transform"

#define MAX_SIZE 50000

//unsigned long *base_addr;	/* Vitual Base Address */
unsigned long *input_reg_addr;
unsigned long *output_reg_addr;
struct resource *res;		/* Device Resource Structure */
unsigned long remap_size;	/* Device Memory Size */

static u64 data_write[MAX_SIZE];
static u64 data_read[MAX_SIZE];

static u64 input[MAX_SIZE];
static u8 output[4 * MAX_SIZE];
  
static struct file *filp = NULL;
static u32 filesize = 0;

/* Write operation for /proc/fourier_transform
* -----------------------------------
* When user cat a string to /proc/fourier_transform file, the string will be stored in
* const char __user *buf. The File in that path will be opened and the fourier_transform
* hash will be generated in the logic fabric.
*/
static ssize_t proc_fourier_transform_write(struct file *file, const char __user * buf, size_t count, loff_t * ppos)
{
	char filename[64];
	mm_segment_t oldfs;
	int ret;
	u32 i;

	printk(KERN_DEBUG "Here I am: %s:%i\n", __FILE__, __LINE__);
	
	if(filp > 0 && !IS_ERR(filp))
	{
		printk("fourier_transform Module busy");
		return -EFAULT;
	}

	if (count < 64) {
		if (copy_from_user(filename, buf, count))
			return -EFAULT;
		filename[count-1] = '\0';
	}
	
	printk(KERN_DEBUG "Filename: %s\n", filename);
	
	filp = filp_open(filename, O_RDONLY, 0);

	printk(KERN_DEBUG "Here I am: %s:%i\n", __FILE__, __LINE__);
	
	if(IS_ERR(filp))
	{
		printk("File \"%s\" is invalid\n", filename);
		return -EFAULT;
	}

	printk(KERN_DEBUG "Here I am: %s:%i\n", __FILE__, __LINE__);
	
	filesize = vfs_llseek(filp, 0, SEEK_END);
	vfs_llseek(filp, 0, 0);
	printk("File %s is %u (0x%x) bytes long\n", filename, filesize, filesize);

	printk(KERN_DEBUG "Here I am: %s:%i\n", __FILE__, __LINE__);
		
	if ((filesize/4) > MAX_SIZE)
	{
		printk("Size of the file (%u bytes) is bigger than actual configured size (%u bytes) in device driver!\n", filesize, (MAX_SIZE*4));
	}
	
	printk(KERN_DEBUG "Here I am: %s:%i\n", __FILE__, __LINE__);
	
	//read from file
	oldfs = get_fs();
	set_fs(get_ds());
	ret = kernel_read(filp, &input, filesize, &filp->f_pos);
	set_fs(oldfs);
	
	printk(KERN_DEBUG "Here I am: %s:%i\n", __FILE__, __LINE__);
	
	//close file
	if(filp > 0)
		filp_close(filp, 0);
	filp = NULL;
	
	if(filesize != ret)
	{
		printk("Could only read %u bytes, need %u\n",ret,filesize);
	}
	
	for (i = 0; i < (filesize); i++)
	{
		printk("Input[%d]: %llx\n", i, input[i]);
	}
	
	printk(KERN_DEBUG "Here I am: %s:%i\n", __FILE__, __LINE__);
	
	for (i = 0; i < (filesize/4); i++)
	{
		data_write[i] = (((u64)input[4*i]) << 56u) | (((u64)input[(4*i) + 1u]) << 48u) | (((u64)input[(4*i) + 2u]) << 40u) | (((u64)input[(4*i) + 3u]) << 32u) | (((u64)input[(4*i) + 4u]) << 24u) | (((u64)input[(4*i) + 5u]) << 16u) | (((u64)input[(4*i) + 6u]) << 8u) | (((u64)input[(4*i) + 7u])); 
	}
	
	printk(KERN_DEBUG "Here I am: %s:%i\n", __FILE__, __LINE__);
	
	//for (i = 0; i < (filesize/4); i++)
	//{
		//printk(KERN_DEBUG "Here I am: %s:%i\n", __FILE__, __LINE__);
		////Write data to fourier transformation
		//wmb();
		//iowrite64(data_write[i], input_reg_addr);
		////udelay(10);
		////wmb();
		////image_data_read[i] = ioread32(output_reg_addr);
		////udelay(10);
	//}

	printk(KERN_DEBUG "Here I am: %s:%i\n", __FILE__, __LINE__);

	return count;
}

/* Callback function when opening file /proc/fourier_transform
* ------------------------------------------------------
* Return the generated hash
*/

static int proc_fourier_transform_show(struct seq_file *p, void *v)
{
	int i;
	for(i = 0; i < (filesize/4); i++)
	{
		//wmb();
		//data_read[i] = ioread32(output_reg_addr);
		seq_printf(p, "%16llx", data_read[i]);
	}
	return 0;
}

/* Open function for /proc/fourier_transform
* ------------------------------------
* When user want to read /proc/fourier_transform (i.e. cat /proc/fourier_transform), the open function
* will be called first. In the open function, a seq_file will be prepared and the
* status of fourier_transform will be filled into the seq_file by proc_fourier_transform_show function.
*/
static int proc_fourier_transform_open(struct inode *inode, struct file *file)
{
	unsigned int size = 16;
	char *buf;
	struct seq_file *m;
	int res;
	buf = (char *)kmalloc(size * sizeof(char), GFP_KERNEL);
	if (!buf)
		return -ENOMEM;
	res = single_open(file, proc_fourier_transform_show, NULL);
	if (!res) {
		m = file->private_data;
		m->buf = buf;
		m->size = size;
	} else {
		kfree(buf);
	}
	return res;
}

/* File Operations for /proc/fourier_transform */
static const struct file_operations proc_fourier_transform_operations = {
	.open = proc_fourier_transform_open,
	.read = seq_read,
	.write = proc_fourier_transform_write,
	.llseek = seq_lseek,
	.release = single_release
};

/* Remove function for fourier_transform
* ----------------------------------
* When fourier_transform module is removed, release virtual address and the memory
* region requested.
*/
static int fourier_transform_remove(struct platform_device *pdev)
{
	/* Remove /proc/fourier_transform entry */
	remove_proc_entry(DRIVER_NAME, NULL);
	/* Release mapped virtual address */
	iounmap(input_reg_addr);
	iounmap(output_reg_addr);
	/* Release the region */
	release_mem_region(res->start, remap_size);
	return 0;
}

/* Device Probe function for fourier_transform
* ------------------------------------
* Get the resource structure from the information in device tree.
* request the memory regioon needed for the controller, and map it into
* kernel virtual memory space. Create an entry under /proc file system
* and register file operations for that entry.
*/
static int fourier_transform_probe(struct platform_device *pdev)
{
	struct proc_dir_entry *fourier_transform_proc_entry;
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
	input_reg_addr = ioremap_nocache(res->start, 0x4);
	output_reg_addr = ioremap_nocache(res->start+0x4, 0x4);
	if (input_reg_addr == NULL || output_reg_addr == NULL) {
		dev_err(&pdev->dev, "Couldn't ioremap memory at 0x%08lx\n",
		(unsigned long)res->start);
		ret = -ENOMEM;
		goto err_release_region;
	}
	fourier_transform_proc_entry = proc_create(DRIVER_NAME, 0, NULL,
	&proc_fourier_transform_operations);
	if (fourier_transform_proc_entry == NULL) {
		dev_err(&pdev->dev, "Couldn't create proc entry\n");
		ret = -ENOMEM;
		goto err_create_proc_entry;
	}
	printk(KERN_INFO DRIVER_NAME " probed at VA 0x%08lx\n",(unsigned long) input_reg_addr);
	return 0;

err_create_proc_entry:
	iounmap(input_reg_addr);
	iounmap(output_reg_addr);
err_release_region:
	release_mem_region(res->start, remap_size);
	return ret;
}

/* -----------------------------------
* Before fourier_transform shutdown, turn-off all the leds
*/
static void fourier_transform_shutdown(struct platform_device *pdev)
{
	if(filp > 0)
		filp_close(filp, 0);
	printk("Exit fourier_transform Module. \n");	// print unload message
}

/* device match table to match with device node in device tree */
static const struct of_device_id fourier_transform_of_match[] = {
	{.compatible = "xlnx,fourier-transform-v1-0-1.0"},
	{},
};

MODULE_DEVICE_TABLE(of, fourier_transform_of_match);

/* platform driver structure for fourier_transform driver */
static struct platform_driver fourier_transform_driver = {
	.driver = {
		.name = DRIVER_NAME,
		.owner = THIS_MODULE,
		.of_match_table = fourier_transform_of_match},
		.probe = fourier_transform_probe,
		.remove = fourier_transform_remove,
		.shutdown = fourier_transform_shutdown
};

/* Register fourier_transform platform driver */
module_platform_driver(fourier_transform_driver);

/* Module Infomations */
MODULE_AUTHOR("Andreas Dejmek");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION(DRIVER_NAME ": fourier_transform driver");
MODULE_ALIAS(DRIVER_NAME);
