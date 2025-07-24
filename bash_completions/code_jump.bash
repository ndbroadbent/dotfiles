#!/bin/bash
# Bash completion for code_jump/c command

_code_jump_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local dirs=$(ls -1 ~/code 2>/dev/null)
    COMPREPLY=($(compgen -W "$dirs" -- "$cur"))
}

complete -F _code_jump_complete code_jump
complete -F _code_jump_complete c