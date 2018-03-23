#!/bin/bash
#######################
#
# This is a provision script
# it will be called once when the vagrant vm is first provisioned
# If you have commands that you want to run always please have a
# look at the bootstrap.sh script
#
# Contributor: Bernhard Blieninger
######################
if [ $USER == "ubuntu" ]; then
  make packages
  # uncomment the following line if you want to 'visually' access the virtual machine
  #sudo apt-get install alsa-base alsa-utils pulseaudio pulseaudio-utils ubuntu-desktop
fi

# change directory to /vagrant
if [ $USER == "ubuntu" ]; then
  cd /vagrant
fi
# clean contrib
rm -rf genode/contrib/
# initialize and update submodules
git submodule update --init
# download and extract toolchain
wget -nc --quiet https://sourceforge.net/projects/genode/files/genode-toolchain/16.05/genode-toolchain-16.05-x86_64.tar.bz2/download -O genode-toolchain-16.05-x86_64.tar.bz2
if [ $(groups | grep -o "if13praktikum") ]; then
  tar xfj genode-toolchain-16.05-x86_64.tar.bz2 -C /var/tmp
  chmod -R g+w /var/tmp/usr/
else
  sudo tar xPfj genode-toolchain-16.05-x86_64.tar.bz2
fi
# download and extract libports
# wget -nc --quiet https://nextcloud.os.in.tum.de/s/KVfFOeRXVszFROl/download -O libports.tar.bz2
# tar xfj libports.tar.bz2 -C genode
if [ $USER == "ubuntu" ]; then
  # prepare ports, ...
  sudo make vagrant
  # change owner of /build
  sudo chown -R ubuntu /build
  # change password of user ubuntu to vagrant
  echo ubuntu:vagrant | sudo chpasswd
else
  # prepare ports, ...
  make vagrant
fi

if [ $(groups | grep -o "if13praktikum") ]; then
  echo Adding /usr/local/dist/DIR/f13 to PATH
  export PATH=/usr/local/dist/DIR/f13:$PATH
  echo New path is: $PATH

  echo ----------------------------------------------------------------------------
  echo All preparation should have been made successful
  echo If you want to run the program you just created please run make vde and make run
  echo make vde: Generates the network
  echo make run: Runs the programm, please ensure to use make vde if you are in need of a virtual network for you project
  echo To run an ftpd server you authbind --deep /usr/local/dist/DIR/f13/in.tftpd -l \<location of \*.elf\>
  echo ----------------------------------------------------------------------------
fi
