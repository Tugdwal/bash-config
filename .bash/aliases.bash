#!/bin/bash

alias e="exit"
alias ex="exit"
alias exi="exit"

alias cd..="cd .."
alias ..="cd .."

alias ll="ls -alF"
alias la="ls -A"

alias apti="sudo apt install"
alias apts="sudo apt search"
alias aptr="sudo apt remove"
alias aptu="sudo apt update"

if [ -x "/usr/bin/dircolors" ]; then
    (test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)") || eval "$(dircolors -b)"

    alias ls="ls --color=auto -F"

    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
fi

# Add an "alert" alias for long running commands. Use like so : sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

