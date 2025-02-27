#!/bin/bash
# Custom git alias completions for SCM Breeze

# Make sure git completion is loaded
if [ -f /opt/homebrew/etc/bash_completion.d/git-completion.bash ]; then
  source /opt/homebrew/etc/bash_completion.d/git-completion.bash
fi

# Function to define git completion for aliases
__define_git_completion() {
  local alias_name cmd
  alias_name="$1"
  cmd="$2"

  # Skip if the alias doesn't exist
  type "$alias_name" &>/dev/null || return 0

  # Define the completion function
  eval "
    _git_${alias_name}_shortcut() {
      local cur words cword prev
      _get_comp_words_by_ref -n =: cur words cword prev
      COMP_LINE=\"git ${cmd} \${COMP_LINE/${alias_name} }\"
      (( COMP_POINT+=$((4+${#cmd}-${#alias_name})) ))
      COMP_WORDS=(git ${cmd} \"\${COMP_WORDS[@]:1}\")
      (( COMP_CWORD+=1 ))
      __git_wrap__git_main
    }
  "

  # Apply the completion
  complete -o default -o nospace -F "_git_${alias_name}_shortcut" "$alias_name"
}

# Add completions for common git aliases
# These are the ones that would benefit from branch name completion
__define_git_completion gl log
__define_git_completion gco checkout
__define_git_completion gm merge
__define_git_completion grb rebase
__define_git_completion gcp cherry-pick
__define_git_completion gd diff
__define_git_completion gbl blame
__define_git_completion gsh show
