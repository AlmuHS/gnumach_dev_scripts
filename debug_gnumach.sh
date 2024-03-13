NCPUS=$1
GNUMACH_PATH=$HOME/gnumach-sv

if [[ $# -lt 1 ]];
then
	NCPUS=1
fi

./qemu-hurd.sh -D $NCPUS &
cd $GNUMACH_PATH/build
gdb ./gnumach -ex 'target remote:1234'
