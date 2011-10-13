#
# Example aliases & shortcuts for .bashrc or .zshrc
# ------------------------------------------------------------------

# Main 'Git Breeze' functions
alias  gs="git_status_with_shortcuts"
alias  ga="git_add_with_shortcuts"
alias gsf="git_show_affected_files"

# Git commands that deal with paths (with number args expanded)
alias gco="git_checkout_with_expanded_args"
alias  gc="git_commit_with_expanded_args"
alias grs="git_reset_with_expanded_args"
alias grm="git_rm_with_expanded_args"
alias gbl="git_blame_with_expanded_args"
alias  gd="git_diff_with_expanded_args"
alias gdc="git_diff_with_expanded_args --cached"

# Standard commands
alias gcl='git clone'
alias  gf='git fetch'
alias gpl='git pull'
alias gps='git push'
alias gst='git status' # (Default git status)
alias  gr='git remote -v'
alias  gb='git branch'
alias grb='git rebase'
alias  gm='git merge'
alias gcp='git cherry-pick'
alias  gl='git log'
alias gsh='git show'
alias gaa='git add -A'
alias gca='git commit -a'
alias gcm='git commit --amend'
alias gcmh='git commit --amend -C HEAD' # Add staged changes to latest commit without prompting for message


# Git repo management alias
# ------------------------------------------------------------------
alias s="git_repo"   # The 's' stands for 'switch' or 'sourcecode'

