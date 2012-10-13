# -------------------------------------------------------
# Aliases, functions & key bindings
# -------------------------------------------------------

# Substitute user/group with user symbol, if defined at ~/.user_sym
# Before : -rw-rw-r-- 1 ndbroadbent ndbroadbent 1.1K Sep 19 21:39 scm_breeze.sh
# After  : -rw-rw-r-- 1 𝐍  𝐍  1.1K Sep 19 21:39 scm_breeze.sh
if [ -e $HOME/.user_sym ]; then
  _sub_user_sym=" | sed \"s/$USER/\$(/bin/cat $HOME/.user_sym)/g\""
fi

alias l="ls -Cv --group-directories-first $_sub_user_sym"
alias ll="ls -lhv --group-directories-first $_sub_user_sym"
alias la="ls -lhvA --group-directories-first $_sub_user_sym"



alias rmrf='rm -rf'
alias ldu='du -cks * | sort -rn | head -15' # Lists the size of all the folders

alias s='sudo'
alias n='nautilus .'
alias le="less"
alias ak='ack-grep'
alias aka='ack-grep -a'
alias aki='ack-grep -i'
alias psg='ps ax | grep'
alias sbrc="source ~/.bashrc"

# Edit file function - if SCM Breeze is installed, expand numeric arguments
function edit_file() {
  if type exec_scmb_expand_args > /dev/null 2>&1; then
    exec_scmb_expand_args "$GUI_EDITOR" "$@"
  else
    "$GUI_EDITOR" "$@"
  fi
}
alias e="edit_file"

alias ~='cd ~'
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

for mod in x w r; do
  alias -- "+$mod"="chmod +$mod"
  alias -- "-$mod"="chmod -- -$mod"
done

# Aliases for scripts in ~/bin
# ----------------------------
alias cb="simple_clipboard"
# Copy contents of a file
alias cbf="simple_clipboard <"
# Copy SSH public key
alias cbs="simple_clipboard < ~/.ssh/id_rsa.pub"
# Copy current working directory
alias cbd="pwd | simple_clipboard"
# Copy current git SHA-1
alias cbg="git rev-parse --verify HEAD | simple_clipboard"

# Apt
# -------------------------------------------------
alias apt-i='sudo apt-get install -y'
alias apt-u='sudo apt-get update'
alias apt-s='apt-cache search'
apt-sd() { apt-cache search $1 | grep "lib.*dev "; } # Search for dev files
alias apt-r='sudo apt-get remove'
alias apt-a='sudo apt-get autoremove'


# -------------------------------------------------
# Include configurable bash aliases, if file exists
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# ---------------------------------------------------------
# Alias management (helper functions for ~/.bash_aliases)
# ---------------------------------------------------------

# Adds an alias to ~/.bash_aliases.
# ------------------------------------------------
add_alias() {
  if [ -n "$2" ]; then
    touch ~/.bash_aliases
    echo "alias $1=\"$2\"" >> ~/.bash_aliases
    source ~/.bashrc
  else
    echo "Usage: add_alias <alias> <command>"
  fi
}
# Adds a change directory alias to ~/.bash_aliases.
# Use '.' for current working directory.
# Changes directory, then lists directory contents.
# ------------------------------------------------
add_dir_alias() {
  if [ -n "$1" ] && [ -n "$2" ]; then
    path=`dirname $2/.`   # Fetches absolute path.
    touch ~/.bash_aliases
    echo "alias $1=\"cd $path; ll\"" >> ~/.bash_aliases
    source ~/.bashrc
  else
    echo "Usage: add_dir_alias <alias> <path>"
  fi
}
# Remove an alias
# ------------------------------------------------
rm_alias() {
  if [ -n "$1" ]; then
    touch ~/.bash_aliases
    grep -Ev "alias $1=" ~/.bash_aliases > ~/.bash_aliases.tmp
    mv ~/.bash_aliases.tmp ~/.bash_aliases
    unalias $1
    source ~/.bashrc
  else
    echo "Usage: rm_alias <alias>"
  fi
}

