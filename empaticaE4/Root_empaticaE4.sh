#!/bin/sh

package_name=com.example.anwender.empaticae4
APK_file=/system/app/empaticaE4/empaticaE4.apk
Filepath=/storage/emulated/0/E4
#~ emptyhash="00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

# check if app is already installed
is_installed=`pm list packages $package_name`
if test -n "$is_installed"; then
	echo "EmpaticaE4 app is already installed." > /dev/kmsg
else
	echo "EmpaticaE4 app is not yet installed." > /dev/kmsg
	echo "To install the app enter this command:" > /dev/kmsg
	echo "pm install $APK_file" > /dev/kmsg
fi

# make work dir if not exists
if [ ! -d $Filepath ]; then
	mkdir -p $Filepath
fi


cd $Filepath
#~ rm *

while [ 1 ]; do
	sleep 10
		
	# control for Xilinx FFT
	if [ -f "xfft_input.txt" ]; then
		echo "xfft_input.txt exists." > /dev/kmsg
		
		# delete old output file
		rm xfft_output.txt
		
		while read line; do
			# read each line from file
			# and forward it to the fourier_transform module
			echo $line > /proc/fourier_transform
		done < xfft_input.txt
		
		# read fft output into file
		cat /proc/fourier_transform > xfft_output.txt
		
		rm xfft_input.txt
		
		echo "fourier transformation done." > /dev/kmsg
	fi
		
	# control for blake2b
	#~ if [ -f "$Filepath/blake2b.txt" ]; then
		#~ echo "blake2b.txt exists." > /dev/kmsg
		#~ rm $Filepath/hash.txt
		#~ rm $Filepath/tmp.txt
		
		#~ # cat bitstream to null device, otherwise the kernel module will fail 
		#~ cat "$( < blake2b.txt )" > /dev/null
		
		#~ # echo bitstream to blake2b kernel module
		#~ echo "$( < blake2b.txt )" > /proc/blake2b
		
		#~ # wait for hash to complete
		#~ sleep 0.1
		
		#~ # read blake2b kernel module
		#~ cat /proc/blake2b > $Filepath/tmp.txt
		
		#~ # check if hash is written
		#~ isInFile=$(cat tmp.txt | grep -c "$emptyhash")

		#~ while [ $isInFile -ne 0 ]; do
			#~ # wait for hash to complete
			#~ sleep 0.05
			
			#~ # read blake2b kernel module
			#~ cat /proc/blake2b > $Filepath/tmp.txt
		
			#~ # check if hash is written
			#~ isInFile=$(cat tmp.txt | grep -c "$emptyhash")
		#~ done
			
		#~ cp tmp.txt hash.txt 
		
		#~ rm $Filepath/blake2b.txt
		
		#~ echo "blake2b operation done." > /dev/kmsg
	#~ fi
	
	# control for partial reconfiguration
	#~ if [ -f "$Filepath/partial.txt" ]; then
		#~ echo "partial.txt exists." > /dev/kmsg
		
		#~ # set variables
		#~ bitpath="$( < partial.txt )"
		#~ echo $bitpath > /dev/null
		#~ bit=${bitpath##*/}
		#~ echo $bit > /dev/null
		
		#~ # set flags for partial bitstream
		#~ echo 1 > /sys/class/fpga_manager/fpga0/flags
		
		#~ # load partial bitstream
		#~ cp $bitpath /lib/firmware
		#~ echo $bit > /sys/class/fpga_manager/fpga0/firmware
		
		#~ # control LEDs dependent on the filter reconfigured
		#~ if [ $bit = "blue_filter.bin" ]; then 
			#~ echo 0x03 > /proc/myled
		#~ elif [ $bit = "green_filter.bin" ]; then 
			#~ echo 0x18 > /proc/myled
		#~ elif [ $bit = "red_filter.bin" ]; then 
			#~ echo 0C0 > /proc/myled
		#~ else
			#~ echo 0x00 > /proc/myled
		#~ fi
		 
		#~ rm $Filepath/partial.txt
		
		#~ echo "partial operation done." > /dev/kmsg
	#~ fi		
done
