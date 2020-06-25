# solarized colors for coloring the prompt
tput sgr0;                BASE03=$(tput setaf 234);  BASE02=$(tput setaf 235)
BASE01=$(tput setaf 240); BASE00=$(tput setaf 241);  BASE0=$(tput setaf 244);  BASE1=$(tput setaf 245)
BASE2=$(tput setaf 254);  BASE3=$(tput setaf 230);   YELLOW=$(tput setaf 136); ORANGE=$(tput setaf 166)
RED=$(tput setaf 160);    MAGENTA=$(tput setaf 125); VIOLET=$(tput setaf 61);  BLUE=$(tput setaf 33)
CYAN=$(tput setaf 37);    GREEN=$(tput setaf 64);    BOLD=$(tput bold);        RESET=$(tput sgr0)

# solarized colored prompt that looks like: path/to/dir (branch_if_on_git_repo) $
export PS1="\[$CYAN\]\w \[$MAGENTA\]\$(git branch 2> /dev/null | sed -E -e '/^[^*]/d' -e 's/\* \(?([^)]*)\)?$/\(\1\) /')\[$CYAN\]\$ \[$RESET\]"
PROMPT_DIRTRIM=3  # show only last 3 dirs in prompt

export EDITOR=vim

export CLICOLOR=1  # enable syntax highlighting

# needed for something to not break, don't remove
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# bash history gets written immediately
shopt -s histappend
PROMPT_COMMAND='history -a;history -n'

# unlimited bash history
export HISTSIZE=
export HISTFILESIZE=

# ** expands to any number of directories
shopt -s globstar

bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

alias vvrc='vim ~/.vim/vimrc'
alias vbrc='vim ~/.bash_profile && source ~/.bash_profile'
alias sbrc='source ~/.bash_profile'
alias virc='vim ~/.vim/.ideavimrc'
alias vssh='vim ~/.ssh/config'

alias b='cd ..'
alias bb='cd ../..'
alias bbb='cd ../../..'
alias l='ls -la'
alias ll='ls -la'

alias F='open .'
alias preview='open -a Preview'

alias act='source venv/bin/activate'
alias lg='lazygit'

alias trash='rmtrash'

alias fdi='fd --no-ignore'
alias rgi='rg --no-ignore'

pyclean () {
    find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
}

alias clamshell='sudo pmset -a disablesleep 1'
alias noclamshell='sudo pmset -a disablesleep 0'

alias runserver='python manage.py runserver'

alias gs='git status'
alias gf='git fetch --all --tags --prune'
alias ga='git add'
alias gaa='git add --all'
alias gu='git restore --staged'
alias gua='git reset'
alias gdc='git restore --source=HEAD --staged --worktree'
alias gcl='git clone'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gcae='git commit --allow-empty'
alias gcaem='git commit --allow-empty -m'
alias gpl='git pull --rebase'
alias gps='git push'
alias gpsf='git push -f'
alias gpsu='git push -u origin $(git branch --show-current)'
alias gpsuf='git push -f -u origin $(git branch --show-current)'
alias gds='git diff --staged'
alias gdh='git diff HEAD'
alias gl='git log --all --graph --date-order'
alias glf='git log --all --graph --date-order --name-status'
alias glff='git log --format=full'
alias gls='git log --graph --date-order --numstat'
alias gb='git branch'
alias gba='git branch -a'
gbd () { git branch --delete "$1" && git push --delete origin "$1"; }
alias gch='git checkout'
gchb () { git checkout -b "$1" || git checkout "$1"; }
alias gstash='git stash --include-untracked'
alias gpop='git stash pop'

alias dc='docker-compose'
alias dcb='docker-compose build --parallel'
alias dcbn='docker-compose build --parallel --no-cache'
alias dcu='docker-compose up'
alias dcub='docker-compose build --parallel && docker-compose up'
alias dcubn='docker-compose build --parallel --no-cache && docker-compose up'
alias dcd='docker-compose down'
alias dcr='docker-compose run --rm'
dcs () { docker-compose run --rm "$1" sh ; }

git () {
    if [[ "${@: -1}" == "dev" ]]; then
        command git ${@:1:$#-1} develop
    else
        command git "$@"
    fi
}

brew () {
    if [[ "$@" == "up" ]]; then
        command brew update && brew upgrade && brew cask upgrade
    elif [[ "$@" == "dump" ]]; then
        command brew bundle dump --force --no-restart --file ~/dotfiles/brew/Brewfile
    elif [[ "$@" == "dumpwork" ]]; then
        command brew bundle dump --force --no-restart --file ~/dotfiles/brew/Brewfile-work
    else
        command brew "$@"
    fi
}


# skole
alias fmtbackend='yarn --cwd ~/skole backend:format'
alias mypybackend='docker-compose run --no-deps --rm backend mypy .'
alias testbackend='docker-compose run --rm backend pytest --verbose .'
alias covbackend='docker-compose run --rm backend pytest --verbose --cov-report=html --cov=. . && open ~/skole/backend/htmlcov/index.html'
alias allbackend='yarn --cwd ~/skole backend:test'
alias managebackend='docker-compose run --rm backend python manage.py'

npmall () {
    find . ! -path "*/node_modules/*" -name "package.json" -execdir npm install \; -execdir npm run build \;
}

# shuup
installshuup () {
    pip install --disable-pip-version-check --upgrade prequ setuptools wheel psycopg2 pip==19.2.* \
    && [ -f requirements.txt ] && pip install --disable-pip-version-check -r requirements.txt \
    && [ -f requirements-dev.txt ] && pip install --disable-pip-version-check -r requirements-dev.txt \
    && [ -f requirements-test.txt ] && pip install --disable-pip-version-check -r requirements-test.txt \
    && npmall \
    && [ -d ../shuup-packages ] && ls -d ../shuup-packages/* | xargs -I {} bash -c "cd '{}' && pip install --disable-pip-version-check -e . && npmall"
}


# fzf config
source ~/.fzf.bash

__fzf_vim__ () {
    local file=$(__fzf_select__)
    local file="$(echo "${file}" | sed 's/ $//')"
    if [ -f "${file}" ]; then
        echo vim "${file}"
    fi
}

stty lnext ''
bind '"\C-v": " \C-b\C-k \C-u`__fzf_vim__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'

# remap cd to dir from ALT-C to CTRL-F
bind '"\C-f": "\ec"'

# Can't use variables for the excludable files because those won't get evaluated when using fzf.vim
export FZF_DEFAULT_COMMAND='fd --type f --hidden --no-ignore --exclude \
    "{.git,Library,Applications,Qt,.DS_Store,.Trash,.temp,__pycache__,venv,.pyenv,node_modules,.cache,.npm}" .'
export FZF_ALT_C_COMMAND='fd --type d --type l --hidden --no-ignore --exclude \
    "{.git,Library,Applications,Qt,.DS_Store,.Trash,.temp,__pycache__,venv,.pyenv,node_modules,.cache,.npm}" .'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export RIPGREP_CONFIG_PATH=~/dotfiles/ripgrep/.ripgreprc

source /Users/eero/Library/Preferences/org.dystroy.broot/launcher/bash/br

source /usr/local/etc/bash_completion

export PATH="$HOME/.cargo/bin:${PATH}"

export PATH="$HOME/.pyenv/bin:${PATH}"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export PATH="$HOME/.local/bin:${PATH}"

export PATH="/usr/local/bin:${PATH}"
export PATH="$HOME/dotfiles/bash/exported:${PATH}"
