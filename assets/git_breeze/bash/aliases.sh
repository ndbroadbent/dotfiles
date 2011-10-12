# Git aliases & shortcuts for .bashrc
# -----------------------------------

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

# Commands that deal with paths
function gco() { git checkout $(git_expand_args "$@"); }
function gc()  { git commit   $(git_expand_args "$@"); }
function grs() { git reset    $(git_expand_args "$@"); }
function grm() { git rm       $(git_expand_args "$@"); }
function gbl() { git blame    $(git_expand_args "$@"); }
function gd()  { git diff     $(git_expand_args "$@"); }
function gdc() { git diff --cached $(git_expand_args "$@"); }

# Aliases for custom commands below
alias gs="git_status_with_shortcuts"
alias gsc="/usr/bin/env gs" # (New alias for Ghostscript, if you use it.)
alias ga="git_add_with_shortcuts"
alias gsf="git_show_affected_files"

# Tab completion for git aliases
complete -o default -o nospace -F _git_pull     gpl
complete -o default -o nospace -F _git_push     gps
complete -o default -o nospace -F _git_fetch    gf
complete -o default -o nospace -F _git_branch   gb
complete -o default -o nospace -F _git_rebase   grb
complete -o default -o nospace -F _git_merge    gm
complete -o default -o nospace -F _git_log      gl
complete -o default -o nospace -F _git_checkout gco
complete -o default -o nospace -F _git_remote   gr
complete -o default -o nospace -F _git_show     gsh

