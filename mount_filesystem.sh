#!/bin/bash

#my Debian GNU/Hurd's installation has 3 disk partitions. /boot is in the first
DISK_OFFSET=$(sudo fdisk -l ~/hurd_qemu/hurd.img | grep img1 | cut -d " " -f 13)

#The real offset is get multiplying sector size (512 in this case) for the previous offset returned by fdisk
OFFSET=$(($DISK_OFFSET*512))

echo "Mounting qemu image in /mnt"
sudo mount -o loop,offset=$OFFSET ~/hurd_qemu/hurd.img /mnt	


