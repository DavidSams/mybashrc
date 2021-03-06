# .bash_profile for Joel's Mac Book Pro
# Last edited on 08/10/17

bashrc_dir="$HOME/repos/mybashrc/mac"

## Colors  File
## If the file exists, load .bash_colors for color variable to affect the .bash output
if [ -f "$bashrc_dir"/.bash_colors ]; then
    . "$bashrc_dir"/.bash_colors
	
	## Colored promt shell
	export PS1="\A ${c00f}\w${Rst}\\$ "
else
	## Normal promt shell
	export PS1="\A \w\\$ "
fi

## Functions File
## If file exists load .bash_funct for general bash functions
if [ -f "$bashrc_dir"/.bash_funct ]; then
    . "$bashrc_dir"/.bash_funct
fi

## Mount / Unmount sshfs (sftp) point
## If file exists load .bash_mnt for sshfs mount functions
if [ -f "$bashrc_dir"/.bash_mnt ]; then
    . "$bashrc_dir"/.bash_mnt
fi

## Append to the history file, don't overwrite it
shopt -s histappend

## For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000000
export HISTFILESIZE=10000000
export HISTIGNORE="&:[ ]*:exit"
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S : "

## Don't put duplicate lines or lines starting with space in the history.
## See bash(1) for more options
export HISTCONTROL=ignoredups:erasedups
export HISTCONTROL=ignoreboth

## Check the window size after each command and, if necessary,
## update the values of LINES and COLUMNS.
shopt -s checkwinsize

## Cmdhist
shopt -s cmdhist

## Consolidate all bash history from all terminals into one history
export PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"

## Bash Completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

## Bash-Git-Prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
    GIT_PROMPT_ONLY_IN_REPO=1
    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

## Load .bashrc in the macs home directory (for fzf?)
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

## Load .bash_alaises if there
if [ -f "$bashrc_dir"/.bash_aliases ]; then
    source "$bashrc_dir"/.bash_aliases
fi

## Unset any variables that were used in this script
unset bashrc_dir

