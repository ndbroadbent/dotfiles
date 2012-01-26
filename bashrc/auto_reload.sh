# Reloads bashrc if any sourced files are changed
# ------------------------------------------------

auto_reload_bashrc() {
  local recent_change="$(bashrc_last_modified)"
  if [ "$BASHRC_LAST_UPDATED" != "$recent_change" ]; then
    export BASHRC_LAST_UPDATED="$recent_change"
    source $HOME/.bashrc
  fi
}

bashrc_last_modified() {
  find $SOURCED_FILES -type f -printf '%T@ %p\n' | sort -n | tail -1
}

# Run this function at the end of your bashrc.
finalize_auto_reload() {
  # Sort and clear duplicates from SOURCED_FILES
  SOURCED_FILES=`echo \$SOURCED_FILES | tr " " "\n" | sort | uniq | tr "\n" " "`
  # Turn off 'source' recording
  unset -f source
  unalias .
}

# Records the list of files sourced from $HOME directory
source() {
  for f in $@; do [[ "$f" =~ "$HOME" ]] && SOURCED_FILES+=" $f"; done
  builtin source $@
}
alias .="source"
export SOURCED_FILES="$HOME/.bashrc $DOTFILES_PATH/bashrc/auto_reload.sh"


PROMPT_COMMAND="auto_reload_bashrc;$PROMPT_COMMAND"
