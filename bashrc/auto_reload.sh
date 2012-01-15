# Reloads bashrc if anything changes in a monitored directory
auto_reload_bashrc() {
  local recent_change="$(bashrc_last_modified)"
  if [ "$BASHRC_LAST_UPDATED" != "$recent_change" ]; then
    export BASHRC_LAST_UPDATED="$recent_change"
    source $HOME/.bashrc
  fi
}

bashrc_last_modified() {
  find "$DOTFILES_PATH/bashrc" -type f -printf '%T@ %p\n' | sort -n | tail -1
}

PROMPT_COMMAND="auto_reload_bashrc; $PROMPT_COMMAND"