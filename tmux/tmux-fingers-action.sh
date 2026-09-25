#!/usr/bin/env bash

# Dispatcher for the tmux-fingers alt-action:
#   http(s):// or file:// URL -> open in browser (open)
#   #1234 or org/repo#1234    -> open PR in browser (gh)
#   7-40 char hex hash        -> show commit in a tmux popup (git show)
#   existing path[:line[:col]] -> edit in $EDITOR in a split next to the pane,
#                                 or Quick Look it if it's not text (ql)

# tmux-fingers pipes the match on stdin,
# and runs this in the original pane's working directory.
match="$(cat)"

if [[ "$match" =~ ^(https?|file):// ]]; then
    open "$match"
elif [[ "$match" =~ ^([A-Za-z0-9_-]+/[A-Za-z0-9_.-]+)#([0-9]+)$ ]]; then
    gh pr view --web --repo "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
elif [[ "$match" =~ ^#([0-9]+)$ ]]; then
    gh pr view --web "${BASH_REMATCH[1]}"
elif [[ "$match" =~ ^[0-9a-f]{7,40}$ ]]; then
    tmux display-popup -EE -w 100% -h 100% -d "$PWD" \
        "git -c core.pager='delta --paging=always' -c delta.pager='less --clear-screen' show --format=fuller --first-parent '$match'"
else
    if [[ "$match" =~ ^([^:]+):([0-9]+)(:[0-9]+)?$ ]]; then
        match="${BASH_REMATCH[1]}"
        line="${BASH_REMATCH[2]}"
    fi
    path="${match/#\~/$HOME}"

    # tmux-fingers runs this before restoring the original pane, so wait for it
    # to finish (it switches the key table back last) before touching the pane.
    for _ in {1..50}; do
        [ "$(tmux display-message -p '#{client_key_table}')" != fingers ] && break
        sleep 0.02
    done

    # A pager can run in another directory than the shell (Git starts its pager
    # in the repo root), and e.g. `git diff` paths are relative to the root.
    if [ ! -e "$path" ]; then
        shell_cwd="$(lsof -a -d cwd -Fn -p "$(tmux display-message -p '#{pane_pid}')" | sed -n 's/^n//p')"
        if [ -e "$shell_cwd/$path" ]; then
            path="$shell_cwd/$path"
        else
            root="$(git rev-parse --show-toplevel 2> /dev/null)"
            if [ -e "$root/$path" ]; then
                path="$root/$path"
            else
                tmux display-message "No such file: $match"
                exit
            fi
        fi
    fi

    # Quick Look non-text files (images, PDFs, etc.), edit the rest.
    # (`file` also calls directories and empty files binary.)
    if [ -f "$path" ] && [ -s "$path" ] && [ "$(file --brief --mime-encoding "$path")" = binary ]; then
        ql "$path"
    else
        read -ra editor <<< "${EDITOR:-vim}"
        tmux split-window -h -c "$PWD" "${editor[@]}" ${line:+"+$line"} "$path"
    fi
fi
