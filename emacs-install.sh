#!/bin/sh
git clone git://git.savannah.gnu.org/emacs.git /Applications/
cd /Applications/emacs/
./configure
./make install
ln -s /Applications/emacs/src/emacs /usr/local/bin/
git config --global core.editor "emacs -nw"
