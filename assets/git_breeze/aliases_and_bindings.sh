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






# Tab completion for git aliases
# -----------------------------------------------------------
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

# Tab completion for git repo management & aliases
# -----------------------------------------------------------
complete -o nospace -o filenames -F _git_repo_tab_completion git_repo
complete -o nospace -o filenames -F _git_repo_tab_completion s

# Keyboard Bindings
# -----------------------------------------------------------
# Ctrl+Space and Ctrl+x+Space give 'git commit' prompts.
# See here for more info about why a prompt is more useful: http://qntm.org/bash#sec1

eval "$(sed -n 's/^\s*/bindkey /; s/: / /p' /etc/inputrc)"


# Bind for both zsh or bash
_bind(){

}


case "$TERM" in
xterm*|rxvt*)
    # Keyboard bindings invoke wrapper functions with a leading space,
    # so they are not added to history. (set HISTCONTROL=ignorespace:ignoredups)

    # CTRL-SPACE => $  git_status_with_shortcuts {ENTER}
    bind "\"\C- \":  \" git_status_with_shortcuts\n\""
    # CTRL-x-SPACE => $  git_commit_all {ENTER}
    bind "\"\C-x \":  \" git_commit_all\n\""
    # CTRL-x-c => $  git_add_and_commit {ENTER}
    # 1 3 CTRL-x-c => $  git_add_and_commit 1 3 {ENTER}
    bind "\"\C-xc\": \"\e[1~ git_add_and_commit \n\""
esac

