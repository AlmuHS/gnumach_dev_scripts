./qemu-hurd.sh -D &
cd $HOME/gnumach/build
gdb ./gnumach -ex 'target remote:1234'
