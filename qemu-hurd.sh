#+BEGIN_SRC sh :results output :exports both
#!/bin/bash
#modprobe kvm
#modprobe kvm_intel
#qemu-img create -f qcow2 hurd.img 20G
MEMORY=4G
FILE="$HOME/hurd_qemu/hurd.img"
CDROM="$HOME/Descargas/debian-sid-hurd-i386-DVD-1.iso"
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
OPTIONS="-device ahci,id=ahci1 												\
                     -drive id=root,if=none,media=disk,format=raw,file=$FILE \
										 -device ide-hd,drive=root,bus=ahci1.1				 \
										 -drive id=cd,if=none,file=$CDROM,media=cdrom					\
										 -device ide-cd,drive=cd\
                     -smp 8                                       \
                     -boot $BOOT                                      \
                     -net user,hostfwd=tcp:127.0.0.1:2222-:22     \
                     -net nic,model=e1000                      \
                     -vga std                                     \
                     -display gtk"				

#if no arguments, the system run from harddisk instead install
#in both cases, KVM is enabled
if [[ $# -eq 0 ||  $1 = "-i" || $1 = "--install" ]];
then
	echo "kvm enabled"
	OPTIONS="$OPTIONS -enable-kvm"
#The debug mode doesn't use KVM to ease debugging. Also starts the VM in pause, to allow to prepare gdb before booting
elif [[ $1 = '-D' || $1 = '--debug' ]];
then
	echo "debug mode"
	OPTIONS="-S $OPTIONS -no-reboot -no-shutdown"
fi

qemu-system-i386 -s -M q35 -m $MEMORY $OPTIONS 
