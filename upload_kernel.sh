GNUMACH_PATH=$HOME/gnumach/build #directory where the kernel is stored

IP=127.0.0.1 #IP of remote machine. localhost by default
PORT=22 #port of rsync for remote machine. By default is 22, the standard of ssh

#Copy to a remote destination via rsync
if [[ $1 == "-r" ]];
then
	USER=$2

    #if there are at least 3 parameters, the third will be the IP address
    if [[ $# -ge 3 ]];
    then
        IP=$3
    fi

    #if there are 4 parameters, the latest is the port
    if [[ $# -eq 4 ]];
    then
      PORT=$4  
    fi

    #copy the kernel file from the local build directory to the home directory of the remote machine. To allow set a different port than default, we configure this in ssh
	rsync -avz -e "ssh -p $PORT" $GNUMACH_PATH/gnumach.gz $USER@$IP:/home/$USER

#copy to a local image, mounting the image as a filesystem and copying the file 
else
	#my Debian GNU/Hurd's installation has 3 disk partitions. /boot is in the first
	DISK_OFFSET=$(sudo fdisk -l ~/hurd_qemu/hurd.img | tail -n 3 | head -n 1 | cut -d " " -f 13)
	
	#The real offset is get multiplying sector size (512 in this case) for the previous offset returned by fdisk
	OFFSET=$(($DISK_OFFSET*512))
	
	echo "Mounting qemu image in /mnt"
	sudo mount -o loop,offset=$OFFSET ~/hurd_qemu/hurd.img /mnt

	echo "copying gnumach.gz to /boot"
	cd $GNUMACH_PATH
	sudo cp gnumach.gz /mnt/boot/gnumach-smp.gz
	ls /mnt/boot
	
	sudo umount /mnt
	echo "unmounting"
fi
