#!/bin/sh

cd ~ || exit  # Makes sure that the symlinks are shown as relative to `~` with `ls -la`.

# Make the needed symlinks if they don't exist.
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

# Install homebrew and all brew packages.
[ ! -f /usr/local/bin/brew ] \
    && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" \
    && brew tap homebrew/bundle \
    && { brew bundle install --file=~/dotfiles/brew/Brewfile;
        /usr/local/opt/fzf/install; }

# Install nvm.
default_node=lts/fermium  # v14
[ ! -f ~/.nvm/nvm.sh ] \
    && curl --fail https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && nvm install "$default_node" \
    && nvm alias default "$default_node"

# Install Bash completions.
mkdir -p ~/cloned

target=~/cloned/git-completion
[ ! -d "$target" ] \
    && git clone git@github.com:felipec/git-completion.git "$target" \
    && git -C "$target" switch --detach "$(git -C "$target" describe --tag --abbrev=0)" \
    && make --directory="$target" install

target=~/.local/share/bash-completion/completions/yarn
[ ! -f "$target" ] \
    && curl --fail --output "$target" https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash


# Install vim-plug and all vim plugins.
[ ! -f ~/.vim/autoload/plug.vim ] \
    && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && vim -c "PlugClean!" -c "PlugInstall" -c "qa!"

# The rest are on purpose as absolute links and not relative from `~`.

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
# https://apple.stackexchange.com/a/70598/321512
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -int 0
killall Dock

# Disable mouse acceleration
# (also needs https://downloads.steelseriescdn.com/drivers/tools/steelseries-exactmouse-tool.dmg)
# https://apple.stackexchange.com/a/151552/321512
defaults write .GlobalPreferences com.apple.mouse.scaling -1

# Disable holding key for special character popup, needs logging out to take effect.
# https://apple.stackexchange.com/a/332770/321512
defaults write -g ApplePressAndHoldEnabled -bool false
