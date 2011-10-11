#
# Git aliases, shortcuts and functions.
# Written by Nathan D. Broadbent (www.madebynathan.com)


# Config
# --------------------------
# - Set your preferred prefix for env variable file shortcuts.
#   (I chose 'e' because it is the easiest key to press after '$'.)
git_env_char="e"
# - Max changes before reverting to 'git status'. git_status_with_shortcuts() might be slow for thousands of changes.
gs_max_changes="99"
# - Automatically use 'git rm' to remove deleted files using the ga() command?
ga_auto_remove="yes"


# This function allows git commands to handle numbered files, ranges of files, or filepaths.
# These numbered shortcuts are produced by various commands, such as:
# * git_status_with_shortcuts()  - git status implementation
# * git_show_changed_files() - shows files affected by a given SHA1, etc.
git_expand_args() {
  files=""
  for arg in "$@"; do
    if [[ "$arg" =~ ^[0-9]+$ ]] ; then      # Use $e{*} variables for any integers
      files="$files $(eval echo \$$git_env_char$arg)"
    elif [[ $arg == *..* ]]; then           # Expand ranges into $e{*} variables
      for i in $(seq $(echo $arg | tr ".." " ")); do
        files="$files $(eval echo \$$git_env_char$i)"
      done
    else                                    # Otherwise, treat $arg as a normal file.
      files="$files $arg"
    fi
  done
  echo "$files"
}
# Execute a command with expanded args.
# e.g. Remove files 6 through 15: $ ge rm 6..15
ge() { $(git_expand_args "$@"); }

# Git aliases & shortcuts
# ----------------------------------------------------

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
alias gsf="git_show_changed_files"

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


# Git shortcut functions
# ----------------------------------------------------

# Resolving merge conflicts.
ours(){   local files=$(git_expand_args "$@"); git checkout --ours $files; git add $files; }
theirs(){ local files=$(git_expand_args "$@"); git checkout --theirs $files; git add $files; }

