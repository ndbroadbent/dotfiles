#
# Git aliases, shortcuts and functions.
# Written by Nathan D. Broadbent (www.madebynathan.com)


# Config
# --------------------------
# Set your preferred prefix for env variable file shortcuts.
git_env_char="e"
# Max changes before reverting to standard 'git status' (can be very slow otherwise)
gs_max_changes="15"
# Automatically use 'git rm' to remove deleted files.
ga_auto_remove="yes"


# Allows git commands to handle numbered files, ranges of files, or filepaths.
# These numbered shortcuts are produced by various commands, such as:
# * gs()  - git status
# * gsf() - git show affected files
git_expand_args() {
  files=""
  for arg in "$@"; do
    if [[ "$arg" =~ ^[0-9]+$ ]] ; then      # Evaluate $e{*} variables for any integers
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


# Git aliases & shortcuts
# ----------------------------------------------------

alias gcl='git clone'
alias gf='git fetch'
alias gpl='git pull'
alias gps='git push'
alias gr='git remote -v'
alias gb='git branch'
alias grb='git rebase'
alias gm='git merge'
alias gcp='git cherry-pick'
alias gl='git log'
alias gsh='git show'
alias gaa='git add -A'
alias gc='git commit -m'
alias gca='git commit -am'
alias gcm='git commit --amend'
alias gcmh='git commit --amend -C HEAD' # Adds staged changes to latest commit

# Commands dealing with filepaths
function gco() { git checkout $(git_expand_args "$@"); }
function grs() { git reset    $(git_expand_args "$@"); }
function grm() { git rm       $(git_expand_args "$@"); }
function gbl() { git blame    $(git_expand_args "$@"); }
function gd()  { git diff     $(git_expand_args "$@"); }
function gdc() { git diff --cached $(git_expand_args "$@"); }

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
complete -o default -o nospace -F _git_show     gs


# Keyboard bindings
# -----------------------------------------------------------

# Ctrl+Space and Ctrl+x+Space give 'git commit' prompts.
# See here for more info about why a prompt is useful: http://qntm.org/bash#sec1
git_prompt(){ read -e -p "Commit message for '$1': " git_msg; echo $git_msg | $1 -F -; }
case "$TERM" in
xterm*|rxvt*)
    bind "\"\C- \":  \"git_prompt 'git commit -a'\n\""
    bind "\"\C-x \": \"git_prompt 'git commit'\n\""
    ;;
esac


# Git shortcut functions
# ----------------------------------------------------

# Resolving merge conflicts.
ours(){   local files=$(git_expand_args "$@"); git checkout --ours $files; git add $files; }
theirs(){ local files=$(git_expand_args "$@"); git checkout --theirs $files; git add $files; }


