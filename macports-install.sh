#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi
curl -O https://distfiles.macports.org/MacPorts/MacPorts-2.6.4.tar.bz2
tar xf MacPorts-2.6.4.tar.bz2
cd MacPorts-2.6.4/
./configure
make
sudo make install
echo -e "# add path for macports binaries\nexport PATH=\"/opt/local/bin/:\$PATH\"" >> ~/.zprofile
source ~/.zprofile
port -v selfupdate
cat macports.txt | sudo xargs port install $1
