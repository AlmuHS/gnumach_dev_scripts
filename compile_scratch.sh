#!/bin/bash

#sudo apt install mig-i686-gnu

SRC_PATH="$HOME/GNUMach_SMP"

NUM_CPUS=$1
if [[ $# -eq 0 ]];
then
	NUM_CPUS=1
fi


cd $SRC_PATH
rm -rf build
autoreconf --install
mkdir build
cd build
echo "compiling for $NUM_CPUS cpus"
../configure --host=i686-gnu CC='gcc -m32' LD='ld -melf_i386' --enable-apic --enable-kdb --enable-ncpus=$NUM_CPUS --disable-linux-groups
make gnumach.gz
