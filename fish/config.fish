if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Remove greeting
set -U fish_greeting

starship init fish | source
rtx activate fish | source
direnv hook fish | source

fish_add_path /opt/homebrew/opt/openjdk/bin

alias reload="exec fish"

# c alias - cd to ~/code, or to ~/code/<arg>
function c
    if test -z "$argv[1]"
        cd ~/code
    else
        cd ~/code/$argv
    end
end
# Autocomplete directories in ~/code
# Don't autocomplete current
complete -c c -x -a "(ls ~/code)"

alias d="cd ~/code/docspring"
alias rm="trash"

function edit_file
    if test -z "$argv[1]"
        code "."
    else
        code $argv
    end
end
alias e="edit_file"
