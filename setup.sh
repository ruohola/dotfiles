#!/usr/bin/env bash

reponame=".dotfiles"
current_dirname="$(cd "$(dirname "$0")" && basename $PWD)"

if [ "$current_dirname" != "$reponame" ]; then
    echo Renamed $current_dirname to $reponame
    cd "$(dirname "$0")" && mv ../${current_dirname} ../${reponame}
fi

# makes the needed symlinks if they don't exist
# these don't work yet

# if [ ! .e ~/.vim/ ]; then
#     ln -s ~/.dotfiles/vim ~/.vim/
# fi

# if [ ! .e ~/.bash_profile ]; then
#     ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
# fi

# if [ ! .e ~/.gitconfig ]; then
#     ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
# fi

# if [ ! .e ~/.hushlogin ]; then
#     ln -s ~/.dotfiles/.hushlogin ~/.hushlogin
# fi

# if [ ! .e ~/.ideavimrc ]; then
#     ln -s ~/.dotfiles/.ideavimrc ~/.ideavimrc
# fi

# if [ ! .e ~/.inputrc ]; then
#     ln -s ~/.dotfiles/.inputrc ~/.inputrc
# fi
