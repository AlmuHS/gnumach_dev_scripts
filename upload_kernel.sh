cd $HOME/gnumach/build
USER=$1
rsync -avz -e "ssh -p 2222" ./gnumach.gz $USER@127.0.0.1:/home/$USER
