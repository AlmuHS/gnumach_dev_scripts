#!/bin/bash

#install dependencies
sudo apt install mig-i686-gnu gcc-multilib

#download sources
git clone https://git.savannah.gnu.org/cgit/hurd/gnumach.git
cd gnumach

autoreconf --install
./compile_scratch.sh
