# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# append to the history file, don't overwrite it
shopt -s histappend

export HISTSIZE=20000
export HISTFILESIZE=$HISTSIZE
# don't put duplicate lines in the history,
# ignore lines starting with a space
export HISTCONTROL=ignoredups:ignorespace
# ignore some common commands
export HISTIGNORE="&:ls:ll:gs:gd:[bf]g:exit:pwd:clear:mount:umount"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /etc/bash_completion ]; then
		source /etc/bash_completion;
	elif [ -f /usr/local/etc/bash_completion ]; then
		source /usr/local/etc/bash_completion;
  elif [ -f /opt/local/etc/bash_completion ]; then
    source /opt/local/etc/bash_completion
  elif [ -f /opt/homebrew/etc/bash_completion ]; then
    source /opt/homebrew/etc/bash_completion
	fi
fi

# Default editors
export EDITOR="cursor --wait"
export VISUAL="cursor --wait"
export GUI_EDITOR="cursor"
export REACT_EDITOR="cursor"
export BUNDLER_EDITOR="cursor"
export GIT_EDITOR="vim"
export KUBE_EDITOR="cursor --wait"

# GPG
export GPG_TTY=$(tty)

# Add /usr/local/sbin
export PATH="$PATH:/usr/local/sbin"

# Homebrew updates way too regularly by default
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

# Don't worry about /var/mail/ notifications
unset MAILCHECK

store_cwd() { pwd > ~/.cwd~; }
autoreload_prompt_command+="store_cwd;"

# Set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# https://superuser.com/questions/433746/is-there-a-fix-for-the-too-many-open-files-in-system-error-on-os-x-10-7-1
ulimit -n 1000000
ulimit -u 2048

# Use Touch ID and Apple Watch for sudo
# From: https://news.ycombinator.com/item?id=26304832
# Also: https://akrabat.com/add-apple-watch-authentication-to-sudo/

# WARNING: THIS IS BROKEN ON LATEST MACOS.

# sudo() {
#     unset -f sudo
#     if [[ "$(uname)" == 'Darwin' ]]; then
#         if ! [ -f /usr/local/lib/pam/pam_watchid.so.2 ]; then
#             echo "=> Apple Watch PAM library not found." \
#                  "Please compile and install pam_watchid: https://github.com/biscuitehh/pam-watchid"
#         elif ! grep -q 'Touch ID and Apple Watch' /etc/pam.d/sudo; then
#             echo "=> Setting up Touch ID and Apple Watch for sudo... (sudo password is required)"
#             sudo sed -i -e '1s;^;# Touch ID and Apple Watch added by dotfiles/bashrc/default.sh\nauth       sufficient     pam_tid.so\nauth       sufficient     pam_watchid.so\n;' /etc/pam.d/sudo
#         fi
#     fi
#     sudo "$@"
# }
