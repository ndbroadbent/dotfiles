# -------------------------------------------------------
# Aliases, functions & key bindings
# -------------------------------------------------------

alias l='ls -Cv --group-directories-first'
alias ll='ls -lv --group-directories-first'
alias la='ls -lvA --group-directories-first'
alias ldu='du -cks * | sort -rn | head -15' # Lists the size of all the folders

alias s='sudo'
alias n='nautilus .'
alias le="less"
alias ak='ack-grep'
alias aka='ack-grep -a'
alias aki='ack-grep -i'
alias psg='ps ax | grep'
alias sbrc="source ~/.bashrc"
if type exec_git_expand_args > /dev/null 2>&1; then
  alias e="exec_git_expand_args $GUI_EDITOR"
else
  alias e="$GUI_EDITOR"
fi

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

