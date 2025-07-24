#!/bin/bash
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

# Bun completion
if [ -f "$DOTFILES_PATH/bash_completions/bun.bash" ]; then
  source "$DOTFILES_PATH/bash_completions/bun.bash"
fi

# Code jump completion
if [ -f "$DOTFILES_PATH/bash_completions/code_jump.bash" ]; then
  source "$DOTFILES_PATH/bash_completions/code_jump.bash"
fi