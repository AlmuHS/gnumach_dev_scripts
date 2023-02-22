./qemu-hurd.sh &
cd $HOME/gnumach/build
gdb ./gnumach -ex 'target remote:1234'