# 'git status' wrapper
# Processes git status output, exporting bash variables
# for the filepaths of each modified file.
# To ensure colored output, please run: $ git config --global color.status always
# -----------------------------------------------------------
gs() {
  export IFS=$'\n'
  local status=`git status --porcelain`
  local branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  local c_rst="\e[0m"
  local c_branch="\e[1;37m"

  # If status is blank
  if [ -z "$status" ]; then
    echo -e "# On branch: $c_branch$branch$c_rst\nnothing to commit (working directory clean)"
  else
    if [ $(echo "$status" | wc -l) -lt $gs_max_changes ]; then
      unset stat_file; unset stat_col; unset stat_msg; unset stat_grp; unset stat_x; unset stat_y
      # Colors
      local c_header="\e[0m"
      local c_brk="\e[2;37m"

      local c_grp_1="\e[1;33m"
      local c_grp_2="\e[1;31m"
      local c_grp_3="\e[1;32m"
      local c_grp_4="\e[1;34m"

      local c_del="\e[0;31m"
      local c_mod="\e[0;32m"
      local c_new="\e[0;33m"
      local c_ren="\e[0;34m"
      local c_cpy="\e[0;33m"
      local c_ign="\e[0;36m"

      local f=0  # Counter for number of files
      local e=1  # Counter for ENV variables

      _gs_output_file_group() {
        local output=""
        for i in ${stat_grp[$1]}; do
          output="$output\n"$(echo -e "#      ${stat_col[$i]}${stat_msg[$i]}:%\
$c_brk[$c_rst$e$c_brk] $c_rst${stat_file[$i]}$c_rst")
          # Export numbered variables in the order they are displayed.
          export $git_env_char$e=${stat_file[$i]}
          let e++
        done
        echo -e "$output" | column -t -s "%"
        echo "#"
      }

      echo -e "# On branch: $c_branch$branch$c_rst\n#"

      for line in $status; do
        let f++
        # Filenames
        file=$(echo "$line" | sed "s/^.. //g")
        x=$(echo "$line" | cut -c 1 )
        y=$(echo "$line" | cut -c 2-2 )

        # Store files & statuses in arrays
        stat_file[$f]=$file
        stat_x[$f]=$x
        stat_y[$f]=$y

        # Groups -- 1: staged, 2: unmerged, 3: unstaged, 4: untracked

        # Generate status message
        case "$x" in
        M) msg="modified"; col="$c_mod"; grp="1";;
        R) msg="renamed"; col="$c_ren"; grp="3";;
        C) msg="copied"; col="$c_cpy"; grp="3";;
        A) case "$y" in
           A) msg="both added"; col="$c_new"; grp="2";;
           U) msg="added by us"; col="$c_new"; grp="2";;
           *) msg="new file"; col="$c_new"; grp="1";;
           esac;;
        D) case "$y" in
           D) msg="both deleted"; col="$c_del"; grp="2";;
           U) msg="deleted by us"; col="$c_del"; grp="2";;
           *) msg="deleted"; col="$c_del"; grp="1";;
           esac;;
        U) case "$y" in
           D) msg="deleted by them"; col="$c_del"; grp="2";;
           A) msg="added by them"; col="$c_new"; grp="2";;
           U) msg="both modified"; col="$c_mod"; grp="2";;
          esac;;
        " ") case "$y" in
             M) msg="modified"; col="$c_mod"; grp="3";;
             D) msg="deleted"; col="$c_del"; grp="3";;
             *) msg="not updated"; col="$c_rst"; grp="0";;
             esac;;
        "?") msg="untracked"; col="$c_ign"; grp="4";;
        esac
        stat_msg[$f]=$msg; stat_col[$f]=$col
        # add file to group
        stat_grp[$grp]="${stat_grp[$grp]} $f"
      done

      export IFS=" "
      if [ -n "${stat_grp[1]}" ]; then
        echo -e "# $c_grp_1[$c_header Changes to be committed $c_grp_1]$c_rst\n#"
        _gs_output_file_group 1
      fi
      if [ -n "${stat_grp[2]}" ]; then
        echo -e "# $c_grp_2[$c_header Unmerged paths $c_grp_2]$c_rst\n#"
        _gs_output_file_group 2
      fi
      if [ -n "${stat_grp[3]}" ]; then
        echo -e "# $c_grp_3[$c_header Changes not staged for commit $c_grp_3]$c_rst\n#"
        _gs_output_file_group 3
      fi
      if [ -n "${stat_grp[4]}" ]; then
        echo -e "# $c_grp_4[$c_header Untracked files $c_grp_4]$c_rst\n#"
        _gs_output_file_group 4
      fi

    else
      # If there are too many changed files, this 'gs' function will slow down.
      # In this case, fall back to plain 'git status'
      git status
    fi
  fi
  # Reset IFS separator
  unset IFS
}


# 'git show affected files' function.
# Prints a list of all files affected by a given SHA1,
# and exports numbered environment variables for each file.
# -----------------------------------------------------------
gsf(){
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
# Should be used in conjunction with the gs() function for 'git status'.
# - 'auto git rm' behaviour can be turned off
# -------------------------------------------------------------------------------
ga() {
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
    # Expand args and process resulting set of files.
    for file in $(git_expand_args "$@"); do
      # If 'ga_auto_remove' is enabled and file doesn't exist,
      # use 'git rm' instead of 'git add'.
      if [[ $ga_auto_remove == "yes" ]] && ! [ -e $file ]; then
        git rm $file
      else
        git add $file
        echo "add '$file'"  # similar output to 'git rm'
      fi
    done
    echo
    # It makes sense to run 'gs' after this command.
    gs
  fi
}


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

