#!/bin/sh

cd ~ || exit  # makes sure that the symlinks are shown as relative to ~ with ls -la

# make the needed symlinks if they don't exist
[ ! -L .vim ] && rm -rf .vim && ln -sv dotfiles/vim .vim

[ ! -L .ideavimrc ] && ln -sfv dotfiles/vim/.ideavimrc .ideavimrc

[ ! -L .tmux.conf ] && ln -sfv dotfiles/tmux/.tmux.conf .tmux.conf

[ ! -L .latexmkrc ] && ln -sfv dotfiles/tex/.latexmkrc .latexmkrc

for file in .bashrc .bash_profile .zshrc .zprofile .inputrc .hushlogin; do
    [ ! -L "$file" ] && ln -sfv dotfiles/sh/"$file" "$file"
done

for file in .gitconfig .gitignore_global; do
    [ ! -L "$file" ] && ln -sfv dotfiles/git/"$file" "$file"
done

# install homebrew and all brew packages
[ ! -f /usr/local/bin/brew ] \
    && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" \
    && brew tap homebrew/bundle \
    && { brew bundle install --file=~/dotfiles/brew/Brewfile;
        /usr/local/opt/fzf/install; }

# install vim-plug and all vim plugins
[ ! -f ~/.vim/autoload/plug.vim ] \
    && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && vim -c "PlugClean!" -c "PlugInstall" -c "qa!"

# the rest are on purpose as absolute links and not relative from ~

[ ! -L '/Library/Keyboard Layouts/Finner.keylayout' ] \
    && sudo ln -sfv ~/dotfiles/keylayouts/finner/Finner.keylayout '/Library/Keyboard Layouts/Finner.keylayout'

[ ! -L ~/.config/karabiner ] \
    && rm -rf ~/.config/karabiner && ln -sv ~/dotfiles/karabiner ~/.config/karabiner

[ ! -L ~/.config/pgcli/config ] && ln -sfv ~/dotfiles/pgcli/config ~/.config/pgcli/config

[ ! -L /usr/local/opt/languagetool/libexec/org/languagetool/resource/en/hunspell/ignore.txt ] \
    && ln -sfv ~/dotfiles/vim/spell/en.utf-8.add /usr/local/opt/languagetool/libexec/org/languagetool/resource/en/hunspell/ignore.txt

[ ! -L ~/.gnupg/gpg.conf ] && ln -sfv ~/dotfiles/gpg/gpg.conf ~/.gnupg/gpg.conf
[ ! -L ~/.gnupg/gpg-agent.conf ] && ln -sfv ~/dotfiles/gpg/gpg-agent.conf ~/.gnupg/gpg-agent.conf


# Remove delay from Dock.
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -int 0
killall Dock
