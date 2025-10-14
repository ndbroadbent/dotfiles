#!/bin/bash
# -------------------------------------------------------
# Aliases, functions & key bindings
# -------------------------------------------------------

# Substitute user/group with user symbol, if defined at ~/.user_sym
# Before : -rw-rw-r-- 1 ndbroadbent ndbroadbent 1.1K Sep 19 21:39 scm_breeze.sh
# After  : -rw-rw-r-- 1 𝐍  𝐍  1.1K Sep 19 21:39 scm_breeze.sh
# if [ -e $HOME/.user_sym ]; then
#   _ll_processor=" | sed \"s/ $USER/ \$(/bin/cat $HOME/.user_sym)/g\" | rejustify_ls_columns"
# fi

LS_CMD=$(which gls > /dev/null 2>&1 && echo "gls" || echo "ls")

alias l="\$LS_CMD -Cv --color=auto --group-directories-first"
alias ll="\$LS_CMD -lhv --color=auto --group-directories-first"
alias la="\$LS_CMD -lhvA --color=auto --group-directories-first"

alias rmrf='rm -rf'
alias ldu='du -cks * | sort -rn | head -15' # Lists the size of all the folders

alias s='sudo'
alias ss='ssh'
alias ss2='ssh -p2202'
alias le="less"
alias psg='ps aux | grep'
alias sbrc="source ~/.bashrc"

# Task wrapper function (functions work better with tab completion than aliases)
t() { command task "$@"; }
complete -F _task t

alias grd="~/code/git-remove-debug/git-remove-debug"

which ack-grep > /dev/null 2>&1 || alias ack-grep="ack"
[ -n "$(which greadlink)" ] && alias readlink="greadlink"

alias aga='ag -a'
alias agi='ag -i'

alias agr='ag --type=ruby'
alias agri='ag -i --type=ruby'

alias fl='fastlane'

alias rn='renamify'

alias ed='c envkey-client-server; ds'

alias python="python3"
alias py="python3"
alias pip="pip3"

alias gfp="git fetch --prune && git-clean-branches"
# cspell:disable-next-line
alias gmain="git checkout main && git pull --prune && git-clean-branches"

# This is a stupid idea. if you want bat, type bat.
# alias cat='bat'

function claude_with_env_vars(){
  export DISABLE_SPRING=1 HIDE_BROWSER=1
  claude --dangerously-skip-permissions "$@"
}
function codex_with_env_vars(){
  export DISABLE_SPRING=1 HIDE_BROWSER=1
  codex --dangerously-bypass-approvals-and-sandbox "$@"
}

alias cl="claude"
alias cls="claude_with_env_vars"
alias clsr="claude_with_env_vars --resume"
alias clsc="claude_with_env_vars --continue"
alias cdx="codex_with_env_vars"

if [ "$(uname)" = Darwin ]; then
  alias beep="(afplay /System/Library/Sounds/Glass.aiff > /dev/null 2>&1 &)"
  alias alert="(afplay \$DOTFILES_PATH/sounds/alert.mp3 > /dev/null 2>&1 &)"
  alias bark="(afplay \$DOTFILES_PATH/sounds/bark.aiff > /dev/null 2>&1 &)"
  alias bork="bark"
else
  alias beep="(mplayer /usr/share/sounds/gnome/default/alerts/glass.ogg > /dev/null 2>&1 &)"
  alias alert="(mplayer \$DOTFILES_PATH/sounds/alert.mp3 > /dev/null 2>&1 &)"
  alias bark="(mplayer \$DOTFILES_PATH/sounds/bark.aiff > /dev/null 2>&1 &)"
  alias bork="bark"
fi

# https://stackoverflow.com/a/42429180/304706
run_command() {
  local cmd_str='' arg arg_q
  for arg; do
    if [[ $arg = "|" ]]; then
      cmd_str+=" | "
    else
      printf -v arg_q '%q' "$arg"
      cmd_str+=" $arg_q"
    fi
  done
  eval "$cmd_str"
}

function n() {
  local ALERT="Alert from Bash"
  local EXIT_CODE=0
  if [ -n "$1" ]; then
    run_command "$@"
    EXIT_CODE=$?
    ALERT="$*"
  fi
  if [ "$EXIT_CODE" -eq 0 ]; then
    alert
  else
    bark
  fi
  (osascript -e "display notification \"$ALERT\" with title \"Command Finished ($EXIT_CODE)\"" &)
  return "$EXIT_CODE"
}

