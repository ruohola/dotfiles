export CLICOLOR=1  # enable syntax highlighting

# function to show git branch on the prompt, last -e flag add one space to the end
parse_git_branch () {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/$/ /'
}

# make prompt looks like this: path/to/dir (branch_if_on_git_repo)$
export PS1="\w \$(parse_git_branch)\$ "
PROMPT_DIRTRIM=3  # show only last 3 dirs in prompt

export EDITOR=vim  # vim as $EDITOR

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
