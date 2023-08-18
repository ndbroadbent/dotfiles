if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Remove greeting
set -U fish_greeting

fish_add_path --path /opt/homebrew/bin
fish_add_path --path /opt/homebrew/opt/openjdk/bin
fish_add_path --path /Applications/Postgres.app/Contents/Versions/15/bin/
fish_add_path --path -p ./bin

starship init fish | source
rtx activate fish | source
direnv hook fish | source

abbr -a reload "exec fish"
abbr -a config "code ~/code/dotfiles"
abbr -a conf "code ~/code/dotfiles"

alias python="python3"
alias py="python3"
alias pip="pip3"

alias rb="ruby"

# c alias - cd to ~/code, or to ~/code/<arg>
function c
    if test (count $argv) -eq 0
        cd ~/code
    else
        cd ~/code/$argv
    end
end
# Autocomplete directories in ~/code
# Don't autocomplete current
complete -c c -x -a "(ls ~/code)"

# abbr -a rm trash
# abbr -a rmrf "rm -rf"
abbr -a +x "chmod +x"

function edit_file
    if test (count $argv) -eq 0
        code .
    else
        code $argv
    end
end
alias e="edit_file"
abbr -a cx convox
abbr -a b bundle
abbr -a bu "bundle update"

alias ds='osascript .dev.scpt "$PWD"'
abbr -a dds 'cd ~/code/docspring && ds'
abbr -a d "cd ~/code/docspring"
abbr -a da 'direnv allow'
abbr -a dev 'cd ~/code/docspring && rtx exec ruby node -- ./scripts/dev_iterm'
abbr -a tmk "tmux kill-session"
