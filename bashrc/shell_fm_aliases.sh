# -------------------------------------------------------
# Shell.FM Aliases 
#   - https://github.com/jkramer/shell-fm
#   - http://shell-fm.wikidot.com/hack:control-remote-shell-fm-with-bash-aliases
# -------------------------------------------------------
export SHELLFM_HOST=localhost 
export SHELLFM_PORT=54311

shellfm_cmd() {
  echo "$@" | nc $SHELLFM_HOST $SHELLFM_PORT
}

alias sinf='shellfm_cmd info "%t - %a  (%f)  |  Listening to %s"; echo'
alias slov='shellfm_cmd love'
alias sban='shellfm_cmd ban'
alias sskp='shellfm_cmd skip'