#!/bin/sh
git clone git://git.savannah.gnu.org/emacs.git /Applications/
cd /Applications/emacs/
./configure
./make install
ln -s /Applications/emacs/src/emacs /usr/local/bin/emacsclient
git config --global core.editor "emacs -nw"
echo -e "emacs(){\nnohup emacsclient \"\$1\" >/dev/null 2>&1 &\n}" >> ~/.zprofile
source ~/.zprofile
