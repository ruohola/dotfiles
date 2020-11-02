[[ $- != *i* ]] && return  # Don't do anything if not interactive.

# Solarized colors for coloring the prompt and man pages in iTerm.
_base03=$(tput setaf 8);  _base02=$(tput setaf 0);  _base01=$(tput setaf 10); _base00=$(tput setaf 11);
_base0=$(tput setaf 12);  _base1=$(tput setaf 14);  _base2=$(tput setaf 7);   _base3=$(tput setaf 15);
_yellow=$(tput setaf 3);  _orange=$(tput setaf 9);  _red=$(tput setaf 1);     _magenta=$(tput setaf 5);
_violet=$(tput setaf 13); _blue=$(tput setaf 4);    _cyan=$(tput setaf 6);    _green=$(tput setaf 2);
_bold=$(tput bold);       _underlined=$(tput smul); _reset=$(tput sgr0);      tput sgr0;

__ps1_venv () {
    pyenv version-name | grep --invert-match '^system$' | sed -E 's/(.*)/\(\1\) /'
}
__ps1_git_branch () {
    # This doesn't use `git branch --show-current` because
    # it doesn't work # with a detached HEAD.
    git branch | sed -E -e '/^[^*]/d' -e 's/\* \(?([^)]*)\)?$/\(\1\) /'
}
__ps1_git_status () {
    [ -n "$(git status --porcelain)" ] && printf '\b*'
}
# Solarized colored prompt: (venv) path/to/dir (branch)*$
export PS1="\
\$(__ps1_venv 2> /dev/null)\
\[$_cyan\]\w \
\[$_magenta\]\$(__ps1_git_branch 2> /dev/null)\
\[$_reset\]\[\$(__ps1_git_status 2> /dev/null)\]\
\[$_cyan\]\$ \[$_reset\]\
"
export PROMPT_DIRTRIM=3  # Show only last 3 dirs in prompt.

export EDITOR=vim

export CLICOLOR=1

# Needed for something to not break, don't remove.
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Bash history gets written immediately.
shopt -s histappend
export PROMPT_COMMAND='history -a;history -n'

# Unlimited bash history.
export HISTSIZE=
export HISTFILESIZE=

# Don't add commands starting with a space to the history.
export HISTCONTROL=ignorespace

# Make ** expand to any number of directories.
shopt -s globstar

source /usr/local/etc/bash_completion

alias vvrc='vim ~/.vim/vimrc'
alias vbrc='vim ~/.bashrc && source ~/.bashrc'
alias sbrc='source ~/.bashrc'
alias vzrc='vim ~/.zshrc && source ~/.zshrc'
alias szrc='source ~/.zshrc'
alias vinp='vim ~/.inputrc && bind -f ~/.inputrc'
alias virc='vim ~/.vim/.ideavimrc'
alias vssh='vim ~/.ssh/config'
alias vgit='vim ~/.gitconfig'

vims () {
    vim "scp://$1/$2"
}

alias b='cd ..'
alias bb='cd ../..'
alias bbb='cd ../../..'
alias bbbb='cd ../../../..'
alias l='ls -la'
alias ll='l'

alias F='open .'  # Open Finder in the current directory.
alias o='open'

alias cp='cp -v'
alias mv='mv -v'
alias grep='GREP_COLOR="1;91" grep --color'

pbcopyn () {
    # Like normal `pbcopy` but strips away all trailing newlines.
    printf "$(< /dev/stdin)" | pbcopy
}

# Colored `man` pages and `less`'s help.
# mb = start blink
# md = start bold
# me = stop bold, blink, and underline
# se = stop standout
# so = start standout (e.g. search matches)
# ue = stop underline
# us = start underline
export LESS_TERMCAP_mb=$_blue
export LESS_TERMCAP_md=$_orange
export LESS_TERMCAP_me=$_reset
export LESS_TERMCAP_se=$_reset
export LESS_TERMCAP_so=$_base03$(tput setab 12)
export LESS_TERMCAP_ue=$_reset
export LESS_TERMCAP_us=$_green

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

