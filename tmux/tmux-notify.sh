#!/bin/sh

# Show a macOS notification for the `notify:<message>` title of the passed pane,
# and switch to the pane when the notification is clicked.
#
# Anything running in the pane can set the title, so it must only ever be
# passed around as a quoted argument.

pane="$1"

title="$(tmux display -p -t "$pane" '#{pane_title}')"
case $title in
    notify:*) ;;
    *) exit ;;
esac

previous="$(tmux display -p -t "$pane" '#{@title}')"

# Restore the previous title. `select-pane -T` expands formats, so double the `#`s
# to keep e.g. a `#(command)` in the title from running.
tmux select-pane -t "$pane" -T "$(printf '%s' "$previous" | sed 's/#/##/g')"

# Show the previous title as the subtitle, unless it's blank.
set --
case $previous in
    *[![:space:]]*) set -- -subtitle "$previous" ;;
esac

# `open` also restores a minimized iTerm window.
terminal-notifier \
    -title "$(tmux display -p -t "$pane" '#{window_name}')" \
    "$@" \
    -message "${title#notify:}" \
    -execute "$(command -v tmux) -S '${TMUX%%,*}' switch-client -t '$pane'; open -b com.googlecode.iterm2"
