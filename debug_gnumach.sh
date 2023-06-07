NCPUS=$1

if [[ $# -lt 1 ]];
then
	NCPUS=1
fi

./qemu-hurd.sh -D $NCPUS &
cd $HOME/gnumach/build
gdb ./gnumach -ex 'target remote:1234'
