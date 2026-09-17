#!/bin/sh

# Zoom the current tmux pane to full vertical height.

if [ "$(tmux show -wv @vzoomed)" = '1' ]; then
    tmux select-layout "$(tmux show-buffer -b vzoom)"
    tmux set -w @vzoomed 0
else
    tmux display -p '#{window_layout}' | tmux load-buffer -b vzoom -
    tmux resize-pane -y 999
    tmux set -w @vzoomed 1
fi
