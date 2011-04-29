# Aliases and functions for .bashrc
# ====================================

# Command to update this file from GitHub
alias pull_bashrc='cd --MYNIX_DIR-- && git pull origin master && ./bashrc_setup.sh && cd -'

# -------------------------------------------------------
# Prompt / Xterm
# -------------------------------------------------------

# Prompt colors
_txt_col="\[\033[00m\]"    # Std text (white)
_sep_col=$_txt_col         # Separators
_usr_col="\[\033[01;32m\]" # Username
_cwd_col=$_txt_col         # Current directory
_hst_col="\[\033[0;32m\]"  # Host
_env_col="\[\033[0;36m\]"  # Prompt environment
_git_col="\[\033[01;36m\]" # Git branch

# Returns the current git branch (returns nothing if not a git repository)
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# Returns the current ruby version.
parse_ruby_version() {
  if (which ruby | grep -q ruby); then
    ruby -v | cut -d ' ' -f2
  fi
}

# Set the prompt string (PS1)
set_ps1() {
  user_str="$_usr_col\u$_hst_col@\h$_txt_col"
  dir_str="$_cwd_col\w"
  git_branch=`parse_git_branch`
  ruby=`parse_ruby_version`
  if [ -n "$git_branch" ]; then git_branch="$_git_col$git_branch$_env_col"; fi   # -- colorize
  if [ -n "$git_branch" ] && [ -n "$ruby" ]; then git_branch="$git_branch|"; fi  # -- separator
  if [ -n "$git_branch" ] || [ -n "$ruby" ]; then
    env_str="$_env_col[$git_branch$ruby$_env_col]"
  else
    unset env_str
  fi
  PS1="${debian_chroot:+($debian_chroot)}$user_str $dir_str $env_str$_sep_col$ $_txt_col"
}

# Set custom prompt
PROMPT_COMMAND='set_ps1;'

# Custom Xterm/RXVT Title
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND+='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007";'
    ;;
*)
    ;;
esac

# Correct spelling errors for 'cd' command, and auto cd to directory
# Only run this for debian systems (AWS doesn't have 'shopt')
if [ -f /etc/debian_version ]; then
  shopt -s cdspell
  shopt -s autocd
fi

# XClip clipboard helper function
function cb(){
  _success_col="\e[1;32m"
  _warn_col='\e[1;31m'
  if [ -n "$1" ]; then
    # Check user is not root (root doesn't have access to user xorg server)
    if [[ $(whoami) == root ]]; then
      echo -e "$_warn_col Must be regular user to copy a file to the clipboard!\e[0m"
      exit
    fi
    # Copy text to clipboard
    echo -n $1 | xclip -selection c
    echo -ne $_success_col; echo -e "Copied to clipboard:\e[0m $1"
  else
    echo "Copies first argument to clipboard. Usage: cb <string>"
  fi
}

# -------------------------------------------------------
# Share Bash history across sessions
# -------------------------------------------------------

export HISTSIZE=9000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignorespace:ignoredups

history() {
  _bash_history_sync
  builtin history "$@"
}

_bash_history_sync() {
  builtin history -a         #[1]
  HISTFILESIZE=$HISTFILESIZE #[2]
  builtin history -c         #[3]
  builtin history -r         #[4]
}

export PROMPT_COMMAND+='_bash_history_sync;'


# -------------------------------------------------------
# Aliases (& functions)
# -------------------------------------------------------

# -- bash

alias ll='ls -l'
alias n='nautilus .'
alias g='gedit'
alias apt-install='sudo apt-get install -y '

# (c)hange directory & (l)ist contents
function cdl() { if [ -n "$1" ]; then cd $1; fi && ll; }

alias ~='cd ~'
alias src='cd ~/src && ll'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias ak='ack-grep'

# Include configurable bash aliases, if file exists
if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi

# -- git
alias gpl='git pull'
alias gps='git push'
alias gpsom='git pull origin master'
alias gplom='git push origin master'
alias gs='gst'
alias ga='git add '
alias gaa='git add -A'
alias gc='git commit -m'
alias gca='git commit -am'
alias gd='git diff'
alias gdc='git diff --cached'
alias pdp='git push origin master; cap preview deploy'
alias pdl='git push origin master; cap live deploy'

# -- rvm / ruby / rails
alias gemdir='cd $GEM_HOME/gems'

# Rails 3
alias rs='rails s -u'
alias rc='rails c'
# Rails 2.x.x
alias rs2='./script/server -u'
alias rc2='./script/console'

# This loads RVM into the shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
# Execute .rvmrc if exists
if [ -f .rvmrc ]; then
  . .rvmrc
fi

# -------------------------------------------------------
# Custom Functions
# -------------------------------------------------------

