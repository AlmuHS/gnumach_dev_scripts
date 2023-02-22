#!/bin/bash

#modprobe kvm
#modprobe kvm_intel
#qemu-img create -f qcow2 hurd.img 20G
MEMORY=4G
FILE="$HOME/hurd_qemu/hurd.img"
CDROM="$HOME/Descargas/debian-sid-hurd-i386-DVD-1.iso"
# If I ever need to add a cdrom
    echo "running ssh"

OPTIONS="-device ahci,id=ahci1 												\
                     -drive id=root,if=none,media=disk,format=raw,file=$FILE \
										 -device ide-hd,drive=root,bus=ahci1.1				 \
										 -drive id=cd,file=$CDROM,media=cdrom					\
                     -smp 8                                       \
                     -boot d                                      \
                     -net user,hostfwd=tcp:127.0.0.1:2222-:22     \
                     -net nic,model=e1000                      \
                     -no-reboot                                   \
                     -no-shutdown                                 \
                     -vga std                                     \
                     -display gtk"				

if [[ "$1" = "--runtime" ]];
then
	echo "kvm enabled"
	OPTIONS="$OPTIONS -enable-kvm"
fi

qemu-system-i386 -S -s -m $MEMORY "$OPTIONS" 
                     # -machine kernel_irqchip=off                  \
                     #					\
                     #-drive id=root,if=none,format=raw,media=disk,file=/dev/sdb \
