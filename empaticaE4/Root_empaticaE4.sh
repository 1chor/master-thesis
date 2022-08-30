#!/bin/sh

package_name=com.example.anwender.empaticae4
APK_file=/system/app/empaticaE4/empaticaE4.apk
Filepath=/storage/emulated/0/E4
TestData=BVP1.csv
emptyhash="00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

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

# copy TestData file if not exists in work dir
if [ ! -f $Filepath/$TestData ]; then
	cp /data/$TestData $Filepath
fi

cd $Filepath
#~ rm *

while [ 1 ]; do
	sleep 1
		
	# control for Xilinx DFT
	if [ -f "xdft_input.txt" ]; then
		echo "xdft_input.txt exists." > /dev/kmsg
		
		while read line; do
			# read each line from file
			# and forward it to the fourier_transform module
			echo $line > /proc/fourier_transform
		done < xdft_input.txt
				
		sleep 0.5
		
		# read dft output into file
		cat /proc/fourier_transform > xdft_output.txt
		
		# delete input file
		if [ -f xdft_input.txt ]; then
			rm xdft_input.txt
		fi
		
		echo "fourier transformation done." > /dev/kmsg
	fi
	
	###################################################################
	
	# control for Xilinx FFT (floating-point)
	if [ -f "xfft_input.txt" ]; then
		echo "xfft_input exists." > /dev/kmsg
		
		# delete file
		rm xfft_input.txt
		# delete old output file
		if [ -f xfft_output.txt ]; then
			rm xfft_output.txt
		fi
		
		for i in xfft_input*.txt; do
			while read line; do
				# read each line from file
				# and forward it to the fourier_transform module
						
				echo $line > /proc/fourier_transform	
			done < "$i"
			
			sleep 0.5
			
			# read fft output into file
			cat /proc/fourier_transform >> xfft_output.txt
		done
		
		sleep 0.2
		
		touch xfft_ready.txt
		
		# delete input file
		if [ -f xfft_input0.txt ]; then
			rm xfft_input*.txt
		fi
		
		echo "fourier transformation done." > /dev/kmsg
	fi
	
	###################################################################
	
	# control for Xilinx FFT (fixed-point)
	if [ -f "xfft_fixed_input.txt" ]; then
		echo "xfft_fixed_input.txt exists." > /dev/kmsg
		
		while read line; do
			# read each line from file
			# and forward it to the fourier_transform module
			echo $line > /proc/fourier_transform
		done < xfft_fixed_input.txt
				
		sleep 0.5
		
		# read fft output into file
		cat /proc/fourier_transform > xfft_fixed_output.txt
		
		# delete input file
		if [ -f xfft_fixed_input.txt ]; then
			rm xfft_fixed_input.txt
		fi
		
		echo "fourier transformation done." > /dev/kmsg
	fi
	
	###################################################################
	
	# control for Fully pipelined integer unscaled FFT
	if [ -f "intfftk_input.txt" ]; then
		echo "intfftk_input.txt exists." > /dev/kmsg
		
		while read line; do
			# read each line from file
			# and forward it to the fourier_transform module
			echo $line > /proc/fourier_transform
		done < intfftk_input.txt
				
		sleep 0.5
		
		# read fft output into file
		cat /proc/fourier_transform > intfftk_output.txt
		
		# delete input file
		if [ -f intfftk_input.txt ]; then
			rm intfftk_input.txt
		fi
		
		echo "fourier transformation done." > /dev/kmsg
	fi
	
	###################################################################
	
	# control for Integer unscaled Radix-2 Single Path Delay Feedback FFT
	if [ -f "intfft_spdf_input.txt" ]; then
		echo "intfft_spdf_input.txt exists." > /dev/kmsg
		
		while read line; do
			# read each line from file
			# and forward it to the fourier_transform module
			echo $line > /proc/fourier_transform
		done < intfft_spdf_input.txt
				
		sleep 0.5
		
		# read fft output into file
		cat /proc/fourier_transform > intfft_spdf_output.txt
		
		# delete input file
		if [ -f intfft_spdf_input.txt ]; then
			rm intfft_spdf_input.txt
		fi
		
		echo "fourier transformation done." > /dev/kmsg
	fi
	
	###################################################################
	
	# control for Generic Pipelined FFT
	if [ -f "dblclkfft_input.txt" ]; then
		echo "dblclkfft_input.txt exists." > /dev/kmsg
		
		while read line; do
			# read each line from file
			# and forward it to the fourier_transform module
			echo $line > /proc/fourier_transform
		done < dblclkfft_input.txt
				
		sleep 0.5
		
		# read fft output into file
		cat /proc/fourier_transform > dblclkfft_output.txt
		
		# delete input file
		if [ -f dblclkfft_input.txt ]; then
			rm dblclkfft_input.txt
		fi
		
		echo "fourier transformation done." > /dev/kmsg
	fi
	
	###################################################################
		
	# control for blake2b
	if [ -f "blake2b.txt" ]; then
		echo "blake2b.txt exists." > /dev/kmsg
				
		# cat bitstream to null device, otherwise the kernel module will fail 
		cat "$( < blake2b.txt )" > /dev/null
		
		# echo bitstream to blake2b kernel module
		echo "$( < blake2b.txt )" > /proc/blake2b
		
		# wait for hash to complete
		sleep 0.1
		
		# read blake2b kernel module
		cat /proc/blake2b > tmp.txt
		
		# check if hash is written
		isInFile=$(cat tmp.txt | grep -c "$emptyhash")

		while [ $isInFile -ne 0 ]; do
			# wait for hash to complete
			sleep 0.05
			
			# read blake2b kernel module
			cat /proc/blake2b > tmp.txt
		
			# check if hash is written
			isInFile=$(cat tmp.txt | grep -c "$emptyhash")
		done
			
		cp tmp.txt hash.txt 
		
		# delete tmp file
		if [ -f tmp.txt ]; then
			rm tmp.txt
		fi
		
		# delete blake2b file
		if [ -f blake2b.txt ]; then
			rm blake2b.txt
		fi
		
		echo "blake2b operation done." > /dev/kmsg
	fi
	
	###################################################################
	
	# control for partial reconfiguration
	if [ -f "partial.txt" ]; then
		echo "partial.txt exists." > /dev/kmsg
		
		# set variables
		bit="$( < partial.txt )"
		#bitpath="$( < partial.txt )"
		#echo $bitpath > /dev/null
		#bit=${bitpath##*/}
		echo $bit > /dev/null
		
		# set flags for partial bitstream
		echo 1 > /sys/class/fpga_manager/fpga0/flags
		
		# load partial bitstream
		cp $bit /lib/firmware
		echo $bit > /sys/class/fpga_manager/fpga0/firmware
		
		# read status of fpga manager
		state = "$(cat /sys/class/fpga_manager/fpga0/state)"

		while [ $state != "operating" ]; do # wait until configuration is completed
			# wait for hash to complete
			sleep 0.01
			
			# read status of fpga manager
			state = "$(cat /sys/class/fpga_manager/fpga0/state)"
		done 
		
		# unload fourier_transform kernel module
		rmmod fourier_transform
		
		# load fourier_transform module with defined size 
		# control LEDs dependent on the filter reconfigured
		if [ $bit = "xdft.bin" ]; then 
			insmod /data/modules/fourier_transform.ko FT_SIZE=108
			echo 0x01 > /proc/myled
		elif [ $bit = "xfft.bin" ]; then 
			insmod /data/modules/fourier_transform.ko FT_SIZE=128
			echo 0x02 > /proc/myled
		elif [ $bit = "xfft-fixed.bin" ]; then 
			insmod /data/modules/fourier_transform.ko FT_SIZE=128
			echo 004 > /proc/myled
		elif [ $bit = "intfftk.bin" ]; then 
			insmod /data/modules/fourier_transform.ko FT_SIZE=128
			echo 008 > /proc/myled
		elif [ $bit = "intfft_spdf.bin" ]; then 
			insmod /data/modules/fourier_transform.ko FT_SIZE=128
			echo 010 > /proc/myled
		elif [ $bit = "dblclkfft.bin" ]; then 
			insmod /data/modules/fourier_transform.ko FT_SIZE=128
			echo 020 > /proc/myled
		else
			insmod /data/modules/fourier_transform.ko FT_SIZE=128 #default size
			echo 0x00 > /proc/myled
		fi
		
		# delete bitstream file (local)
		if [ -f  $bit ]; then
			rm  $bit
		fi
		
		# delete bitstream file (firmware)
		if [ -f  /lib/firmware/$bit ]; then
			rm  /lib/firmware/$bit
		fi
		
		# delete partial file
		if [ -f partial.txt ]; then
			rm partial.txt
		fi
		
		echo "partial operation done." > /dev/kmsg
	fi		
done
