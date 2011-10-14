#
# Example aliases & shortcuts for .bashrc or .zshrc
# ------------------------------------------------------------------

git_alias="g"

# 'Git Breeze' functions
git_status_shortcuts_alias="gs"
git_add_shortcuts_alias="ga"
git_show_files_alias="gsf"
# Commands that handle paths (with shortcut args expanded)
git_checkout_alias="gco"
git_commit_alias="gc"
git_reset_alias="grs"
git_rm_alias="grm"
git_blame_alias="gbl"
git_diff_alias="gd"
git_diff_cached_alias="gdc"
# Standard commands
git_clone_alias="gcl"
git_fetch_alias="gf"
git_fetch_and_rebase_alias="gfr"
git_pull_alias="gpl"
git_push_alias="gps"
git_status_original_alias="gst"
git_status_short_alias="gss"
git_add_all_alias="gaa"
git_commit_all_alias="gca"
git_commit_amend_alias="gcm"
git_commit_amend_no_msg_alias="gcmh"
git_remote_alias="gr"
git_branch_alias="gb"
git_branch_all_alias="gba"
git_rebase_alias="grb"
git_merge_alias="gm"
git_cherry_pick_alias="gcp"
git_log_alias="gl"
git_log_stat_alias="gls"
git_log_graph_alias="glg"
git_show_alias="gsh"

# Git repo management
git_repo_alias="s"


# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------


# 'Git Breeze' functions
alias $git_status_shortcuts_alias="git_status_with_shortcuts"
alias $git_add_shortcuts_alias="git_add_with_shortcuts"
alias $git_show_files_alias="git_show_affected_files"

# Git commands that deal with paths (with number args expanded)
alias $git_checkout_alias="git checkout $(git_expand_args "$@")"
alias $git_commit_alias="git commit     $(git_expand_args "$@")"
alias $git_reset_alias="git reset       $(git_expand_args "$@")"
alias $git_rm_alias="git rm             $(git_expand_args "$@")"
alias $git_blame_alias="git blame       $(git_expand_args "$@")"
alias $git_diff_alias="git diff         $(git_expand_args "$@")"
alias $git_diff_cached_alias="git diff --cached $(git_expand_args "$@") "

# Standard commands
alias $git_clone_alias='git clone'
alias $git_fetch_alias='git fetch'
alias $git_fetch_and_rebase_alias='git fetch && git rebase'
alias $git_pull_alias='git pull'
alias $git_push_alias='git push'
alias $git_status_original_alias='git status' # (Standard git status)
alias $git_status_short_alias='git status -s'
alias $git_remote_alias='git remote -v'
alias $git_branch_alias='git branch'
alias $git_branch_all_alias='git branch -a'
alias $git_rebase_alias='git rebase'
alias $git_merge_alias='git merge'
alias $git_cherry_pick_alias='git cherry-pick'
alias $git_log_alias='git log'
alias $git_log_stat_alias='git log --stat --max-count=5'
alias $git_log_graph_alias='git log --graph --max-count=5'
alias $git_show_alias='git show'
alias $git_add_all_alias='git add -A'
alias $git_commit_all_alias='git commit -a'
alias $git_commit_amend_alias='git commit --amend'
# Add staged changes to latest commit without prompting for message
alias $git_commit_amend_no_msg_alias='git commit --amend -C HEAD'

# Git repo management alias
alias $git_repo_alias="git_repo"   # The 's' stands for 'switch' or 'sourcecode'


# Tab completion for aliases
if [ -n "${ZSH_VERSION:-}" ]; then
  # Turn on support for bash completion
  autoload bashcompinit
  bashcompinit

  # -- zsh
  compdef $git_alias=git
  compdef _git $git_pull_alias=git-pull
  compdef _git $git_push_alias=git-push
  compdef _git $git_fetch_alias=git-fetch
  compdef _git $git_fetch_and_rebase_alias=git-fetch
  compdef _git $git_diff_alias=git-diff
  compdef _git $git_commit_alias=git-commit
  compdef _git $git_commit_all_alias=git-commit
  compdef _git $git_checkout_alias=git-checkout
  compdef _git $git_branch_alias=git-branch
  compdef _git $git_branch_all_alias=git-branch
  compdef _git $git_log_alias=git-log
  compdef _git $git_log_stat_alias=git-log
  compdef _git $git_log_graph_alias=git-log
  compdef _git $git_add_shortcuts_alias=git-add
  compdef _git $git_merge_alias=git-merge
else
  # -- bash
  complete -o default -o nospace -F _git          $git_alias
  complete -o default -o nospace -F _git_pull     $git_pull_alias
  complete -o default -o nospace -F _git_push     $git_push_alias
  complete -o default -o nospace -F _git_fetch    $git_fetch_alias
  complete -o default -o nospace -F _git_branch   $git_branch_alias
  complete -o default -o nospace -F _git_rebase   $git_rebase_alias
  complete -o default -o nospace -F _git_merge    $git_merge_alias
  complete -o default -o nospace -F _git_log      $git_log_alias
  complete -o default -o nospace -F _git_diff     $git_diff_alias
  complete -o default -o nospace -F _git_checkout $git_checkout_alias
  complete -o default -o nospace -F _git_remote   $git_remote_alias
  complete -o default -o nospace -F _git_show     $git_show_alias
fi

# Git repo management & aliases.
# If you know how to rewrite _git_repo_tab_completion() for zsh, please send me a pull request!
complete -o nospace -o filenames -F _git_repo_tab_completion git_repo
complete -o nospace -o filenames -F _git_repo_tab_completion $git_repo_alias


# Keyboard Bindings
# -----------------------------------------------------------
# Default: Ctrl+Space and Ctrl+x+Space give 'git commit' prompts.
# See [here](http://qntm.org/bash#sec1) to find out why a prompt can be useful.

# Cross-shell key bindings
_bind(){
  if [ -n "${ZSH_VERSION:-}" ]; then
    bindkey -s "$1" "$2"   # zsh
  else
    bind "\"$1\": \"$2\""  # bash
  fi
}

case "$TERM" in
xterm*|rxvt*)
    # CTRL-SPACE => $  git_status_with_shortcuts {ENTER}
    _bind "\C- " " git_status_with_shortcuts\n"
    # CTRL-x-SPACE => $  git_commit_all {ENTER}
    _bind "\C-x " " git_commit_all\n"
    # CTRL-x-c => $  git_add_and_commit {ENTER}
    # 1 3 CTRL-x-c => $  git_add_and_commit 1 3 {ENTER}
    _bind "\C-xc" "\e[1~ git_add_and_commit \n"

    # Commands are prepended with a space so that they won't be added to history.
    # Make sure this is turned on with:
    # zsh:  setopt histignorespace histignoredups
    # bash: HISTCONTROL=ignorespace:ignoredups
esac

