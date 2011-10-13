# -------------------------------------------------------
# Git Breeze - Streamline your git workflow.
# Copyright 2011 Nathan Broadbent (http://madebynathan.com). All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
# -------------------------------------------------------

# -------------------------------------------------------
# Repository management scripts for Git projects
# -------------------------------------------------------


# Config
# --------------------------
# Repos will be automatically added from this directory.
GIT_REPO_DIR="$HOME/src"
# Add the full paths of any extra repos to GIT_REPOS, separated with ':'
# e.g. "/opt/rails/project:/opt/rails/another project:$HOME/other/repo"
GIT_REPOS=""
git_status_command="git_status_with_shortcuts"


# * The `git_repo` function makes it easy to list & switch between
#   git projects in $GIT_REPO_DIR (default = ~/src)
#
#   * Change directory to any of your git repos or submodules, with recursive tab completion.
#
#   * A repository index will be created at $GIT_REPO_DIR/.git_index
#     (Scanning for git projects and submodules can take a few seconds.)
#
#   * Cache can be rebuilt by running:
#       $ git_repo --rebuild-cache
#       ('--' commands have tab completion too.)
#
#   * Ignores projects within an 'archive' folder.
#
#   * Allows you to run batch commands across all your repositories:
#
#     - Update every repo from their remote: 'git_repo --update-all'
#     - Produce a count of repos for each host: 'git_repo --count-by-host'
#     - Run a custom command for each repo: 'git_repo --batch-cmd <command>'
#
# Examples:
#
#     $ git_repo --list
#     # => Lists all git projects
#
#     $ git_repo ub[TAB]
#     # => Provides tab completion for all project folders that begin with 'ub'
#
#     $ git_repo ubuntu_config
#     # => Changes directory to ubuntu_config, and auto-updates code from git remote.
#
#     $ git_repo buntu_conf
#     # => Same result as `git_repo ubuntu_config`
#
#     $ git_repo
#     # => cd $GIT_REPO_DIR


