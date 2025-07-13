OPTIONS="$1"
VM_OPTIONS=""

mkdir $HOME/hurd_qemu
cd $HOME/Descargas

if [[ $OPTIONS == "--from-installer" || $OPTIONS == "-i" ]];
then
	DVD_DOWNLOAD="https://cdimage.debian.org/cdimage/ports/latest/hurd-i386/current/debian-sid-hurd-i386-NETINST-1.iso"
	wget $DVD_DOWNLOAD
	
	qemu-img create -f raw $HOME/hurd_qemu/hurd.img 10G
	
	VM_OPTIONS="-i"
else
	if [[ ! -f debian-hurd.img.gz && ! -f debian-hurd.img ]]
	then
		IMG_DOWNLOAD="https://cdimage.debian.org/cdimage/ports/latest/hurd-i386/current/debian-hurd-20250622.img"
		wget $IMG_DOWNLOAD
		gzip -vd debian-hurd.img.gz
		mv debian-hurd.img $HOME/hurd_qemu/hurd.img
	fi
fi

cd -
./qemu-hurd.sh $VM_OPTIONS