alias ga='git add'
alias gaa='git add --all'
alias gai='git add --interactive'
alias gap='git add --patch'
alias gau='git add --update'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbdf='git branch --delete --force'
alias gbm='git branch --move'
alias gbs='git bisect'
alias gbsr='git bisect run'
alias gbsg='git bisect good'
alias gbsb='git bisect bad'
alias gbl='git blame'
alias gc='git commit --verbose'
alias gcm='git commit --message'
alias gca='git commit --verbose --amend'
alias gcam='git commit --amend --message'
alias gcan='git commit --amend --no-edit'
alias gcl='git clone --recurse-submodules'
alias gcli='git clean --interactive :/'
alias gcp='git cherry-pick'
alias gdc='git restore --worktree'
alias gdcp='git restore --worktree --patch'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch --all --tags --prune'
alias gl='git log --branches --remotes --tags --graph --date-order --color=always'
alias glf='gl --name-status'
alias glff='glf --format=full'
alias gmt='git mergetool'
alias gpl='git pull'
alias gpsf='git push --force'
alias gpsu='git push --follow-tags upstream HEAD'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias gre='git remote'
alias grea='git remote add'
alias grey='git remote show'
alias grer='git remote remove'
alias grl='git reflog'
alias grs='git reset'
alias grsh='git reset --hard'
alias grt='git restore --source'
alias grtp='git restore --source --patch'
alias grv='git revert'
alias gs='git status --untracked-files'
alias gsk='git ls-files -v | grep --color "^[Sa-z]"'
alias gst='git stash'
alias gsty='git stash show --patch --format=fuller'
alias gstl='git stash list --format=medium --stat'
alias gstp='git stash pop'
alias gsts='git stash push --include-untracked'
alias gt='git tag --annotate'
alias gtm='git tag --annotate --message'
alias gtn='git tag --annotate --message=""'
alias gtd='git tag --delete'
alias gtl="git tag --list --format='%(color:blue)%(taggerdate:format-local:%a %Y-%m-%d %H:%M)%09%(color:green)\
    %(taggername)%09%(color:red)%(refname:short)%09%(color:reset)%(contents:subject)' --color=always \
    | column -ts $'\t' | sort -k2,3 --reverse | less --RAW-CONTROL-CHARS --no-init --quit-if-one-screen"
alias gu='git restore --staged'
alias gua='git restore --staged :/'
alias gup='git restore --staged --patch'
alias guin='git update-index --no-skip-worktree'
alias guis='git update-index --skip-worktree'
alias gw='git switch'
alias gwd='git switch --detach'
alias gy='git show --format=fuller --first-parent'
# For some reason git -c doesn't work with delta.
alias gyn='git config --global delta.line-numbers false && gy && git config --global delta.line-numbers true'
alias gys='gy --stat'

