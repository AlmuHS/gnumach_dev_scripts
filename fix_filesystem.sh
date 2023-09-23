#!/bin/bash

sudo losetup -P  /dev/loop0 ~/hurd_qemu/hurd.img
sudo e2fsck -y /dev/loop0p1
