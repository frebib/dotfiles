#!/bin/sh
set -e

cd $HOME
echo cd `pwd`

files=`ls -A $DOTFILES | awk '/^\..*/ && !/\.config$/ && !/\.git$/ && !/\.gitignore$/'`
homepath=`echo $DOTFILES | sed "s|$HOME/||g"`
conffiles=`ls -A "$DOTFILES/.config"`
confpath=`echo $homepath | sed "s|.config/||g"`
userhome=$HOME

for file in $files; do
    ln -sfv $homepath/$file .
done
ln -sfv .profile .zprofile

mkdir -p .config && cd .config/
echo cd `pwd`
for file in $conffiles; do
    ln -sfv $confpath/.config/$file .
done

sudo -s << EOF
cd ~
echo -n "cd "
pwd

ln -sfv $userhome/.vimrc .
ln -sfv $userhome/.vim/ .
ln -sfv $userhome/.gtkrc-2.0 .

mkdir -p .config && cd .config/
echo -n "cd "
pwd
ln -sfv $userhome/.config/gtk-3.0 .
EOF
