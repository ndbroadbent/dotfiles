# -------------------------------------------------------
# Source Management Scripts (for Git / RVM projects)
# Written by Nathan D. Broadbent (www.madebynathan.com)
# -------------------------------------------------------
src_dir=`echo ~/src`

# * The `src` function makes it easy to list / switch between
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
#
#
# * The `design` function manages the 'Design' directory tree for the current project,
#   including folders such as Backgrounds, Logos, Icons, and Samples. The actual directories are
#   created in ~/Design, symlinked into the project, and ignored from source control.
#   This is because we usually don't want to check in large bitmaps or wav files into our code repository,
#   and it also gives us the option to sync ~/Design via Dropbox.
#
# Examples:
#
#    $ design init        # Creates default directory structure at ~/Design/**/ubuntu_config and symlinks into project.
#                           (Backgrounds Logos Icons Mockups Screenshots)
#    $ design init --av   # Adds extra directories for audio/video assets
#                           (Backgrounds Logos Icons Mockups Screenshots Music AudioSamples Animations VideoClips)
#    $ design rm          # Removes any design directories for ubuntu_config
#    $ design trim        # Trims empty design directories for ubuntu_config
#

function src() {
  if [ -n "$1" ]; then
    if [ "$1" = "--rebuild-cache" ]; then
      _src_rebuild_cache
    elif [ "$1" = "--update-all" ]; then
      _src_git_update_all
    elif [ "$1" = "--migrate-remotes" ]; then
      _src_git_migrate_remotes
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
--migrate-remotes
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

# Updates all git repositories where possible
function _src_git_migrate_remotes() {
  echo -e "== Updating repo url for $_bld_col$(_src_repo_count)$_txt_col repos..."
  echo "   (from  svn.globalhand.org/git  to  code.crossroads.org.hk/git)"
  for path in $(cat $src_dir/.git_index | sed -e "s/--.*//" | grep . | sort); do
    cd $src_dir/$path
    int_url=$(ruby -e 'puts `git remote -v`[/(https:\/\/svn.globalhand.org[^ ]*)/, 1]')
    # If git repo has svn.globalhand.org
    if echo $int_url | grep -q svn.globalhand.org; then
      new_remote=$(echo $int_url | sed s%svn.globalhand.org/git%code.crossroads.org.hk/git%g)
      echo "Setting git remote (origin): $new_remote"
      git remote set-url origin $new_remote
    fi
  done
}


# Tab completion function for src()
function _src_tab_completion() {
  _src_check_cache
  local curw
  COMPREPLY=()
  curw=${COMP_WORDS[COMP_CWORD]}
  # Tab completes all the lowest-level directories in .git_index
  COMPREPLY=($(compgen -W '$(cat $src_dir/.git_index | sed -e "s/.*\///" | sort)' -- $curw))
  return 0
}

complete -F _src_tab_completion -o dirnames src


# Manage 'Design' directories for project.
function design {
  project=`basename $(pwd)`
  base_dirs="Backgrounds Logos Icons Mockups Screenshots"
  av_dirs="Music AudioSamples Animations VideoClips"
  if [ -z "$1" ]; then
    echo "design: Manage design directories for project assets that are external to source control."
    echo "  Examples:"
    echo "    $ design init        # Creates default directory structure at ~/Design/**/$project and symlinks into project."
    echo "                           ($base_dirs)"
    echo "    $ design init --av   # Adds extra directories for audio/video assets"
    echo "                           ($base_dirs $av_dirs)"
    echo "    $ design rm          # Removes any design directories for $project"
    echo "    $ design trim        # Trims empty design directories for $project"
  else
    if [ "$1" = "init" ]; then
      if [ "$2" = "--av" ]; then base_dirs+=" $av_dirs"; fi
      echo "Creating the following design directories for $project: $base_dirs"
      mkdir -p Design
      # Create and symlink each directory
      for dir in $base_dirs; do
        mkdir -p ~/Design/$dir/$project
        if [ ! -e Design/$dir ]; then ln -sf ~/Design/$dir/$project Design/$dir; fi
      done
      # Add rule to .gitignore if not already present
      if ! $(touch .gitignore && cat .gitignore | grep -q "Design"); then
        echo "Design" >> .gitignore
      fi
    elif [ "$1" = "rm" ]; then
      echo "Removing all design directories for $project..."
      base_dirs+=" $av_dirs"
      for dir in $base_dirs; do
        rm -rf ~/Design/$dir/$project
      done
      rm -rf Design
    elif [ "$1" = "trim" ]; then
      echo "Trimming empty design directories for $project..."
      base_dirs+=" $av_dirs"
      for dir in $base_dirs; do
        if ! [ -e ~/Design/$dir/$project/* ]; then
          rm -rf ~/Design/$dir/$project
          rm -f Design/$dir
        fi
      done
    else
      echo "Invalid command. Valid commands are: init, rm, trim"
    fi
  fi
}

