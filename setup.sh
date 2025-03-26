#!/bin/sh

cd ~ || exit  # Makes sure that the symlinks are shown as relative to `~` with `ls -la`.

# Make the needed symlinks if they don't exist.
[ ! -L .vim ] && rm -rf .vim && ln -sv dotfiles/vim .vim

[ ! -L .ideavimrc ] && ln -sfv dotfiles/vim/.ideavimrc .ideavimrc

[ ! -L .tmux.conf ] && ln -sfv dotfiles/tmux/.tmux.conf .tmux.conf

[ ! -L .latexmkrc ] && ln -sfv dotfiles/tex/.latexmkrc .latexmkrc

[ ! -L .shellcheckrc ] && ln -sfv dotfiles/shellcheck/.shellcheckrc .shellcheckrc

[ ! -L .ghci ] && ln -sfv dotfiles/ghci/.ghci .ghci

for file in .bashrc .bash_profile .zshrc .zprofile .inputrc .hushlogin; do
    [ ! -L "$file" ] && ln -sfv dotfiles/sh/"$file" "$file"
done

# Install homebrew and all brew packages.
brew --version > /dev/null 2>&1 \
    || { /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" \
        && brew tap homebrew/bundle \
        && { brew bundle install --file=~/dotfiles/brew/Brewfile;
            "$(brew --prefix)/opt/fzf/install"; }; }

# Link gitconfig only after modern git from brew is installed.
for file in .gitconfig .gitignore_global; do
    [ ! -L "$file" ] && ln -sfv dotfiles/git/"$file" "$file"
done

# Install nvm.
default_node=lts/iron  # v20
[ ! -f ~/.nvm/nvm.sh ] \
    && curl --fail https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && nvm install "$default_node" \
    && nvm alias default "$default_node" \
    && npm update --global npm \
    && npm install --global yarn

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

target=~/.local/share/bash-completion/completions/npm
[ ! -f "$target" ] \
    && npm completion > "$target"

# Install vim-plug and all vim plugins.
[ ! -f ~/.vim/autoload/plug.vim ] \
    && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && vim -c "PlugClean!" -c "PlugInstall" -c "qa!"

# The rest are on purpose as absolute links and not relative from `~`.

[ ! -L '/Library/Keyboard Layouts/Finner.keylayout' ] \
    && sudo ln -sfv ~/dotfiles/keylayouts/finner/Finner.keylayout '/Library/Keyboard Layouts/Finner.keylayout'

[ ! -L ~/.config/karabiner ] \
    && rm -rf ~/.config/karabiner && mkdir -p ~/.config/ && ln -sv ~/dotfiles/karabiner ~/.config/karabiner

[ ! -L ~/.config/pgcli/config ] && mkdir -p ~/.config/pgcli/ && ln -sfv ~/dotfiles/pgcli/config ~/.config/pgcli/config

[ ! -L "$(brew --prefix)/opt/languagetool/libexec/org/languagetool/resource/en/hunspell/ignore.txt" ] \
    && ln -sfv ~/dotfiles/vim/spell/en.utf-8.add "$(brew --prefix)/opt/languagetool/libexec/org/languagetool/resource/en/hunspell/ignore.txt"

[ ! -L ~/.gnupg/gpg.conf ] && ln -sfv ~/dotfiles/gpg/gpg.conf ~/.gnupg/gpg.conf
[ ! -L ~/.gnupg/gpg-agent.conf ] && ln -sfv ~/dotfiles/gpg/gpg-agent.conf ~/.gnupg/gpg-agent.conf

[ ! -L ~/'Library/Application Support/k9s/skin.yml' ] \
    && mkdir -p ~/'Library/Application Support/k9s' && ln -sfv ~/dotfiles/k9s/skin.yml ~/'Library/Application Support/k9s/skin.yml'

[ -f "$(brew --prefix)/bin/pinentry-mac" ] && [ ! -L /usr/local/bin/pinentry ] && sudo mkdir -p /usr/local/bin/ && sudo ln -sfv "$(brew --prefix)/bin/pinentry-mac" /usr/local/bin/pinentry


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

# Disable the keyboard language switcher in input fields
# https://discussions.apple.com/thread/255161577?answerId=259780226022&sortBy=best#259780226022
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0

# Disable clipboard history in Keyboard Maestro.
defaults write com.stairways.keyboardmaestro.engine MaxClipboardHistory -int 1