gbdp () {
    # Delete local and remote branch.
    git branch --delete "$1"; git push --delete origin "$1"
}
gcf () {
    # Squash staged changes to the given commit.
    commit="$(git rev-parse $1)" \
    && git commit --fixup "$commit" \
    && GIT_SEQUENCE_EDITOR=: git rebase --interactive --autosquash "${commit}~1"
}
gdh () {
    # Show the diff of the currently staged and unstaged files compared to HEAD.
    # The speciality is that this also show the diff for newly created files.
    (
        git diff HEAD
        git ls-files --others --exclude-standard :/ |
            while read -r file; do
                git diff -- /dev/null "$file"
            done
    ) | delta
}
gdu () {
    # Show the diff of the currently unstaged files compared to HEAD.
    # The speciality is that this also show the diff for newly created files.
    (
        git diff
        git ls-files --others --exclude-standard :/ |
            while read -r file; do
                git diff -- /dev/null "$file"
            done
    ) | delta
}
gha () {
    # Copy the hash of the specified revision to the clipboard.
    # Use the latest commit as the default if no argument is passed.
    git rev-parse --short ${1:-HEAD} | pbcopyn
}
ghub () {
    # Open the GitHub link for the current repo in the browser.
    remote=$(git config remote.upstream.url || git config remote.origin.url) \
    && open "$(echo $remote | sed 's,^[^:]*:\([^:]*\).git$,https://github.com/\1,')"
}
gini () {
    # Initalize a new repository with an initial commit.
    git init "$1" && cd "$1" && git commit --allow-empty --message 'Initial commit'
}
gms () {
    # Copy the commit message of the specified revision to the clipboard.
    # Use the latest commit as the default if no argument is passed.
    git log --format=%B -n 1 ${1:-HEAD} | pbcopyn
}
gn () { 
    # Create a new branch with the given name or switch to if it already exists.
    git switch --create "$1" || git switch "$1"
}
gps () {
    # Push the current branch.
    git push --follow-tags "$@" || { [ "$?" -eq 128 ] && git push --follow-tags --set-upstream origin HEAD; }
}
gtp () {
    # Tag a commit in the past.
    # Usage: $ gtp v1.0.1 af1bc21 -m ""
    GIT_COMMITTER_DATE="$(git show "$2" --format=%aD | head -1)" git tag --annotate "$@"
}
gub () {
    # Update the curent branch to the latest primary remote HEAD.
    local status
    local remote
    local head
    local current
    status="$(git status --porcelain)"
    [ -n "$status" ] && git stash push --include-untracked
    git fetch --all --tags --prune
    remote=$(git remote | grep -E '(upstream|origin)' | tail -1)
    head=$(git remote show "$remote" | awk '/HEAD branch/ {print $NF}')
    current="$(git rev-parse --abbrev-ref HEAD)"
    if [ "$current" != "$head" ]; then
        git switch "$head"
        git rebase "${remote}/${head}"
        git switch -
        git rebase "$head"
    else
        git rebase "${remote}/${head}"
    fi
    [ -n "$status" ] && git stash pop
}
gvi () {
    # Open the specified file at the given revision in vim.
    # Usage: $ gvi HEAD~10:vim/vimrc
    [ $# -ne 0 ] && vim -c "Gedit $@"
}

__git_complete grb _git_rebase
__git_complete gba _git_branch
__git_complete gbd _git_branch
__git_complete gbdf _git_branch
__git_complete gbdp _git_branch
__git_complete gbm _git_branch
__git_complete gps _git_push
__git_complete gpsf _git_push
__git_complete gw _git_switch
__git_complete gy _git_show

complete -F _fzf_path_completion -o default -o bashdefault ga


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
dcs () { docker-compose run --rm "$1" sh; }
dcrf () { docker-compose --file "$1" run --rm "$2"; }
dcsf () { docker-compose --file "$1" run --rm "$2" sh; }

docker_exec_ssh () { ssh $1 -t "docker exec -it \$(docker container ls | awk '/$2/ {print \$NF; exit}') $3; bash"; }

brew () {
    if [[ "$@" == "up" ]]; then
        command brew update && brew upgrade && brew upgrade --cask
    elif [[ "$@" == "dump" ]]; then
        command brew bundle dump --force --no-restart --file ~/dotfiles/brew/Brewfile
    elif [[ "$@" == "load" ]]; then
        command brew bundle --file=~/dotfiles/brew/Brewfile
    else
        command brew "$@"
    fi
}


# Skole
alias fmtbackend='yarn --cwd ~/skole backend:format'
alias mypybackend='docker-compose run --no-deps --rm backend mypy .'
alias testbackend='docker-compose run --rm backend pytest --verbose .'
alias covbackend='docker-compose run --rm backend pytest --verbose --cov-report=html --cov=. . && open ~/skole/backend/htmlcov/index.html'
alias allbackend='yarn --cwd ~/skole backend:test'
alias managebackend='docker-compose run --rm backend python manage.py'

setupbackend() {
    docker-compose run --rm backend sh -c \
       'python manage.py migrate \
        && python manage.py compilemessages \
        && python manage.py loaddata test-data.yaml'
}

updatebackend () {
    docker-compose run --rm backend sh -c \
        'pip list --outdated > /tmp/pip-temp1.txt \
         && awk '\''{ print $1 }'\'' /tmp/pip-temp1.txt | sort > /tmp/pip-temp2.txt \
         && awk -F '\''=='\'' '\''{ print $1 }'\'' requirements*txt | sort > /tmp/pip-temp3.txt \
         && comm -12 /tmp/pip-temp2.txt /tmp/pip-temp3.txt | grep -f /dev/stdin /tmp/pip-temp1.txt \
         && rm /tmp/pip-temp*txt'
}


# Shuup
installbasics () {
    pip install --disable-pip-version-check --upgrade prequ setuptools wheel psycopg2 autoflake pip==19.2.*
}

installshuup () {
    installbasics
    [ -f requirements.txt ] && pip install --disable-pip-version-check -r requirements.txt
    [ -f requirements-dev.txt ] && pip install --disable-pip-version-check -r requirements-dev.txt
    [ -f requirements-test.txt ] && pip install --disable-pip-version-check -r requirements-test.txt
    python setup.py build_resources
    [ "$1" != "--no-packages" ] && [ -d ../shuup-packages ] && ls -d ../shuup-packages/* | xargs -I {} bash -c \
        "cd '{}' && pip install --disable-pip-version-check -e . && python setup.py build_resources"
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
    mkdir -p ../shuup-packages && [ ! -z "$1" ] && cp -r ~/"shuup/$1/app" "../shuup-packages/$1"; ls -la ../shuup-packages
}

unlinkshuup () {
    if [ $# -eq 0 ]; then
        rm -rf ../shuup-packages/*; ls -la ../shuup-packages
    else
        rm -rf "../shuup-packages/$1"; ls -la ../shuup-packages
    fi
}

source ~/.fzf.bash

__fzf_vim__ () {
    # FIXME: doesn't work with filenames that contain spaces.
    local file
    file=$(__fzf_select__)
    file="$(echo "${file}" | sed 's/ $//')"
    if [ -f "${file}" ]; then
        echo vim "${file}"
    fi
}
gz() {
    # Git commit browser
    # https://gist.github.com/junegunn/f4fca918e937e6bf5bad
    # Enter to show commit
    # CTRL-D to diff to current
    # CTRL-N to copy commit message
    # CTRL-H to copy commit hash
    local out shas sha q k
    while out=$(
        gl "$@" |
        fzf --ansi --multi --no-sort --reverse --query="$q" \
            --print-query --expect=ctrl-d,ctrl-n,ctrl-h); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = ctrl-d ]; then
        clear
        git diff --color=always $shas | delta --paging=always
    elif [ "$k" = ctrl-n ]; then
        git log --format=%B -n 1 "$shas" | pbcopyn
        break
    elif [ "$k" = ctrl-h ]; then
        echo -n "$shas" | pbcopyn
        break
    else
        clear
        for sha in $shas; do
            gy --color=always $sha | delta --paging=always
        done
    fi
  done
  clear
}

# Have to reset this to it's default value here after sourcing the fzf script.
bind '"\C-t": transpose-chars'

export FZF_IGNORES=Applications,Library,Movies,Music,Pictures,.git,Qt,.DS_Store,.Trash,.temp,__pycache__,venv,.pyenv,node_modules,.cache,.npm,*cache*,.stack
export FZF_DEFAULT_COMMAND='fd --type f --hidden --no-ignore --exclude "{$FZF_IGNORES}" .'
export FZF_ALT_C_COMMAND='fd --type d --type l --hidden --no-ignore --exclude "{$FZF_IGNORES}" .'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_TRIGGER='*'

export RIPGREP_CONFIG_PATH=~/dotfiles/rg/.ripgreprc

export PATH="$HOME/.cargo/bin:${PATH}"

export PATH="$HOME/.pyenv/bin:${PATH}"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

export PATH="$HOME/.local/bin:${PATH}"

export PATH="/usr/local/bin:${PATH}"
export PATH="$HOME/dotfiles/shell/exported:${PATH}"
export PATH="/usr/local/opt/postgresql@9.6/bin:${PATH}"

export PYTHONWARNINGS=ignore::UserWarning:setuptools.distutils_patch:26,ignore::UserWarning:_distutils_hack:19

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain

# Affects bat and delta
export BAT_THEME='Solarized (dark)'

# Need to be after all PATH settings.
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
