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

if [[ $1 == "-i" || $1 == "--install" ]];
then
	echo "installer mode"
	BOOT='order=d'
fi

OPTIONS="-device ahci,id=ahci1 												\
                     -drive id=root,if=none,media=disk,format=raw,file=$FILE \
										 -device ide-hd,drive=root,bus=ahci1.1				 \
										 -drive id=cd,file=$CDROM,media=cdrom					\
                     -smp 8                                       \
                     -boot $BOOT                                      \
                     -net user,hostfwd=tcp:127.0.0.1:2222-:22     \
                     -net nic,model=e1000                      \
                     -vga std                                     \
                     -display gtk"

if [[ $# -eq 0 ||  $1 == "-i" || $1 == "--install" ]];
then
	echo "kvm enabled"
	OPTIONS="$OPTIONS -enable-kvm"
elif [[ $1 == '-D' || $1 == '--debug' ]];
then
	echo "debug mode"
	OPTIONS="-S $OPTIONS -no-reboot -no-shutdown"
fi

qemu-system-i386 -s -m $MEMORY $OPTIONS 
                     # -machine kernel_irqchip=off                  \
                     #					\
                     #-drive id=root,if=none,format=raw,media=disk,file=/dev/sdb \
