# -------------------------------------------------------
# Source Management Scripts (for Git / RVM projects)
# Written by Nathan Broadbent (www.madebynathan.com)
# -------------------------------------------------------

# * The `src` function makes it easy to list / switch between
#   git projects in $src_dir (default = ~/src)
#
#   * Provides tab completion for all git repos,
#     including nested directories and submodules.
#
#   * If you have a lot of projects, an index can be cached at $src_dir/.git_index
#     Cache can be rebuilt by running $ src --rebuild-cache
#     ('--' commands have autocompletion too.)
#
#   * Ignores any projects within an 'archive' folder.
#
#   * Lets you run batch commands across all your repositories:
#
#     - Update every repo from their remote: 'src --update-all'
#     - Produce a count of repos for each host: 'src --count-by-host'
#     - Run a command for each repo: 'src --batch-cmd <command>'
#
# Examples:
#
#     $ src --list (or src -l)
#     # => Lists all git projects
#
#     $ src ub[TAB]
#     # => Provides tab completion for all project folders that begin with 'ub'
#
#     $ src ubuntu_config
#     # => Changes directory to ubuntu_config, and auto-updates code from git remote.
#
#     $ src buntu_conf
#     # => Same result as `src ubuntu_config`
#
#     $ src
#     # => cd $src_dir
#
#
# * The `design` function manages the 'Design' directory tree for the current project,
#   including folders such as Backgrounds, Logos, Icons, and Samples. The actual directories are
#   created in $design_dir, symlinked into the project, and ignored from source control.
#   This is because we usually don't want to check in large bitmaps or wav files into our code repository,
#   and it also gives us the option to sync $design_dir via Dropbox.
#
# Examples:
#
#    $ design init        # Creates default directory structure at $design_dir/**/ubuntu_config and symlinks into project.
#                           (Backgrounds Logos Icons Mockups Screenshots)
#    $ design init --av   # Adds extra directories for audio/video assets
#                           (Backgrounds Logos Icons Mockups Screenshots Music AudioSamples Animations VideoClips)
#    $ design rm          # Removes any design directories for ubuntu_config
#    $ design trim        # Trims empty design directories for ubuntu_config
#

# Config
# --------------------------
src_dir="$HOME/src"
design_dir="$HOME/Design"
cache_repositories=true
git_status_command="gs"

