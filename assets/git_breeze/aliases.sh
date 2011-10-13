#
# Example aliases & shortcuts for .bashrc or .zshrc
# -------------------------------------------------

# 'Git Breeze' functions
alias gs="git_status_with_shortcuts"
alias ga="git_add_with_shortcuts"
alias gsf="git_show_affected_files"

# Expand numbered args for git commands that deal with paths
function gco() { git checkout $(git_expand_args "$@"); }
function gc()  { git commit   $(git_expand_args "$@"); }
function grs() { git reset    $(git_expand_args "$@"); }
function grm() { git rm       $(git_expand_args "$@"); }
function gbl() { git blame    $(git_expand_args "$@"); }
function gd()  { git diff     $(git_expand_args "$@"); }
function gdc() { git diff --cached $(git_expand_args "$@"); }

# Standard commands
alias gcl='git clone'
alias gf='git fetch'
alias gpl='git pull'
alias gps='git push'
alias gst='git status' # (Also see custom status function below: 'git_status_with_shortcuts')
alias gr='git remote -v'
alias gb='git branch'
alias grb='git rebase'
alias gm='git merge'
alias gcp='git cherry-pick'
alias gl='git log'
alias gsh='git show'
alias gaa='git add -A'
alias gca='git commit -a'
alias gcm='git commit --amend'
alias gcmh='git commit --amend -C HEAD' # Adds staged changes to latest commit


# (New alias for Ghostscript, if you use it.)
alias gsc="/usr/bin/env gs"

