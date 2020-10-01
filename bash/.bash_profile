# solarized colors for coloring the prompt
tput sgr0;                BASE03=$(tput setaf 234);  BASE02=$(tput setaf 235)
BASE01=$(tput setaf 240); BASE00=$(tput setaf 241);  BASE0=$(tput setaf 244);  BASE1=$(tput setaf 245)
BASE2=$(tput setaf 254);  BASE3=$(tput setaf 230);   YELLOW=$(tput setaf 136); ORANGE=$(tput setaf 166)
RED=$(tput setaf 160);    MAGENTA=$(tput setaf 125); VIOLET=$(tput setaf 61);  BLUE=$(tput setaf 33)
CYAN=$(tput setaf 37);    GREEN=$(tput setaf 64);    BOLD=$(tput bold);        RESET=$(tput sgr0)

__ps1_venv () {
    pyenv version-name | grep --invert-match '^system$' | sed -E 's/(.*)/\(\1\) /'
}
__ps1_git_branch () {
    git branch | sed -E -e '/^[^*]/d' -e 's/\* \(?([^)]*)\)?$/\(\1\) /'
}
__ps1_git_status () {
    [ -n "$(git status --porcelain)" ] && printf '\b*'
}
# solarized colored prompt: (venv) path/to/dir (branch)*$
export PS1="\
\$(__ps1_venv 2> /dev/null)\
\[$CYAN\]\w \
\[$MAGENTA\]\$(__ps1_git_branch 2> /dev/null)\
\[$RESET\]\$(__ps1_git_status 2> /dev/null)\
\[$CYAN\]\$ \[$RESET\]\
"
export PROMPT_DIRTRIM=3  # show only last 3 dirs in prompt

export EDITOR=vim

export CLICOLOR=1  # enable syntax highlighting

# needed for something to not break, don't remove
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# bash history gets written immediately
shopt -s histappend
export PROMPT_COMMAND='history -a;history -n'

# unlimited bash history
export HISTSIZE=
export HISTFILESIZE=

# ** expands to any number of directories
shopt -s globstar

source /usr/local/etc/bash_completion

alias vvrc='vim ~/.vim/vimrc'
alias vbrc='vim ~/.bash_profile && source ~/.bash_profile'
alias sbrc='source ~/.bash_profile'
alias virc='vim ~/.vim/.ideavimrc'
alias vssh='vim ~/.ssh/config'
vims () {
    vim "scp://$1/$2"
}

alias b='cd ..'
alias bb='cd ../..'
alias bbb='cd ../../..'
alias bbbb='cd ../../../..'
alias l='ls -la'
alias ll='l'

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

alias fixtouchid="grep -q 'pam_tid.so' /etc/pam.d/sudo \
|| sudo sed -i '' '1 a\\
auth       sufficient     pam_tid.so
' /etc/pam.d/sudo"

alias clamshell='sudo pmset -a disablesleep 1'
alias noclamshell='sudo pmset -a disablesleep 0'

alias makemigrations='python manage.py makemigrations'
alias migrate='python manage.py migrate'
alias runserver='python manage.py runserver'