function notify() {
  (alert &)
  MESSAGE="$*"
  if [ -n "$TITLE" ];
  then
    (osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\"" &)
  else
    (osascript -e "display notification \"$MESSAGE\"" &)
  fi
}

# Edit file function - if SCM Breeze is installed, expand numeric arguments
function edit_file() {
  # Workaround for Secure Keyboard Entry blocking window focus on macOS
  if [ "$GUI_EDITOR" = "cursor" ] && [ "$(uname)" = "Darwin" ]; then
    # Check if Secure Keyboard Entry is enabled (has checkmark)
    SKE_STATE=$(osascript -e 'tell application "System Events" to tell process "iTerm2" to get value of attribute "AXMenuItemMarkChar" of menu item "Secure Keyboard Entry" of menu 1 of menu bar item "iTerm2" of menu bar 1' 2>/dev/null)

    if [ "$SKE_STATE" = "✓" ]; then
      # Toggle OFF if it's currently enabled
      osascript -e 'tell application "System Events" to tell process "iTerm2" to click menu item "Secure Keyboard Entry" of menu 1 of menu bar item "iTerm2" of menu bar 1' >/dev/null 2>&1
      SKE_WAS_ENABLED=true
    else
      SKE_WAS_ENABLED=false
    fi
  fi

  if type exec_scmb_expand_args > /dev/null 2>&1; then
    if [ -z "$1" ]; then
      # No arguments supplied, open the editor at the current directory.
      # shellcheck disable=SC2086
      exec_scmb_expand_args $GUI_EDITOR "."
    else
      # shellcheck disable=SC2086
      exec_scmb_expand_args $GUI_EDITOR "$@"
    fi
  else
    $GUI_EDITOR "$@"
  fi

  # Toggle Secure Keyboard Entry back ON if it was enabled before
  if [ "$GUI_EDITOR" = "cursor" ] && [ "$(uname)" = "Darwin" ] && [ "$SKE_WAS_ENABLED" = "true" ]; then
    # Give Cursor time to open and come to foreground
    sleep 1
    osascript -e 'tell application "System Events" to tell process "iTerm2" to click menu item "Secure Keyboard Entry" of menu 1 of menu bar item "iTerm2" of menu bar 1' >/dev/null 2>&1
  fi
}
alias e="edit_file"

alias ~='\cd ~'
# alias -- -='\cd -'
alias ..='\cd ..'
alias ...='\cd ../..'
alias ....='\cd ../../..'
alias .....='\cd ../../../..'
alias ......='\cd ../../../../..'

for mod in x w r; do
  alias "+$mod"="chmod +$mod"
  # alias -- "-$mod"="chmod -$mod"
done

# Git diff with inline images
alias gdi="git --no-pager -c diff.image.textconv=imgcat -c diff.image.command=imgdiff diff"
alias gf="git fetch --prune"

# Aliases for scripts in ~/bin
# ----------------------------
alias cb="simple_clipboard"
# Copy contents of a file
alias cbf="simple_clipboard <"
# Copy SSH public key
cbs() {
  if [ -f ~/.ssh/id_rsa.pub ]; then
    echo 'Copying ~/.ssh/id_rsa.pub to clipboard...'
    simple_clipboard < ~/.ssh/id_rsa.pub
  else
    echo 'Fetching SSH key from 1Password...'
    op item get "ssh-key" --fields label=public_key | simple_clipboard
  fi
}
# Copy current working directory
alias cbd="pwd | simple_clipboard"
# Copy current git SHA-1
alias cbg="echo 'Copying latest commit hash to clipboard...' && git rev-parse --verify HEAD | simple_clipboard"

# Apt
# -------------------------------------------------
alias apt-i='sudo apt-get install -y'
alias apt-u='sudo apt-get update'
alias apt-s='apt-cache search'
apt-sd() { apt-cache search "$1" | grep "lib.*dev "; } # Search for dev files
alias apt-r='sudo apt-get remove'
alias apt-a='sudo apt-get autoremove'

# Mac
# ---------------
alias flushdns='dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

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
    path=$(dirname "$2"/.)   # Fetches absolute path.
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
    unalias "$1"
    source ~/.bashrc
  else
    echo "Usage: rm_alias <alias>"
  fi
}
