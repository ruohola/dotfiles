[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -f /usr/local/bin/brew ] && eval "$(/usr/local/bin/brew shellenv)"

# Solarized colors for coloring the prompt and man pages in iTerm.
_base03=$(tput setaf 8);  _base02=$(tput setaf 0);  _base01=$(tput setaf 10); _base00=$(tput setaf 11);
_base0=$(tput setaf 12);  _base1=$(tput setaf 14);  _base2=$(tput setaf 7);   _base3=$(tput setaf 15);
_yellow=$(tput setaf 3);  _orange=$(tput setaf 9);  _red=$(tput setaf 1);     _magenta=$(tput setaf 5);
_violet=$(tput setaf 13); _blue=$(tput setaf 4);    _cyan=$(tput setaf 6);    _green=$(tput setaf 2);
_bold=$(tput bold);       _underlined=$(tput smul); _reset=$(tput sgr0);      tput sgr0;

__global_python="$(cat ~/.pyenv/version)"
__ps1_venv () {
    pyenv version-name | grep --invert-match "^${__global_python}$" | sed -E 's/(.*)/(\1) /'
}
__ps1_git_branch () {
    # This doesn't use `git branch --show-current` because
    # it doesn't work with a detached HEAD.
    git branch | sed -E -e '/^[^*]/d' -e 's/\* \(?([^)]*)\)?$/\(\1\) /'
}
__ps1_git_status () {
    [ -n "$(git status --porcelain)" ] && printf '\b*'
}
__ps1_reset_title () {
    # https://gitlab.com/gnachman/iterm2/-/issues/5659#note_553863324
    printf '\e]0;\7'
}
# Solarized colored prompt: (venv) path/to/dir (branch)*$
export PS1="\
\[\$(__ps1_reset_title)\]\
\$(__ps1_venv 2> /dev/null)\
\[$_cyan\]\w \
\[$_magenta\]\$(__ps1_git_branch 2> /dev/null)\
\[$_reset\]\[\$(__ps1_git_status 2> /dev/null)\]\
\[$_cyan\]\$ \[$_reset\]\
"
export PROMPT_DIRTRIM=3  # Show only last 3 dirs in prompt.

export EDITOR=vim
export VISUAL=vim

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

# Allow to create cd bookmarks, must be defined before sourcing `bash_completion`.
shopt -s cdable_vars
export dotfiles="${HOME}/dotfiles"
export Desktop="${HOME}/Desktop"
export Documents="${HOME}/Documents"
export Downloads="${HOME}/Downloads"
export tmp="${HOME}/tmp"
export stdlib="${HOME}/.pyenv/versions/${__global_python}/lib/python${__global_python%.*}"
source ~/dotfiles/sh/bookmarks 2> /dev/null
source ~/dotfiles/sh/env 2> /dev/null