function git_repo() {
  local IFS=$'\n'
  if [ -z "$1" ]; then
    # Just change to $GIT_REPO_DIR if no params given.
    cd $GIT_REPO_DIR
  else
    if [ "$1" = "--rebuild-cache" ]; then
      _rebuild_git_repo_cache
    elif [ "$1" = "--update-all" ]; then
      _git_repo_git_update_all
    elif [ "$1" = "--batch-cmd" ]; then
      _git_repo_git_batch_cmd "${@:2:$(($#-1))}" # Pass all args except $1
    elif [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
      echo -e "$_bld_col$(_git_repo_count)$_txt_col Git repositories in $_bld_col$GIT_REPO_DIR$_txt_col:\n"
      for repo in $(_git_repo_dirs_without_home); do
        echo $(basename $repo) : $repo
      done | sort | column -t -s ':'
    elif [ "$1" = "--count-by-host" ]; then
      echo -e "=== Producing a report of the number of repos per host...\n"
      _git_repo_batch_cmd git remote -v | grep "origin.*(fetch)" |
      sed -e "s/origin\s*//" -e "s/(fetch)//" |
      sed -e "s/\(\([^/]*\/\/\)\?\([^@]*@\)\?\([^:/]*\)\).*/\1/" |
      sort | uniq -c
      echo
    else
      _check_git_repo_cache
      # Figure out which directory we need to change to.
      local project=$(echo $1 | cut -d "/" -f1)
      # Find base path of project
      local path=$(grep "/$project$" "$GIT_REPO_DIR/.git_index")
      if [ -n "$path" ]; then
        sub_path=$(echo $1 | sed "s:^$project::")
        # Append subdirectories to base path
        path="$path$sub_path"
      fi
      # Try partial matches
      # - string at beginning of project
      if [ -z "$path" ]; then path=$(_git_repo_dirs_without_home | grep -m1 "/$project"); fi
      # - string anywhere in project
      if [ -z "$path" ]; then path=$(_git_repo_dirs_without_home | grep -m1 "$project"); fi
      # --------------------
      # Go to our path
      if [ -n "$path" ]; then
        unset IFS
        eval cd "$path"   # eval turns ~ into $HOME
        # Run git callback (either update or show changes), if we are in the root directory
        if [ -z "${sub_path%/}" ]; then _git_repo_pull_or_status; fi
      else
        echo -e "$_wrn_col'$1' did not match any git repos in $GIT_REPO_DIR$_txt_col"
      fi
    fi
  fi
}

_git_repo_dirs_without_home() {
  sed -e "s/--.*//" -e "s%$HOME%~%" $GIT_REPO_DIR/.git_index
}

# Recursively searches for git repos in $GIT_REPO_DIR
function _find_git_repos() {
  # Find all unarchived projects
  local IFS=$'\n'
  for repo in $(find "$GIT_REPO_DIR" -maxdepth 4 -name ".git" -type d \! -wholename '*/archive/*'); do
    echo ${repo%/.git}              # Return project folder, with trailing ':'
    _find_git_submodules $repo  # Detect any submodules
  done
}

# List all submodules for a git repo, if any.
function _find_git_submodules() {
  if [ -e "$1/../.gitmodules" ]; then
    grep "\[submodule" "$1/../.gitmodules" | sed "s%\[submodule \"%${1%/.git}/%g" | sed "s/\"]//g"
  fi
}


# Rebuilds cache of git repos in $GIT_REPO_DIR.
function _rebuild_git_repo_cache() {
  if [ "$1" != "--silent" ]; then echo -e "== Scanning $GIT_REPO_DIR for git repos & submodules..."; fi
  # Get repos from src dir and custom dirs, then sort by basename
  local IFS=$'\n'
  for repo in $(echo -e "$(_find_git_repos)\n$(echo $GIT_REPOS | sed "s/:/\n/g")"); do
    echo $(basename $repo | sed "s/ /_/g") $repo
  done | sort | cut -d " " -f2- > "$GIT_REPO_DIR/.git_index"

  if [ "$1" != "--silent" ]; then
    echo -e "===== Cached $_bld_col$(_git_repo_count)$_txt_col repos in $GIT_REPO_DIR/.git_index"
  fi
}

# Build cache if empty
function _check_git_repo_cache() {
  if [ ! -f "$GIT_REPO_DIR/.git_index" ]; then
    _rebuild_git_repo_cache --silent
  fi
}

# Produces a count of repos in the tab completion cache (excluding commands)
function _git_repo_count() {
  echo $(sed -e "s/--.*//" "$GIT_REPO_DIR/.git_index" | grep . | wc -l)
}

# If the working directory is clean, update the git repository. Otherwise, show changes.
function _git_repo_pull_or_status() {
  if ! [ `git status --porcelain | wc -l` -eq 0 ]; then
    # Fall back to 'git status' if git status alias isn't configured
    if type $git_status_command 2>&1 | grep -qv "not found"; then
      $git_status_command
    else
      git status
    fi
  else
    # Check that a local 'origin' remote exists.
    if (git remote -v | grep -q origin); then
      branch=`parse_git_branch`
      # Only update the git repo if it hasn't been touched for at least 6 hours.
      if test `find ".git" -maxdepth 0 -type d -mmin +360`; then
        # If we aren't on any branch, checkout master.
        if [ "$branch" = "(no branch)" ]; then
          echo -e "=== Checking out$_git_col master$_txt_col branch."
          git checkout master
          branch="master"
        fi
        echo -e "=== Updating '$branch' branch in $_bld_col$path$_txt_col from$_git_col origin$_txt_col... (Press Ctrl+C to cancel)"
        # Pull the latest code from the server
        git pull origin $branch
      fi
    fi
  fi
}

# Updates all git repositories with clean working directories.
function _git_repo_update_all() {
  echo -e "== Updating code in $_bld_col$(_git_repo_count)$_txt_col repos...\n"
  for path in $(sed -e "s/--.*//" "$GIT_REPO_DIR/.git_index" | grep . | sort); do
    echo -e "===== Updating code in \e[1;32m$path\e[0m...\n"
    cd "$path"
    _git_repo_pull_or_status
  done
}

# Runs a command for all git repos
function _git_repo_batch_cmd() {
  if [ -n "$1" ]; then
    echo -e "== Running command for $_bld_col$(_git_repo_count)$_txt_col repos...\n"
    for path in $(sed -e "s/--.*//" "$GIT_REPO_DIR/.git_index" | grep . | sort); do
      cd "$path"
      $@
    done
  else
    echo "Please give a command to run for all repos. (It may be useful to write your command as a function or script.)"
  fi
}

# Tab completion function for git_repo()
function _git_repo_tab_completion() {
  _check_git_repo_cache
  local curw
  local IFS=$'\n'
  COMPREPLY=()
  curw=${COMP_WORDS[COMP_CWORD]}

  # If the first part of $curw matches a high-level directory,
  # then match on sub-directories for that project
  local project=$(echo "$curw" | cut -d "/" -f1)
  local path=$(grep "/$project$" "$GIT_REPO_DIR/.git_index" | sed 's/ /\\ /g')

  # If matching path was found and curr string contains a /, then complete project sub-directories
  if [[ -n "$path" && $curw == */* ]]; then
    local search_path=$(echo "$curw" | sed "s:^${project/\\/\\\\\\}::")
    COMPREPLY=($(compgen -d "$path$search_path" | sed -e "s:$path:$project:" -e "s:$:/:" ))
  # Else, tab complete all the entries in .git_index, plus '--' commands
  else
    local commands="--list\n--rebuild-cache\n--update-all\n--batch-cmd\n--count-by-host"
    COMPREPLY=($(compgen -W '$(sed -e "s:.*/::" -e "s:$:/:" "$GIT_REPO_DIR/.git_index" | sort)$(echo -e "\n"$commands)' -- $curw))
  fi
  return 0
}

complete -o nospace -o filenames -F _git_repo_tab_completion git_repo
# Shorter alias
alias s="git_repo"
complete -o nospace -o filenames -F _git_repo_tab_completion s

