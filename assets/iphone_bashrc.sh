# Aliases and functions for iPhone .bashrc
# ========================================

# Setup:

# 1) copy this file to /var/root/.bashrc
# 2) Add this line to /etc/profile:
#       source /var/root/.bashrc      

# -------------------------------------------------------
# Prompt / Xterm
# -------------------------------------------------------

# Colored Prompt
force_color_prompt=yes
PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\w $ "
unset color_prompt force_color_prompt

# Custom Xterm Title
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    ;;
*)
    ;;
esac

# -------------------------------------------------------
# Aliases (& functions)
# -------------------------------------------------------

# -- bash

alias ll='ls -l --color=auto'
alias v='vim'
function cs() { if [ $1 ]; then cd $1; fi && ll; }  # (c)hange directory & li(s)t contents
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias respring="killall SpringBoard"
