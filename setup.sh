#!/bin/sh

cd ~ || exit  # Makes sure that the symlinks are shown as relative to `~` with `ls -la`.

# Make the needed symlinks if they don't exist.
[ ! -L .vim ] && rm -rf .vim && ln -sv dotfiles/vim .vim

[ ! -L .ideavimrc ] && ln -sfv dotfiles/vim/.ideavimrc .ideavimrc

[ ! -L .tmux.conf ] && ln -sfv dotfiles/tmux/.tmux.conf .tmux.conf

[ ! -L .latexmkrc ] && ln -sfv dotfiles/tex/.latexmkrc .latexmkrc

[ ! -L .shellcheckrc ] && ln -sfv dotfiles/shellcheck/.shellcheckrc .shellcheckrc

[ ! -L .ghci ] && ln -sfv dotfiles/ghci/.ghci .ghci

for file in .bashrc .bash_profile .zshrc .zprofile .inputrc .hushlogin .lesskey; do
    [ ! -L "$file" ] && ln -sfv dotfiles/sh/"$file" "$file"
done

# Install homebrew.
command -v brew > /dev/null \
    || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install all brew packages (use fzf as a proxy for checking if they have been installed).
command -v fzf > /dev/null \
    || { brew bundle install --file=~/dotfiles/brew/Brewfile;
            "$(brew --prefix)/opt/fzf/install";
            go install github.com/chrishrb/go-grip@latest; }

# Link gitconfig only after modern git from brew is installed.
for file in .gitconfig .gitignore_global; do
    [ ! -L "$file" ] && ln -sfv dotfiles/git/"$file" "$file"
done

# Install nvm.
default_node=lts/krypton  # v24
[ ! -f ~/.nvm/nvm.sh ] \
    && curl --fail https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && nvm install "$default_node" \
    && nvm alias default "$default_node" \
    && npm update --global npm

# Detect if this dotfiles repo was cloned via SSH or HTTPS.
if git -C ~/dotfiles remote get-url --all origin | grep -q '^https://'; then
    github_prefix='https://github.com/'
else
    github_prefix='git@github.com:'
fi

# Install Bash completions.
mkdir -p ~/cloned

target=~/cloned/git-completion
[ ! -d "$target" ] \
    && git clone "${github_prefix}felipec/git-completion.git" "$target"
_previous="$(git -C "$target" rev-parse HEAD)" \
    && git -C "$target" fetch --all --tags --prune && git -C "$target" switch --quiet --detach "$(git -C "$target" describe --tag --abbrev=0 origin/master)" \
    && [ "$(git -C "$target" rev-parse HEAD)" != "$_previous" ] && make --directory="$target" install

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

[ ! -L ~/.config/yazi/yazi.toml ] && mkdir -p ~/.config/yazi/ && ln -sfv ~/dotfiles/yazi/yazi.toml ~/.config/yazi/yazi.toml

[ ! -L "$(brew --prefix)/opt/languagetool/libexec/org/languagetool/resource/en/hunspell/ignore.txt" ] \
    && ln -sfv ~/dotfiles/vim/spell/en.utf-8.add "$(brew --prefix)/opt/languagetool/libexec/org/languagetool/resource/en/hunspell/ignore.txt"

[ ! -L ~/.gnupg/gpg.conf ] && ln -sfv ~/dotfiles/gpg/gpg.conf ~/.gnupg/gpg.conf
[ ! -L ~/.gnupg/gpg-agent.conf ] && ln -sfv ~/dotfiles/gpg/gpg-agent.conf ~/.gnupg/gpg-agent.conf

[ -f "$(brew --prefix)/bin/pinentry-mac" ] && [ ! -L /usr/local/bin/pinentry ] && sudo mkdir -p /usr/local/bin/ && sudo ln -sfv "$(brew --prefix)/bin/pinentry-mac" /usr/local/bin/pinentry

mkdir -p ~/.local/bin/ && sed '/echo "This manpage is not compatible with mandoc/,/sleep 1/ s/.*/:/' /usr/bin/man > ~/.local/bin/man && chmod +x ~/.local/bin/man

[ -f ~/go/bin/go-grip ] && [ ! -L ~/.local/bin/grip ] && ln -sfv ~/go/bin/go-grip ~/.local/bin/grip

target=~/.local/bin/_tmux-file-picker
[ ! -f "$target" ] \
    && curl --fail --output "$target" https://raw.githubusercontent.com/raine/tmux-file-picker/main/tmux-file-picker \
    && chmod u+x "$target"

target=~/'Library/Application Support/k9s/skins/transparent.yaml'
command -v k9s > /dev/null && [ ! -f "$target" ] \
    && mkdir -p "$(dirname "$target")" \
    && curl --fail --output "$target" https://raw.githubusercontent.com/derailed/k9s/master/skins/transparent.yaml

# Patch Menlo with Nerd Fonts glyphs.
target=~/.local/share/FontPatcher
command -v fontforge > /dev/null && [ ! -f ~/'Library/Fonts/Menlo Nerd Font Mono.ttc' ] \
    && curl --fail --location --output /tmp/FontPatcher.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip \
    && unzip /tmp/FontPatcher.zip -d "$target" \
    && rm /tmp/FontPatcher.zip \
    && fontforge -script "$target/font-patcher" /System/Library/Fonts/Menlo.ttc --complete --mono -out ~/Library/Fonts/

# Install tmux plugins.
mkdir -p ~/.tmux/plugins

target=~/.tmux/plugins/tmux-fingers
[ ! -d "$target" ] \
    && git clone "${github_prefix}Morantron/tmux-fingers.git" "$target"
git -C "$target" fetch --all --tags --prune && git -C "$target" switch --quiet --detach "$(git -C "$target" describe --tag --abbrev=0 origin/master)"


# Use Homebrew Bash
homebrew_bash='/opt/homebrew/bin/bash'
if [ -f "$homebrew_bash" ] && [ "$homebrew_bash" != "$SHELL" ]; then
    if ! grep -q "$homebrew_bash" /etc/shells; then
        echo "$homebrew_bash" | sudo tee -a /etc/shells
    fi
    chsh -s "$homebrew_bash"
fi

# Remove delay from Dock.
# https://apple.stackexchange.com/a/70598/321512
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -int 0
killall Dock

# Always show hidden files in Finder.
defaults write com.apple.finder AppleShowAllFiles true
killall Finder

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
