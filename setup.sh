#!/usr/bin/env bash


# change the name of the folder with the git repo to $dotfiles
current_dirname="$(cd "$(dirname "$0")" && basename "$PWD")"
if [ "$current_dirname" != dotfiles ]; then
    cd "$(dirname "$0")" && mv -v ../"$current_dirname" ../dotfiles
fi


# make the needed symlinks if they don't exist
cd ~  # makes sure that the symlinks are shown as relative to ~ with ls -la

if [ ! -L .vim ]; then
    rm -rf .vim
    ln -sv dotfiles/vim .vim
fi

if [ ! -L .ideavimrc ]; then
    ln -sfv dotfiles/vim/.ideavimrc .ideavimrc
fi

for file in dotfiles/bash/.[^.]*; do
    file=$(basename "$file")
    if [ ! -L "$file" ] && [ "$file" != '.DS_Store' ]; then
        ln -sfv dotfiles/bash/"$file" "$file"
    fi
done

for file in dotfiles/git/.[^.]*; do
    file=$(basename "$file")
    if [ ! -L "$file" ] && [ "$file" != '.DS_Store' ]; then
        ln -sfv dotfiles/git/"$file" "$file"
    fi
done

# on purpose as absolute links and not relative to ~
for file in dotfiles/keylayouts/*.keylayout; do
    file=$(basename "$file")
    if [ ! -L /Library/Keyboard\ Layouts/"$file" ]; then
        sudo ln -sfv ~/dotfiles/keylayouts/"$file" /Library/Keyboard\ Layouts/"$file"
    fi
done

if [ ! -L .config/karabiner ]; then
    rm -rf .config/karabiner
    ln -sv ~/dotfiles/karabiner ~/.config/karabiner
fi

if [ ! -L .config/ranger ]; then
    rm -rf .config/ranger
    ln -sv ~/dotfiles/ranger ~/.config/ranger
fi


# install all vim plugins (cannot be done in background with &)
vim -c "PlugClean!" -c "PlugInstall" -c "qa!"
