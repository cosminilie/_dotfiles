###############
# Source other files

# Senstive functions which are not pushed to Github
# It contains GOPATH, some functions, aliases etc...
[ -r ~/.bash_private ] && source ~/.bash_private


# Get it from the original Git repo: 
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
source ~/.git-prompt.sh

###############
# Exports (custom)

export GOPATH=/Users/iliec/Documents/_workspace/godev
export GOBIN=$GOPATH/bin
export PATH=$PATH:$HOME/bin:/usr/local/bin:$GOBIN
export EDITOR="vim"


# checkout `man ls` for the meaning
export LSCOLORS=cxBxhxDxfxhxhxhxhxcxcx

# enable GIT prompt color
export GIT_PS1_SHOWCOLORHINTS=true


# On Mac OS X: brew install bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

###############
# Aliases (custom)
alias ..='cd ..'
alias mvim='/usr/local/bin/mvim -v'
alias vim='/usr/local/bin/nvim'
alias vi='/usr/local/bin/nvim'
alias ls='ls -GpF' # Mac OSX specific
alias ll='ls -alGpF' # Mac OSX specific

# most used fast git commands
alias t="tig status"
alias tigs="tig status" #old habits don't die
alias d='git diff' 


###############
# Bash settings

# -- Prompt

# This is not used anymore as we use __git_ps1 for evaluatin the PS1, just here
# in case we might need it in the future
# PS1="\[$(tput setaf 6)\]\w\[$(tput sgr0)\]\[$(tput sgr0)\] \$ "

# 1. Git branch is being showed
# 2. Title of terminal is changed for each new shell
# 3. History is appended each time
export PROMPT_COMMAND='__git_ps1 "\[$(tput setaf 6)\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]" " "; echo -ne "\033]0;$PWD\007"'


# -- History

# ignoreboth ignores commands starting with a space and duplicates. Erasedups
# removes all previous dups in history
export HISTCONTROL=ignoreboth:erasedups  
export HISTFILE=~/.bash_history          # be explicit about file path
export HISTSIZE=100000                   # in memory history size
export HISTFILESIZE=100000               # on disk history size
export HISTTIMEFORMAT='%F %T '
shopt -s histappend # append to history, don't overwrite it
shopt -s cmdhist    # save multi line commands as one command

# -- Completion


bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
bind "set bell-style none" # no bell
bind "set show-all-if-ambiguous On" # show list automatically, without double tab
# bind "TAB: menu-complete" # TAB syle completion

# -- Functions

# Update Wifi setings to use Iasi static config 
ManualWorkAddr () {
local RED=$(tput setaf 1)
local GREEN=$(tput setaf 2)
local NORMAL=$(tput sgr0)

local col=10 # change this to whatever column you want the output to start at

	networksetup -setmanual Wi-Fi 10.220.40.54 255.255.0.0 10.220.0.1
if [ $? = 0 ]; then
  printf 'Sucessfull updated IP Addr %s%*s%s' "$GREEN" $col "[OK]" "$NORMAL"
else
  printf 'Updating IP Addr failed %s%*s%s' "$RED" $col "[FAIL]" "$NORMAL"
fi

	networksetup -setdnsservers Wi-Fi 10.220.10.1 10.220.10.2

if [ $? = 0 ]; then
  printf 'Sucessfull updated IP Addr %s%*s%s' "$GREEN" $col "[OK]" "$NORMAL"
else
  printf 'Updating IP Addr failed %s%*s%s' "$RED" $col "[FAIL]" "$NORMAL"
fi

}

#flush DNS cache

flushDNScache (){

local RED=$(tput setaf 1)
local GREEN=$(tput setaf 2)
local NORMAL=$(tput sgr0)
local col=10 # change this to whatever column you want the output to start at

	sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed

if [ $? = 0 ]; then
  printf 'Flush DNS Cache %s%*s%s\n' "$GREEN" $col "[OK]" "$NORMAL"
else
  printf 'Flush DNS Cache %s%*s%s' "$RED" $col "[FAIL]" "$NORMAL"
fi

}
# Set Wifi settings to use DHCP 

DhcpAddr (){
local RED=$(tput setaf 1)
local GREEN=$(tput setaf 2)
local NORMAL=$(tput sgr0)
local col=10 # change this to whatever column you want the output to start at

#Set the interface called Wi-Fi to obtain it if it isn’t already
networksetup -setdhcp Wi-Fi

if [ $? = 0 ]; then
  printf 'Sucessfull set Wi-Fi to use DHCP %s%*s%s\n' "$GREEN" $col "[OK]" "$NORMAL"
else
  printf 'Updating Wi-Fi to use DHCP failed %s%*s%s' "$RED" $col "[FAIL]" "$NORMAL"
fi

#Set DNS Servers to use the DHCP ones on the Wi-Fi connection 
networksetup -setdnsservers Wi-Fi

if [ $? = 0 ]; then
  printf 'Sucessfull updated DNS Servers on Wi-Fi %s%*s%s\n' "$GREEN" $col "[OK]" "$NORMAL"
else
  printf 'Failed updating DNS Servers %s%*s%s' "$RED" $col "[FAIL]" "$NORMAL"
fi
}

# extracts the given file
x () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# -- Misc

# Colored man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# check windows size if windows is resized
shopt -s checkwinsize

# autocorrect directory if mispelled
#shopt -s dirspell direxpand

# auto cd if only the directory name is given
#shopt -s autocd

#use extra globing features. See man bash, search extglob.
shopt -s extglob

#include .files when globbing.
shopt -s dotglob
