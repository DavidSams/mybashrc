## ~/.bashrc: executed by bash(1) for non-login shells.
## see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples

## If not running interactively, don't do anything
[ -z "$PS1" ] && return

## Check the window size after each command and, if necessary,
## update the values of LINES and COLUMNS.
shopt -s checkwinsize

## bashrc files directory
bashrc_dir=~/repos/my-bashrc/desktop

## Colors  File
## If file exists load .bash_colors for color variables to affect shell output
if [ -f "$bashrc_dir"/.bash_colors ]; then
    . "$bashrc_dir"/.bash_colors
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

## Bash-Git-Prompt
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_FETCH_REMOTE_STATUS=0       # avoid fetching remote status
#GIT_PROMPT_SHOW_UPSTREAM=1            # show upstream tracking branch
#GIT_PROMPT_SHOW_UNTRACKED_FILES=all   # determines counting of untracked files (no, normal or all) 
#GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # avoid printing the number of changed files
#GIT_PROMPT_THEME=Custom               # use theme specified in file GIT_PROMPT_THEME_FILE (default ~/.git-prompt-colors.sh)
#GIT_PROMPT_THEME_FILE=~/.git-prompt-colors.sh
#GIT_PROMPT_THEME=Solarized            # use theme optimized for solarized color scheme
source ~/.bash-git-prompt/gitprompt.sh

## Don't put duplicate lines or lines starting with space in the history.
## See bash(1) for more options
HISTCONTROL=ignoreboth

## Append to the history file, don't overwrite it
shopt -s histappend

## For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

## If set, the pattern "**" used in a pathname expansion context will
## match all files and zero or more directories and subdirectories.
#shopt -s globstar

## Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

## Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=true;;
esac

## Uncomment for a colored prompt, if the terminal has the capability; turned
## off by default to not distract the user: the focus in a terminal window
## should be on the output of commands, not on the prompt
force_color_prompt=true

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	## We have color support; assume it's compliant with Ecma-48
	## (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	## a case would tend to support setf rather than setaf.)
	color_prompt=true
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = true ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

## If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

## Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

## Add an "alert" alias for long running commands.  Use like so:
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
#sleep 10; alert

## Alias definitions.
## You may want to put all your additions into a separate file like ~/.bash_aliases
if [ -f "$bashrc_dir"/.bash_aliases ]; then
    . "$bashrc_dir"/.bash_aliases
fi

## Enable programmable completion features (you don't need to enable
## this, if it's already enabled in /etc/bash.bashrc and /etc/profile
## sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## FZF Command Line Fuzzy Finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

## Unset any variables used in this script
unset color_prompt force_color_prompt bashrc_dir
