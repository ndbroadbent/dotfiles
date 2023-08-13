if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Remove greeting
set -U fish_greeting

starship init fish | source
rtx activate fish | source
direnv hook fish | source

fish_add_path /opt/homebrew/opt/openjdk/bin

abbr -a reload "exec fish"
abbr -a config "code ~/code/dotfiles"
abbr -a conf "code ~/code/dotfiles"

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

abbr -a d "cd ~/code/docspring"
abbr -a rm trash
abbr -a rmrf "rm -rf"

function edit_file
    if test -z "$argv[1]"
        code "."
    else
        code $argv
    end
end
alias e="edit_file"
alias cx="convox"
