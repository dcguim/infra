#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi
if [ -z "$ZDOTDIR" ]
  then echo "Please provide the directory for the z shell file with ZDOTDIR envvar"
  exit
fi
curl -O https://distfiles.macports.org/MacPorts/MacPorts-2.6.4.tar.bz2
tar xf MacPorts-2.6.4.tar.bz2
cd MacPorts-2.6.4/
./configure
sudo make
sudo make install
sudo echo -e "# add path for macports binaries\nexport PATH=\"/opt/local/bin/:\$PATH\"" >> $ZDOTDIR/.zshrc
source $ZDOTDIR/.zshrc
port -v selfupdate
cat macports.txt | sudo xargs port install $1