# 'git status' implementation
# Processes 'git status --porcelain', exporting numbered env variables
# with the paths of each affected file.
# Output is more concise than standard 'git status'.
#
# Call with optional <group> parameter to only show one modification state
# # groups => 1: staged, 2: unmerged, 3: unstaged, 4: untracked
# --------------------------------------------------------------------
git_status_with_shortcuts() {
  local IFS=$'\n'
  local status=`git status --porcelain 2> /dev/null`
  local branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  # Clear numbered env variables.
  for (( i=1; i<=$gs_max_changes; i++ )); do unset $git_env_char$i; done

  if [ -n "$status" ] && [[ $(echo "$status" | wc -l) -lt $gs_max_changes ]]; then
    unset stat_file; unset stat_col; unset stat_msg; unset stat_grp; unset stat_x; unset stat_y

    # Colors
    local c_rst="\e[0m"
    local c_branch="\e[1m"
    local c_header="\e[0m"
    local c_dark="\e[2;37m"
    local c_del="\e[0;31m"
    local c_mod="\e[0;32m"
    local c_new="\e[0;33m"
    local c_ren="\e[0;34m"
    local c_cpy="\e[0;33m"
    local c_ign="\e[0;36m"
    # Colors must be prepended with modifiers e.g. '\e[1;', '\e[0;'
    local c_grp_1="33m"; local c_grp_2="31m"; local c_grp_3="32m"; local c_grp_4="36m"

    local f=1; local e=1  # Counters for number of files, and ENV variables

    echo -e "$c_dark#$c_rst On branch: $c_branch$branch$c_rst  $c_dark|  $c_dark[$c_rst*$c_dark]$c_rst => \$$git_env_char*\n$c_dark#$c_rst"

    for line in $status; do
      x=${line:0:1}
      y=${line:1:1}
      file=${line:3}
      # Index modification states
      msg=""
      case "$x$y" in
      "M"?) msg=" modified"; col="$c_mod"; grp="1";;
      "A"?) msg=" new file"; col="$c_new"; grp="1";;
      "D"?) msg="  deleted"; col="$c_del"; grp="1";;
      "R"?) msg="  renamed"; col="$c_ren"; grp="1";;
      "C"?) msg="   copied"; col="$c_cpy"; grp="1";;
      "??") msg="untracked"; col="$c_ign"; grp="4";;
      # Merge conflicts
      "DD") msg="   both deleted"; col="$c_del"; grp="2";;
      "AU") msg="    added by us"; col="$c_new"; grp="2";;
      "UD") msg="deleted by them"; col="$c_del"; grp="2";;
      "UA") msg="  added by them"; col="$c_new"; grp="2";;
      "DU") msg="  deleted by us"; col="$c_del"; grp="2";;
      "AA") msg="     both added"; col="$c_new"; grp="2";;
      "UU") msg="  both modified"; col="$c_mod"; grp="2";;
      esac
      if [ -n "$msg" ]; then
        # Store data at array index and add to group
        stat_file[$f]=$file; stat_msg[$f]=$msg; stat_col[$f]=$col
        stat_grp[$grp]="${stat_grp[$grp]} $f"
        let f++
      fi

      # Work tree modification states
      msg=""
      if [[ "$y" == "M" ]]; then msg=" modified"; col="$c_mod"; grp="3"; fi
      # Don't show {Y} as deleted during a merge conflict.
      if [[ "$y" == "D" && "$x" != "D" && "$x" != "U" ]]; then msg="  deleted"; col="$c_del"; grp="3"; fi
      if [ -n "$msg" ]; then
        stat_file[$f]=$file; stat_msg[$f]=$msg; stat_col[$f]=$col
        stat_grp[$grp]="${stat_grp[$grp]} $f"
        let f++
      fi
    done

    IFS=" "
    grp_num=1
    for heading in 'Changes to be committed' 'Unmerged paths' 'Changes not staged for commit' 'Untracked files'; do
      # If no group specified as param, or specified group is current group
      if [ -z "$1" ] || [[ "$1" == "$grp_num" ]]; then
        local c_arrow="\e[1;$(eval echo \$c_grp_$grp_num)"
        local c_hash="\e[0;$(eval echo \$c_grp_$grp_num)"
        if [ -n "${stat_grp[$grp_num]}" ]; then
          echo -e "$c_arrow➤$c_header $heading\n$c_hash#$c_rst"
          _gs_output_file_group $grp_num
        fi
      fi
      let grp_num++
    done
  else
    # This function will slow down if there are too many changed files,
    # so just use plain 'git status'
    git status
  fi
}
# Template function for 'git_status_with_shortcuts'.
_gs_output_file_group() {
  local output=""
  for i in ${stat_grp[$1]}; do
    # Print colored hashes & files based on modification groups
    local c_group="\e[0;$(eval echo -e \$c_grp_$1)"
    if [[ $f -gt 10 && $e -lt 10 ]]; then local pad=" "; else local pad=""; fi   # (padding)
    echo -e "$c_hash#$c_rst     ${stat_col[$i]}${stat_msg[$i]}: \
$pad$c_dark[$c_rst$e$c_dark] $c_group${stat_file[$i]}$c_rst"
    # Export numbered variables in the order they are displayed.
    export $git_env_char$e="${stat_file[$i]}"
    let e++
  done
  echo -e "$c_hash#$c_rst"
}



# 'git show affected files' function.
# Prints a list of all files affected by a given SHA1,
# and exports numbered environment variables for each file.
# -----------------------------------------------------------
git_show_changed_files(){
  f=0  # File count
  # Show colored revision and commit message
  echo -n "# "; script -q -c "git show --oneline --name-only $@" /dev/null | sed "s/\r//g" | head -n 1; echo "# "
  for file in $(git show --pretty="format:" --name-only $@ | grep -v '^$'); do
    let f++
    export $git_env_char$f=$file     # Export numbered variable.
    echo -e "#     \e[2;37m[\e[0m$f\e[2;37m]\e[0m $file"
  done; echo "# "
}


