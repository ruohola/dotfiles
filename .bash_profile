# SGR - SELECT GRAPHIC RENDITION
# 0 => default rendition (implementation-defined), cancels the effect
# of any preceding occurrence of SGR in the data stream regardless
# of the setting of the GRAPHIC RENDITION COMBINATION MODE (GRCM)
tput sgr0
# solarized colors for coloring prompt
BASE03=$(tput setaf 234)
BASE02=$(tput setaf 235)
BASE01=$(tput setaf 240)
BASE00=$(tput setaf 241)
BASE0=$(tput setaf 244)
BASE1=$(tput setaf 245)
BASE2=$(tput setaf 254)
BASE3=$(tput setaf 230)
YELLOW=$(tput setaf 136)
ORANGE=$(tput setaf 166)
RED=$(tput setaf 160)
MAGENTA=$(tput setaf 125)
VIOLET=$(tput setaf 61)
BLUE=$(tput setaf 33)
CYAN=$(tput setaf 37)
GREEN=$(tput setaf 64)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# function to show git branch on the prompt, last -e flag add one space to the end
parse_git_branch () {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/$/ /'
}

# make prompt looks like this: path/to/dir (branch_if_on_git_repo) $
# export PS1="\w \$(parse_git_branch)\$ "
export PS1="\[$CYAN\]\w \[$MAGENTA\]\$(parse_git_branch)\[$CYAN\]\$ \[$RESET\]"  # solarized colored prompt
PROMPT_DIRTRIM=3  # show only last 3 dirs in prompt

export EDITOR=vim  # vim as $EDITOR

export CLICOLOR=1  # enable syntax highlighting

# needed for something to not break, don't remove
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# bash history gets written immediately
shopt -s histappend
PROMPT_COMMAND='history -a;history -n'

# unlimited bash history
HISTSIZE= 
HISTFILESIZE=

# enables autocompletion if it exists
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
fi
bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

# Changes to a block cursor when called, used to make vim always start with a block cursor
block_cursor () {
    echo -e -n "\x1b[\x32 q"
}

alias vim='block_cursor && mvim -v'
alias vimdiff='block_cursor && mvimdiff -v'
alias fg='block_cursor && fg'

alias vbrc='vim ~/.bash_profile && source ~/.bash_profile'
alias virc='vim ~/.inputrc'
alias vvrc='vim ~/.vim/vimrc'

alias lsa='ls -a'