function src() {
  if [ -n "$1" ]; then
    if [ "$1" = "--rebuild-cache" ]; then
      _src_rebuild_cache
    elif [ "$1" = "--update-all" ]; then
      _src_git_update_all
    elif [ "$1" = "--batch-cmd" ]; then
      _src_git_batch_cmd "${@:2:$(($#-1))}" # Pass all args except $1
    elif [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
      echo -e "($_bld_col$(_src_repo_count)$_txt_col) Git repositories in $_bld_col$src_dir$_txt_col:\n"
      sed -e "s/--.*//" $src_dir/.git_index | grep . | sort
    elif [ "$1" = "--count-by-host" ]; then
      echo -e "=== Producing a report of the number of repos per host...\n"
      _src_git_batch_cmd git remote -v | grep "origin.*(fetch)" |
      sed -e "s/origin\s*//" -e "s/(fetch)//" |
      sed -e "s/\(\([^/]*\/\/\)\?\([^@]*@\)\?\([^:/]*\)\).*/\1/" |
      sort | uniq -c
      echo
    else
      _src_check_cache
      # Figure out which directory we need to change to.
      local project=$(echo $1 | cut -d "/" -f1)
      # Find base path of project
      local path=$(grep "/$project$" "$src_dir/.git_index")
      if [ -n "$path" ]; then
        sub_path=$(echo $1 | sed "s:^$project::")
        # Append subdirectories to base path
        path="$path$sub_path"
      fi
      # Fall back to a partial match
      if [ -z "$path" ]; then path=$(grep -m1 "$project" "$src_dir/.git_index"); fi
      # Go to our path
      if [ -n "$path" ]; then
        cd "$path"
        # Run git callback (either update or show changes), if we are in the root directory
        if [ -z "$sub_path" ]; then _src_git_pull_or_status; fi
      else
        echo -e "$_wrn_col'$1' did not match any git repos in $src_dir$_txt_col"
      fi
    fi
  else
    cd $src_dir
  fi
}

# Rescursively searches for git repos in $src_dir
function _src_find_git_repos() {
  # Find all unarchived projects
  for repo in $(find "$src_dir" -maxdepth 4 -name ".git" -type d \! -wholename '*/archive/*'); do
    echo ${repo%/.git}              # Return project folder
    _src_find_git_submodules $repo   # Detect any submodules
  done
}

# List all submodules for a git repo, if any.
function _src_find_git_submodules() {
  if [ -e "$1/../.gitmodules" ]; then
    grep "\[submodule" "$1/../.gitmodules" | sed "s%\[submodule \"%${1%/.git}/%g" | sed "s/\"]//g"
  fi
}


# Rebuilds cache of git repos in $src_dir.
function _src_rebuild_cache() {
  if [ "$1" != "--silent" ]; then echo -e "== Scanning $src_dir for git repos..."; fi
  _src_find_git_repos > "$src_dir/.git_index"
  if [ "$1" != "--silent" ]; then
    echo -e "===== Cached $_bld_col$(_src_repo_count)$_txt_col repos in $src_dir/.git_index"
  fi
}

# Build cache if empty
function _src_check_cache() {
  if [ ! -f "$src_dir/.git_index" ]; then
    _src_rebuild_cache --silent
  fi
}

# Produces a count of repos in the tab completion cache (excluding commands)
function _src_repo_count() {
  echo $(sed -e "s/--.*//" "$src_dir/.git_index" | grep . | wc -l)
}

# If the working directory is clean, update the git repository. Otherwise, show changes.
function _src_git_pull_or_status() {
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
        echo -e "=== Updating all branches in $_bld_col$path$_txt_col from$_git_col origin$_txt_col... (Press Ctrl+C to cancel)"
        # Pull the latest code from the server
        git pull --all
      fi
    fi
  fi
}

# Updates all git repositories with clean working directories.
function _src_git_update_all() {
  echo -e "== Updating code in $_bld_col$(_src_repo_count)$_txt_col repos...\n"
  for path in $(sed -e "s/--.*//" "$src_dir/.git_index" | grep . | sort); do
    echo -e "===== Updating code in \033[1;32m$path\033[0m...\n"
    cd "$path"
    _src_git_pull_or_status
  done
}

# Runs a command for all git repos
function _src_git_batch_cmd() {
  if [ -n "$1" ]; then
    echo -e "== Running command for $_bld_col$(_src_repo_count)$_txt_col repos...\n"
    for path in $(sed -e "s/--.*//" "$src_dir/.git_index" | grep . | sort); do
      cd "$path"
      $@
    done
  else
    echo "Please give a command to run for all repos. (It may be useful to write your command as a function or script.)"
  fi
}

# Tab completion function for src()
function _src_tab_completion() {
  _src_check_cache
  local curw
  COMPREPLY=()
  curw=${COMP_WORDS[COMP_CWORD]}

  # If the first part of $curw matches a high-level directory,
  # then match on sub-directories for that project
  local project=$(echo $curw | cut -d "/" -f1)
  local path=$(grep "/$project$" "$src_dir/.git_index")
  if [ -n "$path" ]; then
    search_path=$(echo $curw | sed "s:^$project::")
    COMPREPLY=($(compgen -d "$path$search_path" | sed -e "s:$path:$project:" -e "s:$:/:"))
  else
    # Tab completes all the entries in .git_index, plus commands
    local commands="--list --rebuild-cache --update-all --batch-cmd --count-by-host"
    COMPREPLY=($(compgen -W '$(sed -e "s:.*/::" -e "s:$:/:" "$src_dir/.git_index" | sort) $commands' -- $curw))
  fi
  return 0
}

complete -o nospace -o filenames -F _src_tab_completion src


# Manage 'Design' directories for project.
function design {
  local project=`basename $(pwd)`
  local base_dirs="Backgrounds Logos Icons Mockups Screenshots"
  local av_dirs="Music AudioSamples Animations VideoClips"

  if [ -z "$1" ]; then
    echo -e "design: Manage design directories for project assets that are external to source control.\n"
    echo -e "  Examples:\n"
    echo "    $ design init        # Creates default directory structure at $design_dir/**/$project and symlinks into project."
    echo "                           ($base_dirs)"
    echo "    $ design init --av   # Adds extra directories for audio/video assets"
    echo "                           ($base_dirs $av_dirs)"
    echo "    $ design rm          # Removes any design directories for $project"
    echo "    $ design trim        # Trims empty design directories for $project"
    echo
  else
    if [ "$1" = "init" ]; then
      if [ "$2" = "--av" ]; then base_dirs+=" $av_dirs"; fi
      echo "Creating the following design directories for $project: $base_dirs"
      mkdir -p Design
      # Create and symlink each directory
      for dir in $base_dirs; do
        mkdir -p "$design_dir/$dir/$project"
        if [ ! -e ./Design/$dir ]; then ln -sf "$design_dir/$dir/$project" Design/$dir; fi
      done
      # Add rule to .gitignore if not already present
      if ! $(touch .gitignore && cat .gitignore | grep -q "Design"); then
        echo "Design" >> .gitignore
      fi
    elif [ "$1" = "rm" ]; then
      echo "Removing all design directories for $project..."
      base_dirs+=" $av_dirs"
      for dir in $base_dirs; do
        rm -rf "$design_dir/$dir/$project"
      done
      rm -rf Design
    elif [ "$1" = "trim" ]; then
      echo "Trimming empty design directories for $project..."
      base_dirs+=" $av_dirs"
      for dir in $base_dirs; do
        if ! [ -e "$design_dir/$dir/$project/*" ]; then
          rm -rf "$design_dir/$dir/$project"
          rm -f Design/$dir
        fi
      done
    else
      echo "Invalid command. Valid commands are: init, rm, trim"
    fi
  fi
}