# Little calculator function - "$ ? 1337 - 1295" prints "42".
# ===========================================================
? () { echo "$*" | bc -l; }


# Alias management
# ===========================================================

# Adds an alias to ~/.bash_aliases.
# ------------------------------------------------
function add_alias() {
  if [ -n "$1" ] && [ -n "$2" ]; then
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
function add_dir_alias() {
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
function rm_alias() {
  if [ -n "$1" ]; then
    grep -Ev "alias $1=" ~/.bash_aliases > ~/.bash_aliases.tmp
    mv ~/.bash_aliases.tmp ~/.bash_aliases
    unalias $1
    source ~/.bashrc
  else
    echo "Usage: rm_alias <alias>"
  fi
}


# Search and replace strings within all files in current dir (recursive).
# =======================================================================
function gsed () {
  if [ -n "$3" ]; then
    egrep --exclude-dir=.git -lRZ "$1" $3 | xargs -0 -l sed -i -e "s/$1/$2/g"
  else
    echo "== Usage: gsed search_string replace_string [path]"
  fi
}


# Processes your git status output, exporting bash variables
# for the filepaths of each modified file.
# Written by Nathan D. Broadbent (www.f-77.com)
# =======================================================================
function gst () {
  pfix="e" # Set your preferred shortcut letter here

  IFS=$'\n '   # Split by newline and space.
  f=0          # Counter for the number of files
  max_changes=15

  # Only export variables for less than $max_changes
  if [ `git status --porcelain | wc -l` -lt $max_changes ]; then
    status=`git status --porcelain`   # Get the 'script' version of git status
    c=1
    for file in $status; do
      # All actions will be on odd lines, all filenames are on even lines.
      let mod=$c%2
      if [ $mod = "0" ]; then
        let f++
        files[$f]=$file        # Array for formatting the output
        export $pfix$f=$file   # Exporting variable for use.
      fi
      let c++
    done

    IFS=$'\n'              # Now split only by newline for full git status.
    status=`git status`    # Fetch full status

    # Search and replace each line, showing the exported variable name next to files.
    for line in $status; do
      i=1
      while [ $i -le $f ]; do
        search=${files[$i]}
        replace="[\$$pfix$i] ${files[$i]}"
        # (fixes a case when a file contains another file as a substring)
        line=${line/$search /$replace }   # Substitution for files with a space suffix.
        line=${line/%$search/$replace}    # Substitution for files with a newline suffix.
        let i++
      done
      echo $line                        # Print the final transformed line.
    done
  else
    # If there are too many changed files, this 'gst' function will slow down.
    # In this case, fall back to plain 'git status'
    git status
  fi
  # Reset IFS separator to default.
  unset IFS
}


# Permanently remove files/folders from git repository
# ======================================================
# Author: David Underhill
# Script to permanently delete files/folders from your git repository.  To use
# it, cd to your repository's root and then run the script with a list of paths
# you want to delete, e.g., git-delete-history path1 path2

function git-remove-history() {
  # Make sure we're at the root of a git repo
  if [ ! -d .git ]; then
      echo "Error: must run this script from the root of a git repository"
      return
  fi
  # Remove all paths passed as arguments from the history of the repo
  files=$@
  git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch $files" HEAD
  # Remove the temporary history git-filter-branch otherwise leaves behind for a long time
  rm -rf .git/refs/original/ && git reflog expire --all &&  git gc --aggressive --prune
}

# Download stream from grooveshark, sanitize with ffmpeg
# ======================================================
function grooveshark_dl() {
  if [ -n "$1" ] && [ -n "$2" ]; then
    echo "== Downloading .."
    axel $1 -o "/tmp/$2.tmp"
    echo "== Converting .."
    ffmpeg -ab 128000 -i "/tmp/$2.tmp" "$2.mp3"
    rm "/tmp/$2.tmp"
    echo "== Finished!"
  else
    echo "Usage: grooveshark_dl <url> <title (w/o .mp3)>"
  fi
}

# Restart Bamboo and CI Hosts
# ======================================================
function restart_bamboo() {
  # Configure Bamboo and CI Hosts in the following variables.
  bamboo_server="root@integration.crossroadsint.org"
  build_agents=(root@ci-host-001 root@ci-host-002)
  # --------------------------------------------------------
  echo "=== Restarting Bamboo server at: $bamboo_server ..."
  ssh root@integration.crossroadsint.org \
    "/etc/init.d/bamboo restart" && \
  sleep 30 && \
  for agent in ${build_agents[@]}; do
    echo "=== Restarting (& re-registering) build agents at: $agent ..."
    ssh $agent \
      "agent_pid=$(pidof /opt/bamboo-remote-agent/bin/./wrapper); \
       kill -9 $agent_pid; \
       /etc/init.d/bamboo-agent restart"
  done
}

