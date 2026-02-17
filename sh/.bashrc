# shellcheck shell=bash
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -f /usr/local/bin/brew ] && eval "$(/usr/local/bin/brew shellenv)"

# Solarized colors for coloring the prompt and man pages in iTerm.
_base03=$'\e[90m'
# _base02=$'\e[30m'
# _base01=$'\e[92m'
# _base00=$'\e[93m'
# _base0=$'\e[94m'
# _base1=$'\e[96m'
# _base2=$'\e[37m'
# _base3=$'\e[97m'
# _yellow=$'\e[33m'
_orange=$'\e[91m'
# _red=$'\e[31m'
_magenta=$'\e[35m'
# _violet=$'\e[95m'
_blue=$'\e[34m'
_cyan=$'\e[36m'
_green=$'\e[32m'
# _bold=$'\e[1m'
# _underlined=$'\e[4m'
_reset=$'\e[0m'

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
# Solarized colored prompt: path/to/dir (branch)*$
export PS1="\
\[\$(__ps1_reset_title)\]\
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
export bin="${HOME}/.local/bin"
# shellcheck source=/dev/null
source ~/.sourced/bookmarks 2> /dev/null

# shellcheck source=/dev/null
[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ] && . "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
# shellcheck source=/dev/null
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
alias vbok='vim ~/.sourced/bookmarks && source ~/.sourced/bookmarks'
alias venv='vim ~/.sourced/env && source ~/.sourced/env'
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

mkcd () {
    mkdir "$@" && cd "${@: -1}" || return
}

alias rm='rm -I'

alias F='open .'  # Open Finder in the current directory.

alias cp='cp -v'
alias mv='mv -v'
alias grep='grep --color'

export GREP_COLOR='1;91'
export LESS='--chop-long-lines --RAW-CONTROL-CHARS'

alias lt='languagetool --language en-US'

alias nq='networkQuality -s'   # Sequential
alias nqd='networkQuality -u'  # Download
alias nqu='networkQuality -d'  # Upload
alias nqp='networkQuality'     # Parallel

alias jvim='jq | vim -c "set filetype=json" -'

epoch () {
    # Print the current epoch seconds, convert the passed epoch seconds into a human-readable format, or convert the passed ISO date/datetime into epoch seconds.
    if [ "$#" -eq 0 ]; then
        gdate --utc '+%s'
    elif [[ "$1" == *-* ]]; then
        gdate --utc --date="$1" '+%s'
    else  # number input
        gdate --utc --date="@$1" '+%a %Y-%m-%dT%H:%M:%SZ'
    fi
}

mepoch () {
    # Print the current epoch milliseconds, convert the passed epoch milliseconds into a human-readable format, or convert the passed ISO date/datetime into epoch milliseconds.
    if [ "$#" -eq 0 ]; then
        gdate --utc '+%s%3N'
    elif [[ "$1" == *-* ]]; then
        gdate --utc --date="$1" '+%s%3N'
    else  # number input
        local sec msec
        sec=$(("$1" / 1000))
        msec=$(("$1" % 1000))
        gdate --utc --date="@${sec}.${msec}" '+%a %Y-%m-%dT%H:%M:%S.%3NZ'
    fi
}

iso () {
    # Print the current ISO timestamp.
    gdate --utc '+%a %Y-%m-%dT%H:%M:%SZ'
}

uuid () {
    # Generate a lowercased UUID v4
    uuidgen | tr '[:upper:]' '[:lower:]'
}

