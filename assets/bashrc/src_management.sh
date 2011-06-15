# -------------------------------------------------------
# Source Management Scripts (for Git / RVM projects)
# Written by Nathan D. Broadbent (www.madebynathan.com)
# -------------------------------------------------------
src_dir=`echo ~/src`

# * The src function makes it easy to list / switch between
#   git projects in $src_dir (default = ~/src)
# * Provides tab completion for all git repos,
#   including nested directories and submodules.
# * Git repo index is cached in $src_dir/.git_index
#   Cache can be rebuilt by running $ src --rebuild-cache
#   ('--' commands have autocompletion too!)
#
# Examples:
#
#     $ src
#     # => Lists all git projects in $src_dir
#
#     $ src ub[TAB]
#     # => Lists all git repos that begin with 'ub'
#
#     $ src ubuntu_config
#     # => Changes directory to ubuntu_config, updates code from git remote.
#
#     $ src buntu_conf
#     # => Works exactly the same as `src ubuntu_config`

function src() {
  if [ -n "$1" ]; then
    if [ "$1" = "--rebuild-cache" ]; then
      _src_rebuild_cache
    elif [ "$1" = "--update-all" ]; then
      _src_git_update_all
    else
      _src_check_cache
      # Match full argument before trying a partial match.
      path=`grep -m1 "$1$" $src_dir/.git_index`
      if [ -z "$path" ]; then
        path=`grep -m1 "$1" $src_dir/.git_index`
      fi
      if [ -n "$path" ]; then
        # Change to project directory. This will automatically execute the .rvmrc
        cd $src_dir/$path
        # Run git commands (either update or show changes)
        _src_git_pull_or_status
      else
        echo -e "$_wrn_col'$1' did not match any git repos in $src_dir$_txt_col"
      fi
    fi
  else
    echo -e "Git repositories in $_bld_col$src_dir$_txt_col:\n"
    cat $src_dir/.git_index | sed -e "s/--.*//" | grep . | sort
  fi
}

# Rescursively searches for git repos in $src_dir
function _src_find_git_repos() {
  for repo in $(find $src_dir -mindepth 2 -type d -name .git); do
    expr match "$repo" "$src_dir\/\(.*\)/.git"
  done
}

# Rebuilds cache of git repos in $src_dir.
function _src_rebuild_cache() {
  echo -e "== Scanning $src_dir for git repos..."
  _src_find_git_repos > $src_dir/.git_index
  # Append extra commands
  cat >>$src_dir/.git_index <<-EOF
--rebuild-cache
--update-all
EOF
  echo -e "===== Cached $_bld_col$(_src_repo_count)$_txt_col repos in $src_dir/.git_index"
}

# Build cache if cache file doesn't exist.
function _src_check_cache() {
  if [ ! -f $src_dir/.git_index ]; then
    _src_rebuild_cache
  fi
}

# Produces a count of repos in the tab completion cache (excluding commands)
function _src_repo_count() {
  echo $(cat $src_dir/.git_index | sed -e "s/--.*//" | grep . | wc -l)
}


# If the working directory is clean, update the git repository. Otherwise, show changes.
function _src_git_pull_or_status() {
  if ! [ `git status --porcelain | wc -l` -eq 0 ]; then
    gst
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
        echo -e "=== Updating all branches in $_bld_col$path$_txt_col from$_git_col origin$_txt_col... (Press Ctrl+C to cancel)"
        # Pull the latest code from the server
        git pull --all
      fi
    fi
  fi
}

# Updates all git repositories where possible
function _src_git_update_all() {
  echo -e "== Updating code in $_bld_col$(_src_repo_count)$_txt_col repos...\n"
  for path in $(cat $src_dir/.git_index | sed -e "s/--.*//" | grep . | sort); do
    cd $src_dir/$path
    _src_git_pull_or_status
  done
}

# Tab completion function for src()
_src_tab_completion() {
  _src_check_cache
  local curw
  COMPREPLY=()
  curw=${COMP_WORDS[COMP_CWORD]}
  # Tab completes all the lowest-level directories in .git_index
  COMPREPLY=($(compgen -W '$(cat $src_dir/.git_index | sed -e "s/.*\///" | sort)' -- $curw))
  return 0
}

complete -F _src_tab_completion -o dirnames src

