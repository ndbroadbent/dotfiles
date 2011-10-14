# -------------------------------------------------------
# Git Breeze - Streamline your git workflow.
# Copyright 2011 Nathan Broadbent (http://madebynathan.com). All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
# -------------------------------------------------------

# ------------------------------------------------------------------------------
# Numbered file shortcuts for git commands
# ------------------------------------------------------------------------------


# Detect shell
if [ -n "${ZSH_VERSION:-}" ]; then shell="zsh"; else shell="bash"; fi
# Detect whether zsh 'shwordsplit' option is on by default.
if [[ $shell == "zsh" ]]; then zsh_shwordsplit=$((setopt | grep -q shwordsplit) && echo "true"); fi
# Switch on/off shwordsplit for functions that require it.
zsh_compat(){ if [[ $shell == "zsh" && -z $zsh_shwordsplit ]]; then setopt shwordsplit; fi; }
zsh_reset(){  if [[ $shell == "zsh" && -z $zsh_shwordsplit ]]; then unsetopt shwordsplit; fi; }


# Config
# ------------------------------------------------------------------------------
# - Set your preferred prefix for env variable file shortcuts.
#   (I chose 'e' because it is the easiest key to press after '$'.)
git_env_char="e"
# - Max changes before reverting to 'git status'. git_status_with_shortcuts() may slow down for lots of changes.
gs_max_changes="99"
# - Automatically use 'git rm' to remove deleted files when using the git_add_with_shortcuts() command?
ga_auto_remove="yes"


# Functions
# ------------------------------------------------------------------------------

