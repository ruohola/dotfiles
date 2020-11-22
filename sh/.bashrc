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

# When the shell exits, append to the history file instead of overwriting it.
shopt -s histappend

# Don't add commands starting with a space to the history.
HISTCONTROL=ignorespace

# Unlimited bash history.
HISTSIZE=
HISTFILESIZE=

# Make ** expand to any number of directories.
shopt -s globstar

# allow to create cd bookmarks, must be defined before sourcing bash_completion
shopt -s cdable_vars
export dotfiles="$HOME/dotfiles"
source ~/dotfiles/sh/.bookmarks.sh 2> /dev/null

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
alias vbok='vim ~/dotfiles/sh/.bookmarks.sh'

vims () {
    vim "scp://$1/$2"
}

alias b='cd ..'
alias bb='cd ../..'
alias bbb='cd ../../..'
alias bbbb='cd ../../../..'
alias ll='ls -la'

alias F='open .'  # Open Finder in the current directory.

alias cp='cp -v'
alias mv='mv -v'
alias grep='GREP_COLOR="1;91" grep --color'

pbcopyn () {
    # Like normal `pbcopy` but strips away all trailing newlines.
    printf '%s' "$(< /dev/stdin)" | pbcopy
}

# Colored man pages and `less`'s help.
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

alias rg='rg --hidden --follow --colors="match:fg:9"'
alias fd='fd --hidden --follow'
alias rgi='rg --no-ignore'
alias fdi='fd --no-ignore'

