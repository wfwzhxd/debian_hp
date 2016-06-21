#!/bin/sh

dpkg --add-architecture i386
apt-get update
apt-get install libc6:i386 -y
apt-get install libsm6:i386 -y
apt-get install libxi6:i386 -y
apt-get install libxrender1:i386 -y
apt-get install libxrandr2:i386 -y
apt-get install libxcursor1:i386 -y
apt-get install libxinerama1:i386 -y
apt-get install libfreetype6:i386 -y
apt-get install libfontconfig1:i386 -y
apt-get install libstdc++6:i386 -y

install_dir=/home/hunter/bin
[ -d $install_dir ] || mkdir $install_dir
[ $? -ne 0 ] && echo "$install_dir not exists" && exit
self="`readlink -f "$0"`"
here="`dirname "$self"`"
cp -r "$here/Linux_Drcom" "$install_dir"

#chmod -R a+x "$install_dir/Linux_Drcom"


