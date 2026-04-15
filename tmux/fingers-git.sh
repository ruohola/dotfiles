#!/usr/bin/env bash

# Dispatcher for the tmux-fingers alt-action:
#   #1234 or org/repo#1234  -> open PR in browser (gh)
#   7-40 char hex hash      -> show commit in a tmux popup (git show)

# tmux-fingers pipes the match on stdin.
match="$(cat)"

cwd="$(tmux display-message -p '#{pane_current_path}')"
cd "$cwd" 2>/dev/null || true

if [[ "$match" =~ ^([A-Za-z0-9_-]+/[A-Za-z0-9_.-]+)#([0-9]+)$ ]]; then
    gh pr view --web --repo "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
elif [[ "$match" =~ ^#([0-9]+)$ ]]; then
    gh pr view --web "${BASH_REMATCH[1]}"
elif [[ "$match" =~ ^[0-9a-f]{7,40}$ ]]; then
    tmux display-popup -EE -w 100% -h 100% -d "$cwd" \
        "git -c core.pager='delta --paging=always' -c delta.pager='less --clear-screen' show --format=fuller --first-parent '$match'"
fi
