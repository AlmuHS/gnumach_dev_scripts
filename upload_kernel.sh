if [[ $1 == "-r" ]];
then
	USER=$2
	rsync -avz -e "ssh -p 2222" ~/gnumach/build/gnumach.gz $USER@127.0.0.1:/home/$USER
else
	#my Debian GNU/Hurd's installation has 3 disk partitions. /boot is in the first
	DISK_OFFSET=$(sudo fdisk -l ~/hurd_qemu/hurd.img | tail -n 3 | head -n 1 | cut -d " " -f 13)
	
	#The real offset is get multiplying sector size (512 in this case) for the previous offset returned by fdisk
	OFFSET=$(($DISK_OFFSET*512))
	
	echo "Mounting qemu image in /mnt"
	sudo mount -o loop,offset=$OFFSET ~/hurd_qemu/hurd.img /mnt

	echo "copying gnumach.gz to /boot"
	cd $HOME/gnumach/build
	sudo cp gnumach.gz /mnt/boot/gnumach-smp.gz
	ls /mnt/boot
	
	sudo umount /mnt
	echo "unmounting"
fi
