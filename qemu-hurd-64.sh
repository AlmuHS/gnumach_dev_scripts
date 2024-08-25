#+BEGIN_SRC sh :results output :exports both
#!/bin/bash
#modprobe kvm
#modprobe kvm_intel
#qemu-img create -f qcow2 hurd.img 20G
MEMORY=8G
FILE="$HOME/hurd_qemu/hurd64.img"
CDROM="$HOME/Descargas/debian-sid-hurd-amd64-NETINST-1.iso"
# If I ever need to add a cdrom
    echo "running ssh"

BOOT='order=c'

#if installer mode is selected, the VM boots from CD/DVD drive
if [[ $1 == "-i" || $1 == "--install" ]];
then
	echo "installer mode"
	BOOT='order=d'
fi

#List of arguments for Qemu
OPTIONS="-s 										
         -drive id=root,if=none,media=disk,format=raw,file=$FILE \
		 -device ide-hd,drive=root				 \
		 -cdrom $CDROM		\
         -boot $BOOT -accel kvm                                     \
         -netdev user,id=net1,net=192.168.76.0/24,dhcpstart=192.168.76.5,hostfwd=tcp:127.0.0.1:2222-:22     \
         -device e1000,netdev=net1
         -display gtk"				


#if debug mode is selected, we set some flags in qemu to ease the debugging
if [[ $1 == '-D' || $1 == '--debug' ]]; then
	echo "debug mode"
	
	#The shutdown and reboot are disable, to allow see kernel panic messages. And the machine starts paused, to allow connect remote debugger 
	OPTIONS="-S $OPTIONS -no-reboot -no-shutdown" 
fi

qemu-system-x86_64 -M q35 -m $MEMORY $OPTIONS
