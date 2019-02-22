#!/usr/bin/env bash


dotfiles=".dotfiles"

# change the name of the folder with the git repo to $dotfiles
current_dirname="$(cd "$(dirname "$0")" && basename "$PWD")"
if [ "$current_dirname" != "$dotfiles" ]; then
    cd "$(dirname "$0")" && mv ../"$current_dirname" ../"$dotfiles"
    echo "Renamed $current_dirname/ to $dotfiles/"
fi


# make the needed symlinks if they don't exist
cd ~ # makes sure that the symlinks are shown as relative to ~ with ls -la

if [ ! -e .vim/ ]; then
    echo "Made symlink .vim -> $dotfiles/vim"
    ln -s "$dotfiles"/vim .vim
fi

if [ ! -e .ideavimrc ]; then
    ln -s "$dotfiles"/vim/.ideavimrc .ideavimrc
    echo "Made symlink .ideavimrc -> $dotfiles/vim/.ideavimrc"
fi

for file in "$dotfiles"/misc/.[^.]*; do
    file=$(basename "$file")
    if [ ! -e "$file" ]; then
        ln -s "$dotfiles"/misc/"$file" "$file"
        echo "Made symlink $file -> $dotfiles/misc/$file"
    fi
done


# install all vim plugins (cannot be done in background with &)
vim -c "PlugClean!" -c "PlugInstall" -c "qa!"
