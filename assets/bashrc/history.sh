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
  HISTFILESIZE=$HISTFILESIZE   #[2]
  builtin history -c         #[3]
  builtin history -r         #[4]
}

export PROMPT_COMMAND+='_bash_history_sync;'

