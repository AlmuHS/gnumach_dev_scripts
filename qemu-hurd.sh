#+BEGIN_SRC sh :results output :exports both
#!/bin/bash
#modprobe kvm
#modprobe kvm_intel
#qemu-img create -f qcow2 hurd.img 20G
MEMORY=2G
FILE="$HOME/hurd_qemu/hurd.img"
CDROM="$HOME/Descargas/debian-sid-hurd-i386-DVD-1.iso"
# If I ever need to add a cdrom
    echo "running ssh"

BOOT='order=c'

#Number of cpus to use in the VM
NCPUS=1

#regex to check if variable is a number
re='^[0-9]+$'
#if installer mode is selected, the VM boots from CD/DVD drive
if [[ $1 == "-i" || $1 == "--install" ]];
then
	echo "installer mode"
	BOOT='order=d'
fi

#List of arguments for Qemu
OPTIONS="-s -device ahci,id=ahci1 												\
                     -drive id=root,if=none,media=disk,format=raw,file=$FILE \
										 -device ide-hd,drive=root,bus=ahci1.1				 \
										 -drive id=cd,if=none,file=$CDROM,media=cdrom					\
										 -device ide-cd,drive=cd\
                     -boot $BOOT -accel kvm                                     \
                     -netdev user,id=net1,net=192.168.76.0/24,dhcpstart=192.168.76.5,hostfwd=tcp:127.0.0.1:2222-:22     \
                     -device e1000,netdev=net1
                     -display gtk"				


#if no arguments, the system run from harddisk instead install
#in both cases, KVM is enabled

#if debug mode is selected, we set some flags in qemu to ease the debugging
if [[ $1 == '-D' || $1 == '--debug' ]]; then
	echo "debug mode"
	
	#The shutdown and reboot are disable, to allow see kernel panic messages. And the machine starts paused, to allow connect remote debugger 
	OPTIONS="-S $OPTIONS -no-reboot -no-shutdown" 
	
	#The number of cpus also can be set as second parameter
	if [[ $2 =~  $re ]] && [[ $2 -gt 1 ]];
	then
		NCPUS=$2
	fi
elif [[ $1 =~  $re ]];
then	
	#if first parameter is a number, set this number as the amount of cpus to use
	NCPUS=$1
fi

echo "Using $NCPUS cpus"
qemu-system-i386 -M q35 -m $MEMORY $OPTIONS -smp $NCPUS