# 'git status' implementation
# Processes 'git status --porcelain', exporting numbered env variables
# with the paths of each affected file.
# Output is more concise than standard 'git status'.
#
# Call with optional <group> parameter to just show one modification state
# # groups => 1: staged, 2: unmerged, 3: unstaged, 4: untracked
# --------------------------------------------------------------------
git_status_with_shortcuts() {
  zsh_compat # Ensure shwordsplit is on for zsh
  local IFS=$'\n'
  local git_status="$(git status --porcelain 2> /dev/null)"

  local branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`

  if [ -n "$git_status" ] && [[ $(echo "$git_status" | wc -l) -le $gs_max_changes ]]; then
    unset stat_file; unset stat_col; unset stat_msg; unset stat_grp; unset stat_x; unset stat_y
    # Clear numbered env variables.
    for (( i=1; i<=$gs_max_changes; i++ )); do unset $git_env_char$i; done

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
    # Following colors must be prepended with modifiers e.g. '\e[1;', '\e[0;'
    local c_grp_1="33m"; local c_grp_2="31m"; local c_grp_3="32m"; local c_grp_4="36m"

    local f=1; local e=1  # Counters for number of files, and ENV variables

    echo -e "$c_dark#$c_rst On branch: $c_branch$branch$c_rst  $c_dark|  [$c_rst*$c_dark]$c_rst => \$$git_env_char*\n$c_dark#$c_rst"

    for line in $git_status; do
      if [[ $shell == *bash ]]; then
        x=${line:0:1}; y=${line:1:1}; file=${line:3}
      else
        x=$line[1]; y=$line[2]; file=$line[4,-1]
      fi

      # Index modification states
      msg=""
      case "$x$y" in
      "DD") msg="   both deleted"; col="$c_del"; grp="2";;
      "AU") msg="    added by us"; col="$c_new"; grp="2";;
      "UD") msg="deleted by them"; col="$c_del"; grp="2";;
      "UA") msg="  added by them"; col="$c_new"; grp="2";;
      "DU") msg="  deleted by us"; col="$c_del"; grp="2";;
      "AA") msg="     both added"; col="$c_new"; grp="2";;
      "UU") msg="  both modified"; col="$c_mod"; grp="2";;
      "M"?) msg=" modified"; col="$c_mod"; grp="1";;
      "A"?) msg=" new file"; col="$c_new"; grp="1";;
      "D"?) msg="  deleted"; col="$c_del"; grp="1";;
      "R"?) msg="  renamed"; col="$c_ren"; grp="1";;
      "C"?) msg="   copied"; col="$c_cpy"; grp="1";;
      "??") msg="untracked"; col="$c_ign"; grp="4";;
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
  zsh_reset # Reset zsh environment to default
}
# Template function for 'git_status_with_shortcuts'.
_gs_output_file_group() {
  local output=""
  rel_root_path="$(_gs_project_root)"
  abs_root_path="$(readlink -f "$rel_root_path")"

  for i in ${stat_grp[$1]}; do
    # Print colored hashes & files based on modification groups
    local c_group="\e[0;$(eval echo -e \$c_grp_$1)"

    # Deduce relative path based on current working directory
    if [ -z "$rel_root_path" ]; then
      relative="${stat_file[$i]}"
    else
      dest="$abs_root_path/${stat_file[$i]}"
      relative="$(_gs_relative_path "$PWD" "$dest" )"
    fi

    if [[ $f -gt 10 && $e -lt 10 ]]; then local pad=" "; else local pad=""; fi   # (padding)
    echo -e "$c_hash#$c_rst     ${stat_col[$i]}${stat_msg[$i]}:\
$pad$c_dark [$c_rst$e$c_dark] $c_group$relative$c_rst"
    # Export numbered variables in the order they are displayed.
    export $git_env_char$e="$relative"
    let e++
  done
  echo -e "$c_hash#$c_rst"
}


# Show relative path if current directory is not project root
_gs_relative_path(){
  # Credit to 'pini' for the following script.
  # (http://stackoverflow.com/questions/2564634/bash-convert-absolute-path-into-relative-path-given-a-current-directory)
  target=$2; common_part=$1; back=""
  while [[ "${target#$common_part}" == "${target}" ]]; do
    common_part="${common_part%/*}"
    back="../${back}"
  done
  echo "${back}${target#$common_part/}"
}

# Find .git folder
_gs_project_root() {
  local slashes=${PWD//[^\/]/}; local directory="";
  for (( n=${#slashes}; n>0; --n )); do
    test -d "$directory.git" && echo $directory && return 0
    directory=$directory../
  done;
  return 1
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


# Prints a list of all files affected by a given SHA1,
# and exports numbered environment variables for each file.
git_show_affected_files(){
  f=0  # File count
  # Show colored revision and commit message
  echo -n "# "; script -q -c "git show --oneline --name-only $@" /dev/null | sed "s/\r//g" | head -n 1; echo "# "
  for file in $(git show --pretty="format:" --name-only $@ | grep -v '^$'); do
    let f++
    export $git_env_char$f=$file     # Export numbered variable.
    echo -e "#     \e[2;37m[\e[0m$f\e[2;37m]\e[0m $file"
  done; echo "# "
}


# Allows expansion of numbered shortcuts, ranges of shortcuts, or standard paths.
# Numbered shortcut variables are produced by various commands, such as:
# * git_status_with_shortcuts()  - git status implementation
# * git_show_affected_files() - shows files affected by a given SHA1, etc.
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
  echo $files
}
# Execute a command with expanded args, e.g. Delete files 6 to 12: $ ge rm 6..12
ge() { $(git_expand_args "$@"); }

# Shortcuts for resolving merge conflicts.
ours(){   local files=$(git_expand_args "$@"); git checkout --ours $files; git add $files; }
theirs(){ local files=$(git_expand_args "$@"); git checkout --theirs $files; git add $files; }


# Git commit prompts
# ------------------------------------------------------------------------------

# Prompt for commit message, execute git command,
# then add escaped commit command and unescaped message to bash history.
git_commit_prompt() {
  local commit_msg
  if [[ $shell == "zsh" ]]; then
    # zsh 'read' is weak. If you know how to make this better, please send a pull request.
    # (Bash 'read' supports prompt, arrow keys, home/end, up through bash history, etc.)
    echo -n "Commit Message: "; read commit_msg
  else
    read -r -e -p "Commit Message: " commit_msg
  fi

  if [ -n "$commit_msg" ]; then
    eval $@ # run any prequisite commands
    echo $commit_msg | git commit -F - | tail -n +2
  else
    echo -e "\e[0;31mAborting commit due to empty commit message.\e[0m"
  fi
  escaped=$(echo "$commit_msg" | sed -e 's/"/\\"/g' -e 's/!/"'"'"'!'"'"'"/g')

  if [[ $shell == "zsh" ]]; then
    print -s "git commit -m \"${escaped//\\/\\\\}\"" # zsh's print needs double escaping
    print -s "$commit_msg"
  else
    echo "git commit -m \"$escaped\"" >> $HISTFILE
    # Also add unescaped commit message, for git prompt
    echo "$commit_msg" >> $HISTFILE
  fi
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

