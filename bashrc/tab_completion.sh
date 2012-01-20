#
# SSH Tab Completion
#    The default ssh tab completion in (X)ubuntu is a bit broken.
#    This is a better version - Combines hosts from ~/.ssh/{config,known_hosts}
_ssh() {
  local curw
  COMPREPLY=()
  curw=${COMP_WORDS[COMP_CWORD]}

  local known_hosts=$(cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\[")
  local config=$(grep ^Host ~/.ssh/config |sed -e 's/Host //g'| grep -v "*")
  COMPREPLY=($(compgen -W '$(echo "$known_hosts $config")' -- $curw))
}

complete -F _ssh ssh