uni () {
    # Print out the Unicode codepoint names of the characters in the passed input.
    python -c $'
import sys
import unicodedata

for char in sys.argv[1]:
    print(f"{char}  U+{ord(char):04X}  {unicodedata.name(char)}")
' "$1"
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

base64url () {
    local string count

    if [ "$1" = '-d' ] || [ "$1" = '--decode' ]; then
        read -r string
        string="$(echo -n "$string" | tr -- '-_' '+/')"

        count="$(echo -n "$string" | wc -c)"
        while [ $(( count % 4 )) != 0 ]; do
            string="${string}="
            count="$(echo -n "$string" | wc -c)"
        done

        base64 --decode <<< "$string"
    else
        base64 | tr -d -- '=' | tr -- '+/' '-_'
    fi
}

jwt () {
    # Decode a JSON Web Token and output its header and payload.
    # Pass -n or --no-header to just output the payload.
    # Reference from: https://gist.github.com/angelo-v/e0208a18d455e2e6ea3c40ad637aac53?permalink_comment_id=3467741#gistcomment-3467741
    local token header payload _signature

    read -r token
    read -r header payload _signature <<< "${token//./ }"

    if [ "$1" != '-n' ] && [ "$1" != '--no-header' ]; then
        echo -n "$header" | sed 's/.*[^a-zA-Z0-9_-]//' | base64url --decode | jq
    fi
    echo -n "$payload" | base64url --decode | jq
}


# Decompress a zlib stream.
alias zunzip='python -c "import sys,zlib;sys.stdout.buffer.write(zlib.decompress(sys.stdin.buffer.read()))"'

diffpdf () {
    # Diff two PDF files as text.
    # Accepts any additional arguments for `delta` (e.g. -s for side-by-side) in the end.
    delta <(pdftotext "$1" -) <(pdftotext "$2" -) "${@:3}"
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
LESS_TERMCAP_so=$_base03$(tput setab 12)
export LESS_TERMCAP_so
export LESS_TERMCAP_ue=$_reset
export LESS_TERMCAP_us=$_green

alias rg='rg --hidden --follow --colors="match:fg:9" --glob "!**/.git/"'
alias fd='fd --hidden --follow --exclude=.git/ --exclude="**/Volumes/**"'
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
# shellcheck disable=SC2142  # \$2 is for awk, not a positional parameter.
alias gau="git status -s | grep '??' | awk '{ print \$2 }' | xargs git add"  # Mnemonic: git add untracked
alias gb='git branch'
alias gba='git branch --all'
alias gbc='gba --contains'
alias gbd='git branch --delete --force'
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
alias gcre='git commit --edit --reset-author --reuse-message'
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
alias gdl='git -c delta.line-numbers=false diff'
alias gd2='git -c delta.side-by-side=true diff'
alias gds='git diff --staged'
alias gf='git fetch --all --tags --prune'
alias gff='gf --force'  # Allow clobbering existing tags.
alias gfu='git fsck --unreachable --no-reflogs'
alias gfuc='gfu | sed -n "s/.*commit \(.*\)/\1/p" | xargs git log'
alias gl='git log --graph --branches --tags --remotes'
alias gll='git log --graph --branches --tags'
alias glll='git log --graph'
alias glf='git log --format=fuller --name-status'
alias glp='git log --format=fuller --patch'
alias glg='glf --regexp-ignore-case --grep'
alias glG='glp -G'
alias glS='glp --pickaxe-regex -S'
alias glr='glf --reverse'
alias glrg='glf --reverse --regexp-ignore-case --grep'
alias glrG='glp --reverse -G'
alias glrS='glp --reverse --pickaxe-regex -S'
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gmf='git merge --ff-only'
alias gmm='git merge "$(__git_default_branch)"'
alias gpl='git pull --all --tags --prune'
alias gps='git push --follow-tags'
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
alias grd='git range-diff'
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
alias gsms='git submodule summary'
alias gsmu="export -f __git_default_branch gub gwm; git submodule foreach 'gwm && gub &'"
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
alias gwd='git switch --detach'
alias gwtl='git worktree list --verbose'
alias gy='git show --format=fuller --first-parent'
alias gyg='gy --compact-summary'
alias gyl='git -c delta.line-numbers=false show --format=fuller --first-parent'
alias gyr='gy --pretty=raw'

# Git functions
__git_root_dir () {
    # Echo the (absolute) path of the repo root directory.
    # (Works also in a nested worktree.)
    realpath "$(dirname "$(git rev-parse --git-common-dir)")"
}
__git_default_branch () {
    # Echo e.g. "master"
    local remote_branch
    remote_branch="$(__git_default_remote_branch)"
    if [ "$?" -ne 128 ]; then
        # Was a valid repo.
        if [ -n "$remote_branch" ]; then
            echo "$remote_branch" | cut -d '/' -f 2-
        else
            # No remotes configured.
            git config init.defaultBranch
        fi
    fi
}
__git_default_remote_branch () {
    # Echo e.g. "origin/master"
    git symbolic-ref --short --quiet refs/remotes/upstream/HEAD || git symbolic-ref --short --quiet refs/remotes/origin/HEAD
}
__git_is_nondefault_worktree () {
    # Return success if the argument is the name or associated branch of a non-default worktree.
    git worktree list | tail -n +2 | grep --quiet "^.*/$1 \|\[$1\]"
}
__git_worktree_path () {
    # Echo the (absolute) directory path of a git worktree based on the workree or branch name.
    git worktree list \
        | grep "^.*/$1 \|\[$1\]" \
        | awk '{print $1}'
}
__git_current_worktree () {
    # Echo the name of the current worktree.
    basename "$(git rev-parse --show-toplevel)"
}
__git_switch_to_branch_or_worktree () {
    local worktree_path current_worktree

    current_worktree="$(__git_current_worktree)"

    worktree_path="$(__git_worktree_path "$1")"

    if __git_is_nondefault_worktree "$1"; then
        cd "$worktree_path" || return
    elif [ "$1" = '-' ]; then
        git switch - 2> /dev/null || cd - || return
    elif __git_is_nondefault_worktree "$current_worktree"; then
        # If one is already in a worktree, don't allow switching branches - it just gets confusing, just try to cd instead.
        [ -n "$worktree_path" ] && cd "$worktree_path" 2> /dev/null || echo "Shouldn't switch branches in a worktree!"
    else
        git switch "$1"
    fi
}
gbdp () {
    # Delete local and remote branch.
    git branch --delete "$1"; git push --delete origin "$1"
}
gbr () {
    # Force move a branch pointer.
    # Usage: `$ gbr @~2` or `$ gbr master af1bc21`.
    # (You can note that passing one vs. two arguments logic is same as with `git branch --move`)

    local branchname startpoint

    if [ "$#" -eq 1 ]; then
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
        git diff --color=always HEAD
        git ls-files --others --exclude-standard :/ |
            while read -r file; do
                git diff --color=always -- /dev/null "$file"
            done
    ) | delta
}
gdu () {
    # Show the diff of the currently unstaged files compared to HEAD.
    # The speciality is that this also show the diff for newly created files.
    (
        git diff --color=always
        git ls-files --others --exclude-standard :/ |
            while read -r file; do
                git diff --color=always -- /dev/null "$file"
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
gld () {
    # "Diff" the logs of two branches.
    # With zero arguments passed, defaults to HEAD and master.
    # With a single argument passed, defaults to the passed and master.
    # Mnemonic: git log diff
    local first second

    if [ "$#" -eq 0 ]; then
        first="$(__git_default_remote_branch)"
        second=HEAD
    elif [ "$#" -eq 1 ]; then
        first="$(__git_default_remote_branch)"
        second="$1"
    else
        first="$1"
        second="$2"
    fi

    git log --graph "$first" "$second" "$(git merge-base "$first" "$second")"^! "${@:3}"
}
gmb () {
    # Return the merge base of the two branches.
    # With zero arguments passed, defaults to HEAD and master.
    # With a single argument passed, defaults to the passed and master.
    # Mnemonic: git merge-base
    local first second

    if [ "$#" -eq 0 ]; then
        first="$(__git_default_remote_branch)"
        second=HEAD
    elif [ "$#" -eq 1 ]; then
        first="$(__git_default_remote_branch)"
        second="$1"
    else
        first="$1"
        second="$2"
    fi

    git merge-base "$first" "$second"
}
gms () {
    # Copy the commit message of the specified revision to the clipboard.
    # Use the latest commit as the default if no argument is passed.
    git show --no-patch --format=%B "${1:-HEAD}" | pbcopyn
}
gms1 () {
    # Copy the subject line of commit message of the specified revision to the clipboard.
    # Use the latest commit as the default if no argument is passed.
    git show --no-patch --format=%s "${1:-HEAD}" | pbcopyn
}
gms2 () {
    # Copy everything but the subject line of commit message of the specified revision to the clipboard.
    # Use the latest commit as the default if no argument is passed.
    git show --no-patch --format=%b "${1:-HEAD}" | pbcopyn
}
gmt () {
    if git diff --check | grep --quiet 'leftover conflict marker'; then
        git mergetool  # Must be after the if-check since this affects its evaluation.
    else
        git mergetool  # Get the 'No files need merging' output and be really really sure that everything is resolved.
        git ls-files --unmerged | cut -f2 | sort -u | xargs git add
        gs
        gdh
    fi
}
gn () {
    # Create a new branch with the given name or switch to if it already exists.
    # The `$@` on the create call allows to pass `<branchname> <hash>` as the arguments.
    if ! __git_is_nondefault_worktree "$(__git_current_worktree)"; then
        git switch --create "$@" || git switch "$1"
    else
        echo "Shouldn't create branches in a worktree!"
    fi
}
gplm () {
    # Pull the default branch without switching to it.
    local status remote head current

    status="$(git status --porcelain --ignore-submodules)"
    [ -n "$status" ] && git stash push --include-untracked
    head="$(__git_default_branch)"
    current="$(git branch --show-current)"
    if [ "$current" != "$head" ]; then
        git switch "$head"
        gpl
        git switch -
    else
        gpl
    fi
    if [ -n "$status" ]; then
        git stash pop
    fi
}
gpsd () {
    # Delete a remote branch or tag.
    # Usage: `$ gpsd origin foo` or `$ gpsd origin/foo` or `$ gpsd remotes/origin/foo`.
    # Useful for copying the branch name arg from `git log` or `git branch` output.
    if [ "$#" -eq 1 ]; then
        # shellcheck disable=SC2046  # Intentional word splitting.
        git push --delete $(echo "$1" | sed -e 's#^remotes/\(.*/\)#\1#' -e 's#/# #')
    else
        git push --delete "$@"
    fi
}
grboa () {
    # Rebase onto a branch using the first common commit as the starting point.
    # Mnemonic: git rebase onto auto
    local newbase branch commit_subject_of_newbase start_from

    newbase="$1"

    branch="$2"  # Optional argument.
    [ -n "$branch" ] && git switch "$branch"

    commit_subject_of_newbase="$(git log --format=%s --max-count=1 "$newbase")"
    start_from="$(git log --format=%H --max-count=1 --grep="$commit_subject_of_newbase" "$(__git_default_remote_branch)..")"

    git rebase --onto "$newbase" "$start_from"
}
gtp () {
    # Tag a commit in the past.
    # Usage: $ gtp v1.0.1 af1bc21
    GIT_COMMITTER_DATE="$(git show "${2:-HEAD}" --format=%aD | head -1)" git tag --annotate --message "" "$@"
}
gub () {
    # Update the curent branch to the latest primary remote HEAD.
    local status remote head current

    status="$(git status --porcelain --ignore-submodules)"
    [ -n "$status" ] && git stash push --include-untracked
    head="$(__git_default_branch)"
    current="$(git branch --show-current)"
    if [ "$current" != "$head" ]; then
        git switch "$head"
        gpl
        git switch -
        git "${1:-rebase}" "$head"
    else
        gpl
    fi
    if [ -n "$status" ]; then
        git stash pop
    fi
}
gubm () {
    # Like `gub`, but use git merge instead of rebase.
    gub merge
}
gvi () {
    # Open the specified file at the given revision in vim.
    # Usage: $ gvi HEAD~10 foo/bar.txt
    [ "$#" -ne 0 ] && vim -c "Gedit $1:$2"
}
gw () {
    local selected
    if [ "$#" -ne 0 ]; then
        __git_switch_to_branch_or_worktree "$1"
    else
        selected="$(__fzf_select_branch__ | sed 's#^remotes/[^/]*/##')"
        [ -n "$selected" ] && __git_switch_to_branch_or_worktree "$selected"
    fi
}
gwm () {
    # Switch to the default branch.
    __git_switch_to_branch_or_worktree "$(__git_default_branch)"
}
gwmm () {
    # Switch to the default branch, update it, and delete the feature branch that you changed from.
    [ -n "$(git status --porcelain --ignore-submodules)" ] && echo 'not clean' && return
    local head current
    head=$(__git_default_branch)
    current="$(git branch --show-current)"
    [ "$head" != "$current" ] && git switch "$head" && gpl && gbd "$current"
}
gwmp () {
    # Switch to the default branch and pull latest changes.
    gwm && gpl
}
gwtn () {
    # Create a new worktree and switch to it.
    # If already on the passed branch, extracts the branch into a new worktree.
    local status current repo_root path

    if [ "$#" -eq 0 ]; then
        echo "Usage: gwtn <new-or-existing-branch> [<commit-ish>]" 1>&2
        return 1
    fi

    status="$(git status --porcelain --ignore-submodules)" || return
    [ -n "$status" ] && git stash push --include-untracked

    current="$(git branch --show-current)"
    repo_root="$(__git_root_dir)"
    path="${repo_root}/worktrees/${1}"

    if [ "$current" = "$1" ]; then
        git switch "$(__git_default_branch)"
    fi

    # Either create a new worktree and a matching branch or checkout the existing branch in the new worktree.
    { git worktree add "$path" -b "$1" "${@:2}" || git worktree add "$path" -B "$1" "$1"; } && cd "$path" || return

    if [ -n "$status" ]; then
        git stash pop
    fi

    git -C "$repo_root" status --porcelain --ignored -z \
        | grep --invert-match --extended-regexp --null-data '^!! (worktrees/.*|(.*/)?\.DS_Store)$' \
        | gsed --null-data -n 's/^!! //p' \
        | xargs --null -I % command gcp -r --strip-trailing-slashes --recursive "${repo_root}/%" %
}
gwtm () {
    # Remove a worktree.
    # Can pass `--force` as the 2nd argument to delete even uncommited changes.
    # Without any arguments (or -- as the 1st argument), deletes the current worktree.
    # (cd's back to the repo root dir if we were in the deleted worktree.)
    local worktree current_worktree repo_root path relative_path

    current_worktree="$(__git_current_worktree)"

    if [[ "$1" == '' || "$1" == '--' ]]; then
        worktree="$current_worktree"
    else
        worktree="$1"
    fi
    repo_root="$(__git_root_dir)"
    path="$(__git_worktree_path "$worktree")"
    relative_path="$(grealpath --no-symlinks --relative-to="$repo_root" "$path")"

    git worktree remove "$worktree" "${@:2}" \
        && echo "Deleted worktree ${worktree} (${relative_path})." \
        && if [ "$(basename "$worktree")" = "$current_worktree" ]; then cd "$repo_root" || return; fi
}
gwtr () {
    # Like `gwtm` but also deletes the associated branch.
    local branch

    if [[ "$1" == '' || "$1" == '--' ]]; then
        branch="$(git branch --show-current)"
    else
        branch="$1"
    fi

    gwtm "$@" && gbd "$branch"
}
# GitHub/GitLab functions
ghpr () {
    # Open a pull request.
    local output title url

    gps

    gh pr create "$@"

    # Copy the PR title + URL to clipboard.
    output="$(gh pr view)"
    title="$(echo "$output" | awk '/^title/ {$1=""; print substr($0,2)}')"
    url="$(echo "$output" | awk '/^url/ {print $2}')"
    echo -n "${title}: ${url}" | pbcopy

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
    # shellcheck disable=SC2001
    remote=$(git config remote.upstream.url || git config remote.origin.url) \
        && open "$(echo "$remote" | sed 's,^.*@\(.*\):\(.*\)\.git$,https://\1/\2,')"
}
gyo () {
    # Open the pull request where the given commit belongs to in a browser.
    gyp "${1:-HEAD}" --web
}
gyp () {
    # Show the pull request where the given commit belongs to.
    local commit subject repo pr

    commit="$(git rev-parse "${1:-HEAD}")" || return 1
    subject="$(git show --no-patch --format=%s "$commit")"

    # Try to read `(org/repo#123)` from the subject line.
    read -r repo pr <<<"$(
        sed -nE 's/.*[( ]([A-Za-z0-9_-]+\/[A-Za-z0-9_.-]+)#([0-9]+)(\)$| .*)/\1 \2/p' <<< "$subject"
    )"
    if [ -n "$repo" ]; then
        gh pr view --repo "$repo" "$pr" "${@:2}" 
        return
    fi

    # If no repo in the subject, try to read `(#123)` from the subject line.
    pr="$(sed -nE 's/.*[( ]#([0-9]+)(\)$| .*)/\1/p' <<< "$subject")"

    if [ -z "$pr" ]; then
        # If no PR number in subject, search for the latest PR that contains the commit.
        pr="$(gh pr list --state=all --limit=1 --json=number --jq '.[0].number' --search="$commit")"
    fi

    if [ -z "$pr" ]; then
        printf 'No pull request found for commit %s\n' "$commit" >&2
        return 1
    fi

    gh pr view "$pr" "${@:2}"
}

gz () {
    # Git commit browser
    # https://gist.github.com/junegunn/f4fca918e937e6bf5bad
    # Enter to show commit
    # CTRL-D to diff to current
    # CTRL-N to copy commit message
    # CTRL-H to copy commit hash
    local out shas sha selected key

    while out="$(
        git log --graph --color=always "$@" \
            | fzf --ansi --multi --no-sort --reverse --query="$selected" --print-query --expect=ctrl-d,ctrl-n,ctrl-h)"
    do
        selected="$(head -1 <<< "$out")"
        key="$(head -2 <<< "$out" | tail -1)"
        shas="$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')"
        [ -z "$shas" ] && continue
        if [ "$key" = ctrl-d ]; then
            clear
            git diff --color=always "$shas" | delta --paging=always
        elif [ "$key" = ctrl-n ]; then
            git show --no-patch --format=%B "$shas" | pbcopyn
            break
        elif [ "$key" = ctrl-h ]; then
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

__git_complete gba _git_branch
__git_complete gbd _git_branch
__git_complete gbdp _git_branch
__git_complete gbm _git_branch
__git_complete gbr _git_branch
__git_complete gbsu _git_branch
__git_complete gcp _git_cherry_pick
__git_complete gd _git_diff
__git_complete gdg _git_diff
__git_complete gl _git_log
__git_complete gll _git_log
__git_complete glll _git_log
__git_complete gld _git_log
__git_complete glf _git_log
__git_complete glp _git_log
__git_complete glg _git_log
__git_complete glG _git_log
__git_complete glS _git_log
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
__git_complete grboa _git_rebase
__git_complete grd _git_range_diff
__git_complete gre _git_remote
__git_complete grer _git_remote
__git_complete grey _git_remote
__git_complete grmc _git_rm
__git_complete grs _git_reset
__git_complete grv _git_revert
__git_complete gtd _git_tag
__git_complete gw _git_switch
__git_complete gwd _git_switch
__git_complete gwtn _git_branch  # sic, autocompleting *branch* names as the second argument creates a worktree from an existing branch.
__git_complete gwtm _git_branch  # sic, autocompleting *branch* names as they correlate with worktrees and `_git_workree` would autocomplete the subcommand.
__git_complete gwtr _git_branch  # sic, autocompleting *branch* names as they correlate with worktrees and `_git_workree` would autocomplete the subcommand.
__git_complete gy _git_show
__git_complete gyg _git_show


alias dc='docker compose'
alias dcf='docker compose --file'
alias dcb='docker compose build '
dcbf () { docker compose --file "$1" build; }
alias dcbn='docker compose build --no-cache'
alias dcu='docker compose up'
alias dcud='docker compose up --detach'
dcuf () { docker compose --file "$1" up; }
dcudf () { docker compose --file "$1" up --detach; }
dcub () { docker compose build "$@" && docker compose up "$@"; }
dcubf () { docker compose --file "$1" build && docker compose --file "$1" up; }
alias dcubn='docker compose build --no-cache && docker compose up'
alias dcd='docker compose down'
alias dcr='docker compose run --rm'
dcrf () { docker compose --file "$1" run --rm "$2"; }
alias dcs='docker compose stop'
dcsh () { docker compose run --rm "$1" sh -c 'if command -v bash > /dev/null; then bash; else sh; fi'; }
dcshf () { docker compose --file "$1" run --rm "$2" sh -c 'if command -v bash > /dev/null; then bash; else sh; fi'; }

desh () { docker exec --interactive --tty "$1" sh -c 'if command -v bash > /dev/null; then bash; else sh; fi'; }
dssh () {
    ssh "$1" -t \
        "docker exec --interactive --tty \$(docker container ls | awk '/$2/ {print \$NF; exit}') \
            sh -c \"${3:-if command -v bash > /dev/null; then bash; else sh; fi}\"; \
        bash"
}

alias kugp='kubectl get pods'
kush () { kubectl exec --stdin --tty "$1" -- sh -c 'if command -v bash > /dev/null; then bash; else sh; fi'; }

alias yif='yarn install --frozen-lockfile'

alias tff='terraform fmt -recursive'

brew () {
    if [ "$*" == "up" ]; then
        command brew update && command brew upgrade && command brew upgrade --cask
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


# shellcheck source=/dev/null
source ~/.fzf.bash

__fzf_vim__ () {
    local file
    file=$(__fzf_select__)
    file="${file% }"
    [ -z "${file}" ] || echo vim "${file}"
}
__fzf_select_branch__ () {
    # Git branch browser. Reference from:
    # https://github.com/junegunn/fzf/blob/736344e151fd8937353ef8da5379c1082e441468/shell/key-bindings.bash#L34
    local selected
    git branch --all --color=always | fzf --height=40% --reverse --ansi --tiebreak=index | sed -e 's/^[*+ ]*//' -e 's#\(^remotes/\).* -> \(.*$\)#\1\2#'
}
__fzf_branch__ () {
    local selected
    selected="$(__fzf_select_branch__ | sed -e 's#^remotes/##' -e 's/ *$/ /')"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

export FZF_IGNORES='Applications,Library,Movies,Music,Pictures,Qt,node_modules,venv,.DS_Store,.Trash,.cache,.gradle,.git,.m2,.mypy_cache,.next,.npm,.pyenv,.pytest_cache,.stack,.temp,__pycache__,build'
# shellcheck disable=SC2016  # $FZF_IGNORES expands at runtime when fzf evaluates the command.
export FZF_DEFAULT_COMMAND='command fd --hidden --no-ignore --exclude "{$FZF_IGNORES}" .'
# shellcheck disable=SC2016
export FZF_ALT_C_COMMAND='command fd --type d --type l --hidden --no-ignore --exclude "{$FZF_IGNORES}" .'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_TRIGGER='*'

export PATH="${HOME}/.cargo/bin:${PATH}"

export POETRY_HOME="${HOME}/.poetry"
export PATH="${HOME}/.poetry/bin:${PATH}"

export PATH="${HOME}/.local/bin:${PATH}"

export PATH="${HOME}/.flutter/bin:${PATH}"

export BUILDKIT_PROGRESS=plain
export DOCKER_SCAN_SUGGEST=false
export DOCKER_CLI_HINTS=false

export PYTHONPYCACHEPREFIX="${HOME}/.cache/pycache/"

export NODE_OPTIONS='--experimental-repl-await'

# Affects bat and delta.
export BAT_THEME='Solarized (dark)'

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

export NEXT_TELEMETRY_DISABLED=1
export SCARF_ANALYTICS=false

export CYPRESS_WATCH_FOR_FILE_CHANGES=false

# Need to be after all PATH settings.
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

export PYTHON_CONFIGURE_OPTS="--with-tcltk-includes='-I${HOMEBREW_PREFIX}/opt/tcl-tk/include' --with-tcltk-libs='-L${HOMEBREW_PREFIX}/opt/tcl-tk/lib -ltcl8.6 -ltk8.6'"

__pyenv_loaded=0
pyenv () {
    if [ "$__pyenv_loaded" -eq 0 ]; then
        eval "$(command pyenv init --path --no-rehash)"
        eval "$(command pyenv virtualenv-init -)"
        __pyenv_loaded=1
    fi

    if [ "$*" == "available" ]; then
        local versions
        versions="$(command pyenv install --list)"
        for version in 6 7 8 9 10 11 12 13 14
        do
            # Latest stable version.
            echo "${versions}" | grep -E "^\s+3\.${version}(\.\d+)?$" | tail -1
            if [ "$version" -ge 13 ]; then
                # Latest noGIL version.
                echo "${versions}" | grep -E "^\s+3\.${version}(\.\d+)?t$" | tail -1
            fi
        done
        # Dev versions.
        version=15
        echo "${versions}" | grep -E "^\s+3\.${version}"
    else
        command pyenv "$@"
    fi
}
python () {
    if [ "$__pyenv_loaded" -eq 0 ]; then
        eval "$(command pyenv init --path --no-rehash)"
        eval "$(command pyenv virtualenv-init -)"
        __pyenv_loaded=1
    fi
    unset -f python
    command python "$@"
}

# Lazy load nvm https://blog.yo1.dog/better-nvm-lazy-loading/
export NVM_DIR="${HOME}/.nvm"

nvm () {
    unset -f nvm
    # shellcheck source=/dev/null
    [ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh" --no-use
    nvm "$@"
}

# shellcheck source=/dev/null
[ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"

__node_bin_dir="${NVM_DIR}/versions/node/$(< "${NVM_DIR}/alias/$(< "${NVM_DIR}/alias/default")")/bin"

if [ -n "$__node_bin_dir" ]; then
    export PATH="${__node_bin_dir}:${PATH}"
fi

export SDKMAN_DIR="${HOME}/.sdkman"
# shellcheck source=/dev/null
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"

alias ghci='TERM=dump command ghci'

if [[ "$-" == *i* ]]; then
    # Bash specific binds (`.inputrc` only has universal ones).
    bind '"\C-x\C-b": backward-char'
    bind '"\C-x\C-l": clear-screen'
    bind '"\C-x\C-v": quoted-insert'

    # Make CTRL-L clear the screen while also refreshing the prompt.
    bind '"\C-l": " \C-x\C-b\C-k \C-u\C-m\C-x\C-l\C-y\C-h\C-y\ey\C-x\C-x\C-d"'

    # Open file in vim with fzf. Reference from:
    # https://github.com/junegunn/fzf/blob/736344e151fd8937353ef8da5379c1082e441468/shell/key-bindings.bash#L92
    # shellcheck disable=SC2016  # Backticks are for readline, not shell expansion.
    bind '"\C-v": " \C-x\C-b\C-k \C-u`__fzf_vim__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'

    # Fzf complete a Git branch. Reference from:
    # https://github.com/junegunn/fzf/blob/736344e151fd8937353ef8da5379c1082e441468/shell/key-bindings.bash#L81
    bind -x '"\C-b": __fzf_branch__'

    # Remap fzf cd to dir from ALT-C to CTRL-F. We need to copy the whole command here to fix \C-b mapping.
    # shellcheck disable=SC2016
    bind '"\C-f": " \C-x\C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'

    [ -r ~/.local/share/iterm2/shell_integration.bash ] && source ~/.local/share/iterm2/shell_integration.bash
fi

# Finally, load system specific environment variables and other possible overrides.
# shellcheck source=/dev/null
source ~/.sourced/env 2> /dev/null