alias gs='git status'
alias gf='git fetch --all --tags --prune'
alias ga='git add'
alias gai='git add --interactive'
alias gaa='git add --all'
alias gu='git restore --staged'
alias gua='git restore --staged :/'
alias gdc='git restore --staged --worktree'
alias gdca='git restore --staged --worktree :/ && git clean --interactive'
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
alias gd='git diff'
alias gds='git diff --staged'
alias gdh='git diff HEAD'
alias gl='git log --branches --remotes --tags --graph --date-order'
alias glf='gl --name-status'
alias glff='glf --format=full'
alias gb='git branch'
alias gba='git branch -a'
gbd () { git branch --delete "$1" && git push --delete origin "$1"; }
alias gch='git checkout'
gchb () { git checkout -b "$1" || git checkout "$1"; }
alias gstash='git stash --include-untracked'
alias gpop='git stash pop'
alias gre='git remote'
alias gres='git remote show'
alias grea='git remote add'
alias grr='git remote remove'
alias grb='git rebase'
alias grbi='git rebase --interactive'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias gsw='git show --format=fuller --date=iso'
alias gsws='gsw --stat'
alias grs='git reset'
alias grv='git revert'
ghub () {
    # Open the GitHub link for the current repo in the browser.
    remote=$(git config remote.upstream.url || git config remote.origin.url) \
    && open "$(echo $remote | sed 's,^[^:]*:\([^:]*\).git$,https://github.com/\1,')"
}
gsha () {
    # Copy the hash of the specified revision to the clipboard.
    # Uses the latest commit as the default if no argument is passed.
    git rev-parse --short ${1:-HEAD} | tr -d '\n' | pbcopy
}
__git_complete gch _git_checkout
__git_complete grb _git_rebase

alias dc='docker-compose'
alias dcf='docker-compose --file'
alias dcb='docker-compose build '
dcbf () { docker-compose --file "$1" build; }
alias dcbn='docker-compose build --no-cache'
alias dcu='docker-compose up'
dcuf () { docker-compose --file "$1" up; }
dcub () { docker-compose build "$@" && docker-compose up "$@"; }
dcubf () { docker-compose --file "$1" build && docker-compose --file "$1" up; }
alias dcubn='docker-compose build --no-cache && docker-compose up'
alias dcd='docker-compose down'
alias dcr='docker-compose run --rm'
dcs () { docker-compose run --rm "$1" sh ; }

docker_exec_ssh () { ssh $1 -t "docker exec -it \$(docker container ls | awk '/$2/ {print \$NF; exit}') $3; bash"; }

