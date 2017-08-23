## ~/.bashrc: executed by bash(1) for non-login shells.

## If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

## bashrc files directory
bashrc_dir="$HOME/repos/my-bashrc/desktop"

## Colors  File
## If the file exists, load .bash_colors for color variable to affect the .bash output
if [ -f "$bashrc_dir"/.bash_colors ]; then
    . "$bashrc_dir"/.bash_colors
fi

## Check the window size after each command and, if necessary,
## update the values of LINES and COLUMNS.
shopt -s checkwinsize

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

## Bash functions File
## If file exists, load .bash_funct for all .bashrc functions
if [ -f "$bashrc_dir"/.bash_funct ]; then
    . "$bashrc_dir"/.bash_funct
fi

## Mount / Unmount sshfs (sftp)
## If the file exists, load .bash_mnt for sshfs mount functions
if [ -f "$bashrc_dir"/.bash_mnt ]; then
    . "$bashrc_dir"/.bash_mnt
fi

## Alias definitions.
## If the file exists, load .bash_aliases for bash aliases
if [ -f "$bashrc_dir"/.bash_aliases ]; then
    . "$bashrc_dir"/.bash_aliases
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

# Automatically add completion for all aliases to commands having completion functions
# Copied from here -> https://superuser.com/questions/436314/how-can-i-get-bash-to-perform-tab-completion-for-my-aliases
function alias_completion {
    local namespace="alias_completion"

    # parse function based completion definitions, where capture group 2 => function and 3 => trigger
    local compl_regex='complete( +[^ ]+)* -F ([^ ]+) ("[^"]+"|[^ ]+)'
    # parse alias definitions, where capture group 1 => trigger, 2 => command, 3 => command arguments
    local alias_regex="alias ([^=]+)='(\"[^\"]+\"|[^ ]+)(( +[^ ]+)*)'"

    # create array of function completion triggers, keeping multi-word triggers together
    eval "local completions=($(complete -p | sed -Ene "/$compl_regex/s//'\3'/p"))"
    (( ${#completions[@]} == 0 )) && return 0

    # create temporary file for wrapper functions and completions
    rm -f "/tmp/${namespace}-*.tmp" # preliminary cleanup
    local tmp_file; tmp_file="$(mktemp "/tmp/${namespace}-${RANDOM}XXX.tmp")" || return 1

    local completion_loader; completion_loader="$(complete -p -D 2>/dev/null | sed -Ene 's/.* -F ([^ ]*).*/\1/p')"

    # read in "<alias> '<aliased command>' '<command args>'" lines from defined aliases
    local line; while read line; do
        eval "local alias_tokens; alias_tokens=($line)" 2>/dev/null || continue # some alias arg patterns cause an eval parse error
        local alias_name="${alias_tokens[0]}" alias_cmd="${alias_tokens[1]}" alias_args="${alias_tokens[2]# }"

        # skip aliases to pipes, boolean control structures and other command lists
        # (leveraging that eval errs out if $alias_args contains unquoted shell metacharacters)
        eval "local alias_arg_words; alias_arg_words=($alias_args)" 2>/dev/null || continue
        # avoid expanding wildcards
        read -a alias_arg_words <<< "$alias_args"

        # skip alias if there is no completion function triggered by the aliased command
        if [[ ! " ${completions[*]} " =~ " $alias_cmd " ]]; then
            if [[ -n "$completion_loader" ]]; then
                # force loading of completions for the aliased command
                eval "$completion_loader $alias_cmd"
                # 124 means completion loader was successful
                [[ $? -eq 124 ]] || continue
                completions+=($alias_cmd)
            else
                continue
            fi
        fi
        local new_completion="$(complete -p "$alias_cmd")"

        # create a wrapper inserting the alias arguments if any
        if [[ -n $alias_args ]]; then
            local compl_func="${new_completion/#* -F /}"; compl_func="${compl_func%% *}"
            # avoid recursive call loops by ignoring our own functions
            if [[ "${compl_func#_$namespace::}" == $compl_func ]]; then
                local compl_wrapper="_${namespace}::${alias_name}"
                    echo "function $compl_wrapper {
                        (( COMP_CWORD += ${#alias_arg_words[@]} ))
                        COMP_WORDS=($alias_cmd $alias_args \${COMP_WORDS[@]:1})
                        (( COMP_POINT -= \${#COMP_LINE} ))
                        COMP_LINE=\${COMP_LINE/$alias_name/$alias_cmd $alias_args}
                        (( COMP_POINT += \${#COMP_LINE} ))
                        $compl_func
                    }" >> "$tmp_file"
                    new_completion="${new_completion/ -F $compl_func / -F $compl_wrapper }"
            fi
        fi

        # replace completion trigger by alias
        new_completion="${new_completion% *} $alias_name"
        echo "$new_completion" >> "$tmp_file"
    done < <(alias -p | sed -Ene "s/$alias_regex/\1 '\2' '\3'/p")
    source "$tmp_file" && rm -f "$tmp_file"
}; alias_completion

## Unset any variables that were used in this script
unset color_prompt force_color_prompt bashrc_dir
