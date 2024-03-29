#!/bin/sh
if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi
if [ -z "${ZDOTDIR}" ]
   then "Please provide the z dot files directory"
   exit
fi
git clone git://git.savannah.gnu.org/emacs.git /Applications/emacs
cd /Applications/emacs/
./autogen.sh
./configure
makeinfo=/opt/local/bin/makeinfo make
makeinfo=/opt/local/bin/makeinfo make install
ln -s /Applications/emacs/src/emacs /usr/local/bin/emacsserver
ln -s /Applications/emacs/lib-src/emacsclient /usr/local/bin/emacsclient
git config --global core.editor "emacs -nw"
echo -e "emacs(){\nif [ -n \"\$1\" ]; then\n  nohup emacsclient --alternate-editor=emacsserver \"\$1\" >/dev/null 2>&1 &\nelse\n  nohup emacsclient --alternate-editor=emacsserver ./ >/dev/null 2>&1 &\nfi" >> $ZDOTDIR/.zshrc
ln -s $ZDOTDIR/../.emacs ~/.emacs
source $ZDOTDIR/.zshrc
