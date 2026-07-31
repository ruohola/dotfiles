#!/bin/sh

# Toggle an iTerm2 "focus mode": either the default narrow side margins or wide
# ones eating `focus_percentage` of the window width on each side.
#
# Requires: System Settings > Privacy & Security > Accessibility > iTerm.app ON

default_margin=5
focus_percentage=25

# iTerm2 starts drawing with an externally written margin right away, but keeps
# its old character grid until the window gets re-laid out, leaving the content
# stuck at the previous width. Nudge the width by a pixel and back to force the
# recalculation, which resizes tmux along with it.
relayout_window() {
    osascript \
        -e 'tell application "System Events"' \
        -e 'tell window 1 of process "iTerm2"' \
        -e 'set {w, h} to size' \
        -e 'set size to {w - 1, h}' \
        -e 'set size to {w, h}' \
        -e 'end tell' \
        -e 'end tell' 2> /dev/null
}

# A row's background color otherwise bleeds across the margins, which keeps the
# tmux status bar spanning the whole window while its contents stop at the
# content edge. Only worth turning off while the margins are wide.
if [ "$(defaults read com.googlecode.iterm2 TerminalMargin 2> /dev/null)" != "$default_margin" ]; then
    defaults write com.googlecode.iterm2 TerminalMargin -int "$default_margin"
    defaults write com.googlecode.iterm2 ExtendBackgroundColorIntoMargins -bool true
else
    width=$(osascript -e 'tell application "System Events" to get item 1 of (get size of window 1 of process "iTerm2")' 2> /dev/null)

    case $width in
        '' | *[!0-9]*)
            tmux display-message 'Could not read the iTerm2 window width'
            exit 1
            ;;
    esac

    defaults write com.googlecode.iterm2 TerminalMargin -int $((width * focus_percentage / 100))
    defaults write com.googlecode.iterm2 ExtendBackgroundColorIntoMargins -bool false
fi

relayout_window