[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
[ -r ~/.local/share/bash-completion/completions/git ] && . ~/.local/share/bash-completion/completions/git

alias vvrc='vim ~/dotfiles/vim/vimrc'
alias vbrc='vim ~/dotfiles/sh/.bashrc && source ~/dotfiles/sh/.bashrc'
alias sbrc='source ~/dotfiles/sh/.bashrc'
alias vzrc='vim ~/dotfiles/sh/.zshrc && source ~/dotfiles/sh/.zshrc'
alias szrc='source ~/dotfiles/sh/.zshrc'
alias vinp='vim ~/dotfiles/sh/.inputrc && bind -f ~/dotfiles/sh/.inputrc'
alias virc='vim ~/dotfiles/vim/.ideavimrc'
alias vssh='vim ~/.ssh/config'
alias vgit='vim ~/dotfiles/git/.gitconfig'
alias vbok='vim ~/dotfiles/sh/bookmarks && source ~/dotfiles/sh/bookmarks'
alias venv='vim ~/dotfiles/sh/env && source ~/dotfiles/sh/env'
alias vlig='vim ~/dotfiles/vim/spell/en.utf-8.add'

vims () {
    vim "scp://$1/$2"
}

alias b='cd ..'
alias bb='cd ../..'
alias bbb='cd ../../..'
alias bbbb='cd ../../../..'

alias ls='gls --color=auto --group-directories-first --classify'
alias ll='ls -l --almost-all --human-readable --time-style=long-iso'

alias F='open .'  # Open Finder in the current directory.

op () {
    # Open a matching PDF file conveniently.
    [ $# -ne 0 ] && open -- *"$1"*.pdf
}

alias cp='cp -v'
alias mv='mv -v'
alias grep='grep --color'

export GREP_COLOR='1;91'
export LESS='--chop-long-lines --RAW-CONTROL-CHARS'

alias lt='languagetool --language en-US'

alias nq='networkQuality'

pc () {
    pycharm "${1:-.}"
}
ws () {
    webstorm "${1:-.}"
}

trail () {
    # Use as a pipe to remove all trailing newlines from the input.
    printf '%s' "$(< /dev/stdin)"
}

pbcopyn () {
    # Like normal `pbcopy` but strips away all trailing newlines.
    trail | pbcopy
}

unzipp () {
    # Like normal `unzip` but unzips to a directory with the same name as the zipfile.
    # https://unix.stackexchange.com/a/489450/337515
    for file in "$@"; do
        unzip -d "${file%.*}" "$file"
    done
}

throttle () {
    # Disable and enable the thottling of system processes, such as Time Machine backups.
    # https://apple.stackexchange.com/a/240073/321512
    sudo sysctl "debug.lowpri_throttle_enabled=$1"
}

flushdns () {
    # https://support.apple.com/en-ca/HT202516
    # https://apple.stackexchange.com/a/365958/321512
    sudo killall -HUP mDNSResponder \
        ; sudo killall mDNSResponderHelper \
        ; sudo dscacheutil -flushcache \
        ; echo 'DNS cache cleared'
}

alert () {
    # Send a macOS notication from the terminal.
    terminal-notifier -sender com.googlecode.iterm2 -message "$@"
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

alias rg='rg --hidden --follow --colors="match:fg:9" --glob "!**/.git/"'
alias fd='fd --hidden --follow --exclude=.git'
alias rgi='rg --ignore-case'
alias fdi='fd --ignore-case'
alias rgn='rg --no-ignore'
alias fdn='fd --no-ignore'

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
alias gam='git add --update'  # Mnemonic: git add modified
alias gan='git add --intent-to-add'
alias gap='git add --patch'
alias gau="git status -s | grep '??' | awk '{ print \$2 }' | xargs git add"  # Mnemomic: git add untracked
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbdf='git branch --delete --force'
alias gbm='git branch --move'
alias gbsu='git branch --set-upstream-to'
alias gbl='git blame'
alias gc='git commit'
alias gcm='git commit --message'
alias gca='git commit --amend'
alias gcam='git commit --amend --message'
alias gcan='git commit --amend --no-edit'
alias gcfn='git commit --fixup'
alias gcr='git commit --reset-author --reuse-message'
alias gcl='git clone --recurse-submodules'
alias gcli='git clean --interactive :/'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gdc='git restore --worktree'
alias gdcp='git restore --worktree --patch'
alias gd='git diff'
alias gdm='git diff "$(__git_default_branch)"'
alias gdg='git diff --compact-summary'
alias gdgm='git diff --compact-summary "$(__git_default_branch)"'
alias gdn='git diff --no-index'
alias gds='git diff --staged'
alias gf='git fetch --all --tags --prune'
alias _gl='git log'
alias gll='_gl --graph'
alias glc='gll --branches --tags'
alias gl='gll --branches --tags --remotes'
alias glf='_gl --format=fuller --name-status'
alias glp='_gl --format=fuller --patch'
alias glg='glf --regexp-ignore-case --grep'
alias glG='glp -G'
alias glS='glp -S'
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gmf='git merge --ff-only'
alias gmt='git mergetool'
alias gpl='git pull --all --tags --prune'
alias gpsf='git push --force-with-lease'
alias gpsfu='git push --force-with-lease --set-upstream origin HEAD'
alias gpsu='git push --follow-tags upstream HEAD'
alias gpsuu='gps && gpsu'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbia='GIT_SEQUENCE_EDITOR=: git rebase --interactive --autosquash'
alias grbid='git rebase --interactive --committer-date-is-author-date'
alias grbo='git rebase --onto'
alias gre='git remote'
alias grea='git remote add'
alias greao='git remote add origin'
alias greau='git remote add upstream'
alias grer='git remote remove'
alias grey='git remote show'
alias grl='git reflog'
alias grmc='git rm --cached'
alias grs='git reset'
alias grt='git restore'
alias grts='git restore --source'
alias grtsp='git restore --patch --source'
alias grto='git restore --ours'
alias grtt='git restore --theirs'
alias grv='git revert'
alias grva='git revert --abort'
alias grvc='git revert --continue'
alias gs='git status --untracked-files'
alias gsk='git ls-files -v | grep --color "^[Sa-z]"'
alias gsl='git shortlog'
alias gsm='git submodule'
alias gsml='git submodule foreach '\''git log $sha1..'\'''
alias gsms='git submodule summary'
alias gsmu="export -f gub gwm; git submodule foreach 'gwm && gub &'"
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
alias gyg='gy --compact-summary'
alias gyr='gy --pretty=raw'

# Git functions
__git_default_remote () {
    git remote | grep -E '(upstream|origin)' | tail -1
}
__git_default_branch () {
    git remote show "${1-$(__git_default_remote)}" | awk '/HEAD branch/ {print $NF}'
}
gbdp () {
    # Delete local and remote branch.
    git branch --delete "$1"; git push --delete origin "$1"
}
gbr () {
    # Force move a branch pointer.
    # Usage: `$ gbr @~2` or `$ gbr master af1bc21`.

    local branchname
    local startpoint

    if [ $# -eq 1 ]; then
        branchname="$(git branch --show-current)"
        startpoint="$1"
    else
        branchname="$1"
        startpoint="$2"
    fi

    # `git branch --force` will fail if $1 is the current branch, thus the fallback.
    git branch --force "$branchname" "$startpoint" 2> /dev/null \
        || { [ "$?" -eq 128 ] && git switch --force-create "$branchname" "$startpoint"; }
}
gcf () {
    # Squash staged changes to the given commit.
    commit="$(git rev-parse "$1")" \
    && git commit --fixup "$commit" \
    && GIT_SEQUENCE_EDITOR=: git rebase --interactive --autosquash "${commit}~1"
}
gdh () {
    # Show the diff of the currently staged and unstaged files compared to HEAD.
    # The speciality is that this also shows the diff for newly created files.
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
gsh () {
    # Copy the hash of the specified revision to the clipboard.
    # Use the latest commit as the default if no argument is passed.
    git rev-parse --short "${1:-HEAD}" | pbcopyn
}
gini () {
    # Initalize a new repository with an initial commit.
    git rev-parse --git-dir > /dev/null 2>&1 && return
    git init "$1" && if [ "$1" != . ]; then cd "$1"; fi && git commit --allow-empty --message 'Initial commit'
}
gms () {
    # Copy the commit message of the specified revision to the clipboard.
    # Use the latest commit as the default if no argument is passed.
    git log --format=%B -n 1 "${1:-HEAD}" | pbcopyn
}
gms1 () {
    # Copy the subject line of commit message of the specified revision to the clipboard.
    # Use the latest commit as the default if no argument is passed.
    git log --format=%s -n 1 "${1:-HEAD}" | pbcopyn
}
gms2 () {
    # Copy everything but the subject line of commit message of the specified revision to the clipboard.
    # Use the latest commit as the default if no argument is passed.
    git log --format=%B -n 1 "${1:-HEAD}" | tail -n +3 | pbcopyn
}
gn () {
    # Create a new branch with the given name or switch to if it already exists.
    # The `$@` on the create call allows to pass `<branchname> <hash>` as the arguments.
    git switch --create "$@" || git switch "$1"
}
gps () {
    # Push the current branch.
    git push --follow-tags "$@" || { [ "$?" -eq 128 ] && git push --follow-tags --set-upstream origin HEAD; }
}
gpsd () {
    # Delete a remote branch or tag.
    # Usage: `$ gpsd origin foo` or `$ gpsd origin/foo` or `$ gpsd remotes/origin/foo`.
    # Useful for copying the branch name arg from `git log` or `git branch` output.
    if [ "$#" -eq 1 ]; then
        git push --delete $(echo "$1" | sed -e 's#^remotes/\(.*/\)#\1#' -e 's#/# #')  # This cannot be quoted.
    else
        git push --delete "$@"
    fi
}
gtp () {
    # Tag a commit in the past.
    # Usage: $ gtp v1.0.1 af1bc21
    GIT_COMMITTER_DATE="$(git show "${2:-HEAD}" --format=%aD | head -1)" git tag --annotate --message "" "$@"
}
gub () {
    # Update the curent branch to the latest primary remote HEAD.
    local status
    local remote
    local head
    local current

    gpl 2> /dev/null
    status="$(git status --porcelain --ignore-submodules)"
    [ -n "$status" ] && git stash push --include-untracked
    remote="$(__git_default_remote)"
    head="$(__git_default_branch "$remote")"
    current="$(git branch --show-current)"
    if [ "$current" != "$head" ]; then
        git switch "$head"
        git rebase "${remote}/${head}"
        git switch -
        git rebase "$head"
    else
        git rebase "${remote}/${head}"
    fi
    if [ -n "$status" ]; then
        git stash pop
    fi
}
gvi () {
    # Open the specified file at the given revision in vim.
    # Usage: $ gvi HEAD~10 foo/bar.txt
    [ $# -ne 0 ] && vim -c "Gedit $1:$2"
}
gwm () {
    # Switch to the default branch.
    # This is a function so that it can be exported in `gsmu` alias.
    git switch "$(__git_default_branch)"
}
gwmm () {
    # Switch to the default branch, update it, and delete the feature branch that you changed from.
    [ -n "$(git status --porcelain --ignore-submodules)" ] && echo 'not clean' && return
    local head
    local current
    head=$(__git_default_branch)
    current="$(git branch --show-current)"
    [ "$head" != "$current" ] && git switch "$head" && gub && gbdf "$current"
}
gyn () {
    # Show the commit like with `gy`, but disable delta's line numbers for easier copying.

    # For some reason `git -c` doesn't work with delta.
    git config --global --replace-all delta.line-numbers false
    gy "$@"
    git config --global delta.line-numbers true
}

# GitHub/GitLab functions
ghpr () {
    # Open a pull request.
    gps

    local remote
    local head

    remote="$(__git_default_remote)"
    head="$(__git_default_branch "$remote")"

    gh pr create "$@"

    # Copy the PR URL to clipboard.
    gh pr view | awk '/^url/ {print $2}' | pbcopyn

    gh pr view
}
ghrc () {
    # Clone a repo more easily without the full URI.
    # Usage: $ ghrc username repo-name
    git clone --recurse-submodules "git@github.com:${1}/${2}.git" "${@:3}"
}
ghrf () {
    # Fork and clone the given repo.
    # Usage: $ ghrf username repo-name
    gh repo fork --clone "${1}/${2}" "${@:3}"
}
ghu () {
    # Open the GitHub/GitLab link for the current repo in the browser.
    remote=$(git config remote.upstream.url || git config remote.origin.url) \
        && open "$(echo "$remote" | sed 's,^.*@\(.*\):\(.*\).git$,https://\1/\2,')"
}
gyo () {
    # Like `gyp` but opens the PR in browser.
    gyp "${1:-HEAD}" --web
}
gyp () {
    # Show the pull request where the given commit was merged.
    # Some reference from: https://stackoverflow.com/a/30998048/9835872
    commit="$(git rev-parse "${1:-HEAD}")"
    pr="$(git log --format=%s -n 1 "$commit" | sed -En 's/Merge pull request #([0-9][0-9]*) from .*|.*\(#([0-9][0-9]*)\)$/\1\2/p')"

    if [ -z "$pr" ]; then
        merge_commit="$( (git rev-list "$commit..HEAD" --ancestry-path | cat -n; git rev-list "$commit..HEAD" --first-parent | cat -n) \
            | sort -k2 -s | uniq -f1 -d | sort -n | tail -1 | cut -f2 )"

        if [ -z "$merge_commit" ]; then
            # The commit is still unmerged, so just show PRs from the branch it belongs to.
            remote="$(__git_default_remote)"
            pr="$(git branch --remotes --contains "$commit" | head -n 1 | sed -nE "s/ *${remote}\/([^[:space:]]+)/\1/p")"
        else
            # The commit was merged, so find the PR number from commit the commit it was merged in.
            pr="$(git log --format=%B -n 1 "$merge_commit" | sed -nE 's/^.*#([0-9]+).*$/\1/p')"
        fi
    fi
    gh pr view "$pr" "${@:2}"
}

__git_complete gba _git_branch
__git_complete gbd _git_branch
__git_complete gbdf _git_branch
__git_complete gbdp _git_branch
__git_complete gbm _git_branch
__git_complete gbr _git_branch
__git_complete gbsu _git_branch
__git_complete gcp _git_cherry_pick
__git_complete gd _git_diff
__git_complete gdg _git_diff
__git_complete gdn _git_diff
__git_complete gm _git_merge
__git_complete gmf _git_merge
__git_complete gn _git_switch
__git_complete gps _git_push
__git_complete gpsd _git_push
__git_complete gpsf _git_push
__git_complete grb _git_rebase
__git_complete grbi _git_rebase
__git_complete grbia _git_rebase
__git_complete grbo _git_rebase
__git_complete gre _git_remote
__git_complete grer _git_remote
__git_complete grey _git_remote
__git_complete grmc _git_rm
__git_complete grs _git_reset
__git_complete grv _git_revert
__git_complete gtd _git_tag
__git_complete gw _git_switch
__git_complete gwd _git_switch
__git_complete gy _git_show
__git_complete gyg _git_show


alias dc='docker-compose'
alias dcf='docker-compose --file'
alias dcb='docker-compose build '
dcbf () { docker-compose --file "$1" build; }
alias dcbn='docker-compose build --no-cache'
alias dcu='docker-compose up'
alias dcud='docker-compose up --detach'
dcuf () { docker-compose --file "$1" up; }
dcudf () { docker-compose --file "$1" up --detach; }
dcub () { docker-compose build "$@" && docker-compose up "$@"; }
dcubf () { docker-compose --file "$1" build && docker-compose --file "$1" up; }
alias dcubn='docker-compose build --no-cache && docker-compose up'
alias dcd='docker-compose down'
alias dcr='docker-compose run --rm'
dcrf () { docker-compose --file "$1" run --rm "$2"; }
alias dcs='docker-compose stop'
dcsh () { docker-compose run --rm "$1" sh -c 'if command -v bash > /dev/null; then bash; else sh; fi'; }
dcshf () { docker-compose --file "$1" run --rm "$2" sh -c 'if command -v bash > /dev/null; then bash; else sh; fi'; }

dssh () {
    ssh "$1" -t \
        "docker exec -it \$(docker container ls | awk '/$2/ {print \$NF; exit}') \
            sh -c \"${3:-if command -v bash > /dev/null; then bash; else sh; fi}\"; \
        bash"
}

alias yif='yarn install --frozen-lockfile'

alias tff='terraform fmt -recursive'

brew () {
    if [ "$*" == "up" ]; then
        command brew update && brew upgrade && brew upgrade --cask
    elif [ "$*" == "dump" ]; then
        command brew bundle dump --force --no-restart --file ~/dotfiles/brew/Brewfile
    elif [ "$*" == "load" ]; then
        command brew bundle install --file=~/dotfiles/brew/Brewfile
    else
        command brew "$@"
    fi
}

poetry () {
    if [ "$1" == "old" ]; then
        command poetry show --outdated | grep --file=<(poetry show --tree | grep '^\w' | sed 's/^\([^ ]*\).*/^\1/')
    else
        command poetry "$@"
    fi
}


source ~/.fzf.bash

__fzf_vim__ () {
    local file
    file=$(__fzf_select__)
    file="$(echo "${file}" | sed 's/ $//')"
    [ -z "${file}" ] || echo vim "${file}"
}
gz () {
    # Git commit browser
    # https://gist.github.com/junegunn/f4fca918e937e6bf5bad
    # Enter to show commit
    # CTRL-D to diff to current
    # CTRL-N to copy commit message
    # CTRL-H to copy commit hash
    local out shas sha q k
    while out=$(
        git log --graph --color=always "$@" |
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
export FZF_IGNORES=Applications,Library,Movies,Music,Pictures,Qt,node_modules,venv,.DS_Store,.Trash,.cache,.gradle,.git,.m2,.mypy_cache,.next,.npm,.pyenv,.pytest_cache,.stack,.temp,__pycache__
export FZF_DEFAULT_COMMAND='command fd --hidden --no-ignore --exclude "{$FZF_IGNORES}" .'
export FZF_ALT_C_COMMAND='command fd --type d --type l --hidden --no-ignore --exclude "{$FZF_IGNORES}" .'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_TRIGGER='*'

export PATH="${HOME}/.cargo/bin:${PATH}"

export POETRY_HOME="${HOME}/.poetry"
export PATH="${HOME}/.poetry/bin:${PATH}"

export PATH="${HOME}/.local/bin:${PATH}"

export PATH="${HOME}/.flutter/bin:${PATH}"

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export BUILDKIT_PROGRESS=plain
export DOCKER_SCAN_SUGGEST=false

export PYTHONPYCACHEPREFIX="${HOME}/.cache/pycache/"

export NODE_OPTIONS='--experimental-repl-await'

# Affects bat and delta.
export BAT_THEME='Solarized (dark)'

export HOMEBREW_NO_AUTO_UPDATE=1

export NEXT_TELEMETRY_DISABLED=1
export SCARF_ANALYTICS=false

# Need to be after all PATH settings.
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init --path --no-rehash)"
eval "$(pyenv virtualenv-init -)"

pyenv () {
    if [ "$*" == "list" ]; then
        local versions
        versions="$(pyenv install --list)"
        for version in 6 7 8 9 10
        do
             echo "${versions}" | command grep -E "^\s+3\.${version}" | tail -1
        done
        for version in 11
        do
             echo "${versions}" | command grep -E "^\s+3\.${version}"
        done
    else
        command pyenv "$@"
    fi
}

# Lazy load nvm https://blog.yo1.dog/better-nvm-lazy-loading/
export NVM_DIR="${HOME}/.nvm"

nvm () {
    unset -f nvm
    [ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh" --no-use
    nvm $@
}

[ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"

__node_bin_dir="$(dirname "$(~/dotfiles/scripts/node_path.sh)")"

if [ ! -z "$__node_bin_dir" ]; then
    export PATH="${__node_bin_dir}:${PATH}"
fi

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
