#!/bin/sh

trap cleanup 1 2 3 6 # catch interrupt signals and run function

cleanup() # function executed before exit
{
	echo "Restore battery status defaults." > /dev/kmsg
	
	dumpsys battery reset # reset battery status
	
	exit 1
}

### main script

dumpsys battery reset # reset battery status

sleep 2m # wait for 2 minutes

echo "+++++++++++++++++++++++++++++++++++++" > /dev/kmsg
echo "++                                 ++" > /dev/kmsg
echo "++ Start battery status simulation ++" > /dev/kmsg
echo "++                                 ++" > /dev/kmsg
echo "+++++++++++++++++++++++++++++++++++++" > /dev/kmsg

while [ 1 ]; do
		
	# XFFT
	dumpsys battery level 100 # change battery level to 100%
	dumpsys battery status 5  # change battery status to Full 

	sleep 1m # wait for 1 minute
	
	# XDFT
	dumpsys battery level 72  # change battery level to 72%
	dumpsys battery status 2  # change battery status to Charging  
	
	sleep 1m # wait for 1 minute
	
	# SDFT (Greybox)
	dumpsys battery level 12  # change battery level to 12%
	dumpsys battery status 2  # change battery status to Charging  

	sleep 1m # wait for 1 minute
	# XFFT
	dumpsys battery level 90  # change battery level to 90%
	dumpsys battery status 2  # change battery status to Charging  

	sleep 1m # wait for 1 minute
	
	# DBLCLKFFT
	dumpsys battery level 25  # change battery level to 25%
	dumpsys battery status 2  # change battery status to Charging  

	sleep 1m # wait for 1 minute
	
	# INTFFTK
	dumpsys battery level 49  # change battery level to 49%
	dumpsys battery status 2  # change battery status to Charging  

	sleep 1m # wait for 1 minute
	
	# XFFT-fixed
	dumpsys battery level 60  # change battery level to 60%
	dumpsys battery status 2  # change battery status to Charging  	
	
done
