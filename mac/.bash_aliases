## Aliases

#Reload the .bash_profile
alias breload='source ~/.bash_profile; say bash profile reloaded;'

## Will make any parent directories necessary
alias mkdir="mkdir -pv"

alias ls='ls -Gh'
alias ll='ls -aFl'
alias lll='ls -Fl'
alias lr='ll -R'
#alias ll='ls -alp | grep "^d" && ls -alp | grep "^-" && ls -alp | grep "^l"'

### Function Aliases
alias syncup=syncupstreamfunction
alias newbr=newbranchfunction
alias prepbr=prepbranchfunction
alias pushbr=pushbranchfunction

## Vagrant Aliases
alias vm='vagrant ssh'

## Aliases for git stuff
alias st='git status'
alias ga=gitAdd
alias gc='git commit'
alias gch=gitCheckout
alias gd='git diff'
alias gp='git push'

## Aliases for fuzzy finder
alias openit='open $(fzf)'
alias vimit='vim $(fzf)'
alias mvimit='mvim -p --remote-tab-silent $(fzf)'
alias subit='sublime $(fzf)'

## Mount sftp drive (Have to have it set up in ~/.bashrc)
alias mnt=MountSSHFS
alias umnt=UnmountSSHFS

## Clear the screen of your clutter
alias clear='clear;pwd;'

## Directory navigation aliases
alias cd..='cd ..' # change to parent directory, even when you forget the space.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
