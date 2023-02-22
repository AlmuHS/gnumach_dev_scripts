# gnumach developer's scripts

## List of files

### Virtual Machine

- **`create_vm.sh`** : create a new Debian GNU/Hurd VM in Qemu, allowing select between DVD-1 installer, or raw img file. The options available are:
	+ **`-i` or `--from-installer`**: download the DVD-1 iso image, create a new harddisk image, and open the VM in installing mode  
	
	+ **No arguments**: download the latest img file (preinstalled image), and open the VM from this image

- **`qemu-hurd.sh`**: run the Qemu VM, selecting differents booting modes.  
   The options available are:
	+ **`-i` or `--install`**: open the VM booting from CD/DVD image, and enabling KVM  
	
	+ **`-D` or `--debug`**: open the VM in debug mode, enabling `-S` option to start the VM in pause, and disabling KVM to ease the debugging
	
	+ **No options**: open the VM booting from the HDD image, enabling KVM
 
 	The VM configuration includes:
 	
 	- SATA CD/DVD drive, linked to iso image
 	- SATA HDD drive, linked to img file
 	- SMP mode, with 8 cpus
 	- Intel e1000 NIC
 	- Port redirection: 22 -> 2222, to allow ssh connection using 2222 port from host
 	- Graphic display in a GTK Window

### Developer environment

- **`prepare_environment.sh`**: Download the latest gnumach sources from upstream and make a first compilation.

- **`compile_scratch.sh`**: Compile gnumach from scratch, removing any other old compilation and restarting configure and make steps. **Receives as parameter the maximum number of cpus allowed by the kernel**

	The gnumach compiled includes the next configuration
	
	- APIC support
	- SMP support (disabled if the number of cpus is < 2)
	- enable kdb, for kernel debugging
	- Rumpdisk support, disabling old IDE and AHCI gnumach's drivers

- **`upload-kernel.sh`**: upload the new gnumach.gz file to the VM, using rsync + ssh  

- **`debug-gnumach.sh`**: Start a remote debugging environment, open gdb session + qemu VM in debug mode. **Receives as parameter the username of the VM machine**