pyclean () {
    find . -type f -name '*.py[co]' -delete -or -type d -name __pycache__ -delete
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

alias g-='git bisect'
alias g-b='git bisect bad'
alias g-g='git bisect good'
alias ga='git add'
alias gaa='git add --all'
alias gai='git add --interactive'
alias gan='git add --intent-to-add'
alias gap='git add --patch'
alias gau='git add --update'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbdf='git branch --delete --force'
alias gbm='git branch --move'
alias gbl='git blame'
alias gc='git commit --verbose'
alias gcm='git commit --message'
alias gca='git commit --verbose --amend'
alias gcam='git commit --amend --message'
alias gcan='git commit --amend --no-edit'
alias gcC='git commit --reuse-message'
alias gcl='git clone --recurse-submodules'
alias gcli='git clean --interactive :/'
alias gcp='git cherry-pick'
alias gdc='git restore --worktree'
alias gdcp='git restore --worktree --patch'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch --all --tags --prune'
alias _gl='git log --topo-order'
alias gl='_gl --graph'
alias glc='gl --branches --tags'
alias gla='gl --branches --tags --remotes'
alias glf='_gl --format=fuller --name-status'
alias glp='_gl --format=fuller --patch'
alias glg='glf --regexp-ignore-case --grep'
alias glG='glp --regexp-ignore-case -G'
alias glS='glp --regexp-ignore-case --pickaxe-regex -S'
alias gm='git switch "$(git remote show origin | awk '\''/HEAD branch/ {print $NF}'\'')"'
alias gmt='git mergetool'
alias gpl='git pull'
alias gpsd='git push --delete'
alias gpsf='git push --force-with-lease'
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
    git rev-parse --short "${1:-HEAD}" | pbcopyn
}
ghub () {
    # Open the GitHub link for the current repo in the browser.
    remote=$(git config remote.upstream.url || git config remote.origin.url) \
    && open "$(echo "$remote" | sed 's,^[^:]*:\([^:]*\).git$,https://github.com/\1,')"
}
gini () {
    # Initalize a new repository with an initial commit.
    git init "$1" && cd "$1" && git commit --allow-empty --message 'Initial commit'
}
gms () {
    # Copy the commit message of the specified revision to the clipboard.
    # Use the latest commit as the default if no argument is passed.
    git log --format=%B -n 1 "${1:-HEAD}" | pbcopyn
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
    [ $# -ne 0 ] && vim -c "Gedit $*"
}
gyn () {
    # Show the commit like with `gy`, but disable delta's line numbers for easier copying.

    # For some reason `git -c` doesn't work with delta.
    git config --global --replace-all delta.line-numbers false
    gy "$@"
    git config --global delta.line-numbers true
}

__git_complete grb _git_rebase
__git_complete gba _git_branch
__git_complete gbd _git_branch
__git_complete gbdf _git_branch
__git_complete gbdp _git_branch
__git_complete gbm _git_branch
__git_complete gps _git_push
__git_complete gpsd _git_push
__git_complete gpsf _git_push
__git_complete gw _git_switch
__git_complete gy _git_show


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

docker_exec_ssh () { ssh "$1" -t "docker exec -it \$(docker container ls | awk '/$2/ {print \$NF; exit}') $3; bash"; }

brew () {
    if [[ "$*" == "up" ]]; then
        command brew update && brew upgrade && brew upgrade --cask
    elif [[ "$*" == "dump" ]]; then
        command brew bundle dump --force --no-restart --file ~/dotfiles/brew/Brewfile
    elif [[ "$*" == "load" ]]; then
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
        'pip list --outdated --pre > /tmp/pip-temp1.txt \
         && awk '\''{ print $1 }'\'' /tmp/pip-temp1.txt | sort > /tmp/pip-temp2.txt \
         && awk -F '\''=='\'' '\''{ print $1 }'\'' requirements*txt | sort > /tmp/pip-temp3.txt \
         && comm -12 /tmp/pip-temp2.txt /tmp/pip-temp3.txt | grep -f /dev/stdin /tmp/pip-temp1.txt \
         && rm /tmp/pip-temp*txt'
}


# Shuup
installshuup () {
    local install_packages
    local build_resources
    [[ ! "$*" =~ "--no-packages" && ! "$*" =~ "-p" ]]
    install_packages=$?
    [[ ! "$*" =~ "--no-resources" && ! "$*" =~ "-r" ]]
    build_resources=$?

    pip install --disable-pip-version-check --upgrade prequ setuptools wheel psycopg2 autoflake pip==19.2.*

    for file in requirements.txt requirements-dev.txt requirements-test.txt; do
        if [ -f "$file" ]; then
            if [ -z "$(_ls_linkedshuup)" ]; then
                pip install --disable-pip-version-check -r "$file"
            else
                # We have the check here, because when `grep --file` gets an empty input it will make the end result empty.
                pip install --disable-pip-version-check -r <(grep --invert-match --file=<(_ls_linkedshuup | sed 's/$/==/') "$file")
            fi
        fi
    done

    [ "$build_resources" -eq 0 ] && python setup.py build_resources

    if [ "$install_packages" -eq 0 ]; then 
        if [ "$build_resources" -eq 0 ]; then 
            _ls_linkedshuup | xargs -I {} sh -c \
                "pip install --disable-pip-version-check -e ~/shuup/{}/ && python ~/shuup/{}/setup.py build_resources"
        else
            _ls_linkedshuup | xargs -I {} sh -c \
                "pip install --disable-pip-version-check -e ~/shuup/{}/"
        fi
    fi

    python manage.py migrate
}

fixshuup () {
    autoflake --in-place --recursive --remove-all-unused-imports --ignore-init-module-imports "${@:-.}" && isort --apply --recursive "$@"
}

checkshuup () {
    isort --check-only --recursive "$@" && flake8 "$@" && echo all good
}

setupproject () {
    ~/Documents/scripts/setup_project.sh "$@"
    cd ~/"shuup/$2/app" || exit
}

cloneshuup () {
    pushd .
    cd ~/shuup || exit
    git clone "git@github.com:ruohola/$1.git"
    cd "$1" || exit
    git remote add upstream "git@github.com:shuup/$1.git"
    popd || exit
}

_ls_linkedshuup () {
    xmlstarlet select --indent --template --value-of \
        "/module/component[@name='NewModuleRootManager']/content[contains(@url, '/../')]/@url" "$(_idea_iml_file)" \
    | cut -d / -f 5
}

_idea_iml_file () {
    printf '../.idea/%s.iml' "$(basename "$(dirname "$PWD")")"
}

linkshuup () {
    [ $# -ne 0 ] \
        && [[ ! $(_ls_linkedshuup) =~ ^$1$'\n'|$'\n'$1$|$'\n'$1$'\n' ]] \
        && xmlstarlet edit --inplace \
            --subnode "/module/component[@name='NewModuleRootManager']" --type 'elem' --name 'content' \
            --insert '$prev' --type 'attr' --name 'url' --value "file://\$MODULE_DIR\$/../$1" \
            "$(_idea_iml_file)" \
        && xmlstarlet edit --inplace \
            --subnode "/project/component[@name='VcsDirectoryMappings']" --type 'elem' --name 'mapping' \
            --var inserted '$prev' \
            --insert '$inserted' --type 'attr' --name 'directory' --value "\$PROJECT_DIR\$/../$1" \
            --insert '$inserted' --type 'attr' --name 'vcs' --value 'Git' \
            ../.idea/vcs.xml

    _ls_linkedshuup
}

unlinkshuup () {
    if [ $# -ne 0 ]; then
        xmlstarlet edit --inplace --delete \
            "/module/component[@name='NewModuleRootManager']/content[substring(@url,string-length(@url) -string-length('/../$1') +1) = '/../$1']" \
            "$(_idea_iml_file)"
        xmlstarlet edit --inplace --delete \
            "/project/component[@name='VcsDirectoryMappings']/mapping[substring(@directory,string-length(@directory) -string-length('/../$1') +1) = '/../$1']" \
            ../.idea/vcs.xml
    else
        xmlstarlet edit --inplace --delete \
            "/module/component[@name='NewModuleRootManager']/content[contains(@url, '/../')]" \
            "$(_idea_iml_file)"
        xmlstarlet edit --inplace --delete \
            "/project/component[@name='VcsDirectoryMappings']/mapping[contains(@directory, '/../')]" \
            ../.idea/vcs.xml
    fi

    _ls_linkedshuup
}


source ~/.fzf.bash

__fzf_vim__ () {
    local file
    file=$(__fzf_select__)
    file="$(echo "${file}" | sed 's/ $//')"
    [ -z "${file}" ] || echo vim "${file}"
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
        git diff --color=always "$shas" | delta --paging=always
    elif [ "$k" = ctrl-n ]; then
        git log --format=%B -n 1 "$shas" | pbcopyn
        break
    elif [ "$k" = ctrl-h ]; then
        echo -n "$shas" | pbcopyn
        break
    else
        clear
        for sha in $shas; do
            gy --color=always "$sha" | delta --paging=always
        done
    fi
  done
  clear
}

# FIXME: These ignores don't work in MacVim, since it doesn't see the FZF_DEFAULT_COMMAND env variable.
export FZF_IGNORES=Applications,Library,Movies,Music,Pictures,.git,Qt,.DS_Store,.Trash,.temp,__pycache__,venv,.pyenv,node_modules,.cache,.npm,*cache*,.stack
export FZF_DEFAULT_COMMAND='command fd --hidden --no-ignore --exclude "{$FZF_IGNORES}" .'
export FZF_ALT_C_COMMAND='command fd --type d --type l --hidden --no-ignore --exclude "{$FZF_IGNORES}" .'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_TRIGGER='*'

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
    if [[ "$*" == "list" ]]; then
        local versions
        versions="$(pyenv install --list)"
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


# Bash specific binds (`.inputrc` only has universal ones).

# Make CTRL-L clear the screen while also refreshing the prompt.
bind '"\C-x\C-l": clear-screen'
bind '"\C-l": " \C-b\C-k \C-u\C-m\C-x\C-l\C-y\C-h\C-y\ey\C-x\C-x\C-d"'

# Open file in vim with fzf. Reference from:
# https://github.com/junegunn/fzf/blob/736344e151fd8937353ef8da5379c1082e441468/shell/key-bindings.bash#L92
bind '"\C-v": " \C-b\C-k \C-u`__fzf_vim__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'

# Remap CTRL-X_CTRL-V to CTRL-V's default behavior.
bind '"\C-x\C-v": quoted-insert'

# Remap fzf cd to dir from ALT-C to CTRL-F.
bind '"\C-f": "\ec"'