brew () {
    if [[ "$@" == "up" ]]; then
        command brew update && brew upgrade && brew cask upgrade
    elif [[ "$@" == "dump" ]]; then
        command brew bundle dump --force --no-restart --file ~/dotfiles/brew/Brewfile
    elif [[ "$@" == "load" ]]; then
        command brew bundle --file=~/dotfiles/brew/Brewfile
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

updatebackend () {
    docker-compose run --rm backend sh -c \
        'pip list --outdated > /tmp/pip-temp1.txt \
         && awk '\''{ print $1 }'\'' /tmp/pip-temp1.txt | sort > /tmp/pip-temp2.txt \
         && awk -F '\''=='\'' '\''{ print $1 }'\'' requirements*txt | sort > /tmp/pip-temp3.txt \
         && comm -12 /tmp/pip-temp2.txt /tmp/pip-temp3.txt | grep -f /dev/stdin /tmp/pip-temp1.txt \
         && rm /tmp/pip-temp*txt'
}


# shuup
npmall () {
    find . ! -path '*/node_modules/*' -name 'package.json' -execdir npm install \; -execdir npm run build \;
}

installbasics () {
    pip install --disable-pip-version-check --upgrade prequ setuptools wheel psycopg2 autoflake pip==19.2.*
}

installshuup () {
    installbasics
    [ -f requirements.txt ] && pip install --disable-pip-version-check -r requirements.txt
    [ -f requirements-dev.txt ] && pip install --disable-pip-version-check -r requirements-dev.txt
    [ -f requirements-test.txt ] && pip install --disable-pip-version-check -r requirements-test.txt
    npmall
    [ "$1" != "--no-packages" ] && export -f npmall && [ -d ../shuup-packages ] && ls -d ../shuup-packages/* | xargs -I {} bash -c \
        "cd '{}' && pip install --disable-pip-version-check -e . && npmall"
    python manage.py migrate
}

installshuup_nonpm () {
    installbasics
    [ -f requirements.txt ] && pip install --disable-pip-version-check -r requirements.txt
    [ -f requirements-dev.txt ] && pip install --disable-pip-version-check -r requirements-dev.txt
    [ -f requirements-test.txt ] && pip install --disable-pip-version-check -r requirements-test.txt
    [ "$1" != "--no-packages" ] && [ -d ../shuup-packages ] && ls -d ../shuup-packages/* | xargs -I {} bash -c \
        "cd '{}' && pip install --disable-pip-version-check -e ."
    python manage.py migrate
}

fixshuup () {
    autoflake --in-place --recursive --remove-all-unused-imports --ignore-init-module-imports . && isort --recursive .
}

checkshuup () {
    isort --check-only && flake8 && echo all good
}

setupproject () {
    ~/Documents/scripts/setup_project.sh "$@"
    cd "$HOME/shuup/$2/app"
}

cloneshuup () {
    pushd .
    cd ~/shuup
    mkdir "$1"
    cd "$1"
    git clone "git@github.com:ruohola/$1.git" app
    cd app
    git remote add upstream "git@github.com:shuup/$1.git"
    popd
}

linkshuup () {
    mkdir -p ../shuup-packages && [ ! -z "$1" ] && ln -s "../../$1/app" "../shuup-packages/$1"; ls -la ../shuup-packages
}

unlinkshuup () {
    if [ $# -eq 0 ]; then
        rm ../shuup-packages/*; ls -la ../shuup-packages
    else
        rm "../shuup-packages/$1"; ls -la ../shuup-packages
    fi
}

source ~/.fzf.bash

__fzf_vim__ () {
    local file
    file=$(__fzf_select__)
    file="$(echo "${file}" | sed 's/ $//')"
    if [ -f "${file}" ]; then
        echo vim "${file}"
    fi
}

if [[ $- == *i* ]]; then
    # we are in an interactive shell

    bind "TAB:menu-complete"
    bind "set show-all-if-ambiguous on"
    bind "set menu-complete-display-prefix on"

    # open file in vim with fzf
    # reference from: https://github.com/junegunn/fzf/blob/736344e151fd8937353ef8da5379c1082e441468/shell/key-bindings.bash#L92
    stty lnext ''
    bind '"\C-v": " \C-b\C-k \C-u`__fzf_vim__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'

    # remap fzf cd to dir from ALT-C to CTRL-F
    bind '"\C-f": "\ec"'
fi

export FZF_IGNORES=Applications,Library,Movies,Music,Pictures,.git,Qt,.DS_Store,.Trash,.temp,__pycache__,venv,.pyenv,node_modules,.cache,.npm,*cache*
export FZF_DEFAULT_COMMAND='fd --type f --hidden --no-ignore --exclude "{$FZF_IGNORES}" .'
export FZF_ALT_C_COMMAND='fd --type d --type l --hidden --no-ignore --exclude "{$FZF_IGNORES}" .'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export RIPGREP_CONFIG_PATH=~/dotfiles/ripgrep/.ripgreprc

export PATH="$HOME/.cargo/bin:${PATH}"

export PATH="$HOME/.pyenv/bin:${PATH}"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

export PATH="$HOME/.local/bin:${PATH}"

export PATH="/usr/local/bin:${PATH}"
export PATH="$HOME/dotfiles/bash/exported:${PATH}"
export PATH="/usr/local/opt/postgresql@9.6/bin:${PATH}"

export PYTHONWARNINGS=ignore::UserWarning:setuptools.distutils_patch:26,ignore::UserWarning:_distutils_hack:19

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain

# Need to be after all PATH settings
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv () {
    if [[ "$@" == "list" ]]; then
        local versions
        versions=$(pyenv install --list)
        for version in 5 6 7 8
        do
             echo "${versions}" | grep -E "^\s+3\.${version}" | tail -1
        done
        for version in 9 10
        do
             echo "${versions}" | grep -E "^\s+3\.${version}"
        done
    else
        command pyenv "$@"
    fi
}
