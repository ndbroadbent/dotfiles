# Aliases for scripts in ~/bin
# ----------------------------
alias cb="simple_clipboard"
# Copy contents of a file
alias cbf="simple_clipboard <"
# Copy SSH public key
alias cbs="echo 'Copying ~/.ssh/id_rsa.pub to clipboard...' && simple_clipboard < ~/.ssh/id_rsa.pub"
# Copy current working directory
alias cbd="pwd | simple_clipboard"
# Copy current git SHA-1
alias cbg="echo 'Copying latest commit hash to clipboard...' && git rev-parse --verify HEAD | simple_clipboard"