# 'git add' & 'git rm' wrapper
# This shortcut means 'stage the change to the file'
# i.e. It will add new and changed files, and remove deleted files.
# Should be used in conjunction with the git_status_with_shortcuts() function for 'git status'.
# - 'auto git rm' behaviour can be turned off
# -------------------------------------------------------------------------------
git_add_with_shortcuts() {
  if [ -z "$1" ]; then
    echo "Usage: ga <file>  => git add <file>"
    echo "       ga 1       => git add \$e1"
    echo "       ga 2..4    => git add \$e2 \$e3 \$e4"
    echo "       ga 2 5..7  => git add \$e2 \$e5 \$e6 \$e7"
    if [[ $ga_auto_remove == "yes" ]]; then
      echo -e "\nNote: Deleted files will also be staged using this shortcut."
      echo "      To turn off this behaviour, change the 'auto_remove' option."
    fi
  else
    git_silent_add_with_shortcuts "$@"
    # Makes sense to run 'git status' after this command.
    git_status_with_shortcuts
  fi
}
# Does nothing if no args are given.
git_silent_add_with_shortcuts() {
  if [ -n "$1" ]; then
    # Expand args and process resulting set of files.
    for file in $(git_expand_args "$@"); do
      # Use 'git rm' if file doesn't exist and 'ga_auto_remove' is enabled.
      if [[ $ga_auto_remove == "yes" ]] && ! [ -e $file ]; then
        echo -n "# "
        git rm $file
      else
        git add $file
        echo -e "# add '$file'"
      fi
    done
    echo "#"
  fi
}

# Prompt for commit message, execute git command,
# then add escaped commit command and unescaped message to bash history.
git_commit_prompt() {
  local commit_msg
  read -r -e -d $'\n' -p "Commit Message: " commit_msg
  if [ -n "$commit_msg" ]; then
    $@ # run any prequisite commands
    echo $commit_msg | git commit -F - | tail -n 1
  else
    echo -e "\e[0;31mAborting commit due to empty commit message.\e[0m"
  fi
  escaped=$(echo "$commit_msg" | sed -e 's/"/\\"/g' -e 's/!/"'"'"'!'"'"'"/g')
  echo "git commit -m \"$escaped\"" >> $HISTFILE
  # Also add unescaped commit message, for git prompt
  echo "$commit_msg" >> $HISTFILE
}

# Prompt for commit message, then commit all modified and untracked files
git_commit_all() {
  changes=$(git status --porcelain | wc -l)
  if [ "$changes" -gt 0 ]; then
    echo -e "\e[0;33mCommitting all files (\e[0;31m$changes\e[0;33m)\e[0m"
    git_commit_prompt "git add -A"
  else
    echo "# No changed files to commit."
  fi
}

# Add paths or expanded args (if any given), then commit staged changes
git_add_and_commit() {
  git_silent_add_with_shortcuts "$@"
  changes=$(git diff --cached --numstat | wc -l)
  if [ "$changes" -gt 0 ]; then
    git_status_with_shortcuts 1  # only show staged changes
    git_commit_prompt
  else
    echo "# No staged changes to commit."
  fi
}


# Keyboard Bindings
# -----------------------------------------------------------
# Ctrl+Space and Ctrl+x+Space give 'git commit' prompts.
# See here for more info about why a prompt is more useful: http://qntm.org/bash#sec1

case "$TERM" in
xterm*|rxvt*)
    # Keyboard bindings invoke wrapper functions with a leading space,
    # so they are not added to history. (set HISTCONTROL=ignorespace:ignoredups)

    # CTRL-SPACE => $  git_status_with_shortcuts {ENTER}
    bind "\"\C- \":  \" git_status_with_shortcuts\n\""
    # CTRL-x-SPACE => $  git_add_and_commit {ENTER}
    # 1 3 CTRL-x-SPACE => $  git_add_and_commit 1 3 {ENTER}
    bind "\"\C-x \": \"\e[1~ git_add_and_commit \n\""
    # CTRL-x-c => $  git_commit_all {ENTER}
    bind "\"\C-xc\":  \" git_commit_all\n\""
esac


# Git utility functions
# ----------------------------------------------------

# Permanently remove all traces of files/folders from git repository.
# To use it, cd to your repository's root and then run the function
# with a list of paths you want to delete. e.g. git_remove_history path1 path2
# Original Author: David Underhill
git_remove_history() {
  # Make sure we're at the root of a git repo
  if [ ! -d .git ]; then
      echo "Error: must run this script from the root of a git repository"
      return
  fi
  # Remove all paths passed as arguments from the history of the repo
  files=$@
  git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch $files" HEAD
  # Remove the temporary history git-filter-branch otherwise leaves behind for a long time
  rm -rf .git/refs/original/ && git reflog expire --all &&  git gc --aggressive --prune
}

