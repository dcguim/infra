#!/bin/zsh
SCRIPT_DIR="${0:a:h}"

if [ -z "${ZDOTDIR}" ]; then
  echo "Please provide the z dot files directory"
  exit 1
fi

# Install dependencies (must not run as root)
brew install gcc libgccjit texinfo

# Clone emacs 30 if not already present
if [ ! -d /Applications/emacs ]; then
  sudo git clone --branch emacs-30 --single-branch git://git.savannah.gnu.org/emacs.git /Applications/emacs
  sudo chown -R $(whoami) /Applications/emacs
fi

cd /Applications/emacs/
./autogen.sh

# Build emacs with native compilation
zsh "${SCRIPT_DIR}/emacs-build.sh"

sudo ln -sf /Applications/emacs/src/emacs /usr/local/bin/emacsserver
sudo ln -sf /Applications/emacs/lib-src/emacsclient /usr/local/bin/emacsclient
git config --global core.editor "emacs -nw"

# Only append emacs function if not already present
if ! grep -q 'emacs()' $ZDOTDIR/.zshrc 2>/dev/null; then
  cat >> $ZDOTDIR/.zshrc << 'FUNC'
emacs(){
if [ -n "$1" ]; then
  nohup emacsclient --alternate-editor=emacsserver "$1" >/dev/null 2>&1 &
else
  nohup emacsclient --alternate-editor=emacsserver ./ >/dev/null 2>&1 &
fi
}
FUNC
fi

ln -sf $ZDOTDIR/../.emacs ~/.emacs
source $ZDOTDIR/.zshrc
