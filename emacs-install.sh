#!/bin/sh
if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi
git clone git://git.savannah.gnu.org/emacs.git /Applications/emacs
cd /Applications/emacs/
./autogen.sh
./configure
./make
./make install
ln -s /Applications/emacs/src/emacs /usr/local/bin/emacsclient
git config --global core.editor "emacs -nw"
echo -e "emacs(){\nnohup emacsclient \"\$1\" >/dev/null 2>&1 &\n}" >> ~/.zprofile
source ~/.zprofile
