#!/bin/bash

NUM_CPUS=$1
if [[ $# -eq 0 ]];
then
	NUM_CPUS=1
fi


cd $HOME/gnumach
rm -rf build
mkdir build
cd build
../configure --host=i686-gnu CC='gcc -m32' LD='ld -melf_i386' --enable-apic --enable-kdb --enable-ncpus=$NUM_CPUS --disable-ide --disable-linux-groups
make gnumach.gz
