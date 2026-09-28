#!/bin/sh

# Show a macOS notification for the passed `notify:<message>` title of the passed pane,
# and switch to the pane when the notification is clicked. Skip the notification
# if the pane is already visible in a focused iTerm window.
#
# Anything running in the pane can set the title, so it must only ever be
# passed around as a quoted argument.

pane="$1"
title="$2"

previous="$(tmux display -p -t "$pane" '#{@title}')"

# Restore the previous title, unless the notification title has already been replaced.
# `select-pane -T` expands formats, so double the `#`s to keep e.g. a `#(command)` in the title from running.
if [ "$(tmux display -p -t "$pane" '#{pane_title}')" = "$title" ]; then
    tmux select-pane -t "$pane" -T "$(printf '%s' "$previous" | sed 's/#/##/g')"
fi

# The pane is visible if its window is current in a focused client, and the window isn't zoomed into another pane.
window="$(tmux display -p -t "$pane" '#{?#{||:#{pane_active},#{!:#{window_zoomed_flag}}},#{window_id},}')"
if [ -n "$window" ] && tmux list-clients -F '#{client_flags} #{window_id}' | grep -q "focused.* $window\$"; then
    exit
fi

# Show the previous title as the subtitle, unless it's blank.
# terminal-notifier strips a leading `\` from values, so prefix the untrusted ones
# with one to keep e.g. a `-help` or a `{` in them from being interpreted.
set --
case $previous in
    *[![:space:]]*) set -- -subtitle "\\$previous" ;;
esac

# `open` also restores a minimized iTerm window.
terminal-notifier \
    -title "$(tmux display -p -t "$pane" '#{window_name}')" \
    "$@" \
    -message "\\${title#notify:}" \
    -execute "$(command -v tmux) -S '${TMUX%%,*}' switch-client -t '$pane'; open -b com.googlecode.iterm2"
