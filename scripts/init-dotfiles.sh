#!/bin/sh
set -e

cd $HOME
echo cd `pwd`

files=`ls -A $DOTFILES | awk '/^\..*/ && !/\.config$/ && !/\.git$/'`
homepath=`echo $DOTFILES | sed "s|$HOME/||g"`
conffiles=`ls -A "$DOTFILES/.config"`
confpath=`echo $homepath | sed "s|.config/||g"`

for file in $files; do
    ln -sfv $homepath/$file .
done
ln -sfv .profile .zprofile

mkdir -p .config && cd .config/
echo cd `pwd`
for file in $conffiles; do
    ln -sfv $confpath/.config/$file .
done

