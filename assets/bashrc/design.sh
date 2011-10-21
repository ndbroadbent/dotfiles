# -------------------------------------------------------
# Design and Binary Assets Management (for Git projects)
# Written by Nathan Broadbent (www.madebynathan.com)
# -------------------------------------------------------
#
# * The `design` function manages the 'design_assets' directory tree for the current project,
#   including folders such as Backgrounds, Logos, Icons, and Samples. The actual directories are
#   created in $design_dir, symlinked into the project, and ignored from source control.
#   This is because we usually don't want to check in large bitmaps or wav files into our code repository,
#   and it also gives us the option to sync $design_dir via Dropbox.
#
# Examples:
#
#    $ design link        # Requires SCM Breeze - Links existing design directories into each of your projects
#    $ design init        # Creates default directory structure at $design_dir/**/ubuntu_config and symlinks into project.
#                           (Backgrounds Logos Icons Mockups Screenshots)
#    $ design init --av   # Adds extra directories for audio/video assets
#                           (Backgrounds Logos Icons Mockups Screenshots Music AudioSamples Animations VideoClips)
#    $ design rm          # Removes any design directories for ubuntu_config
#    $ design trim        # Trims empty design directories for ubuntu_config
#

# Config
# --------------------------
export design_dir="$HOME/Design"

# Add ignore rule to .git/info/exclude if not already present
_design_add_git_exclude(){
  if ! $(touch "$1/.git/info/exclude" && cat "$1/.git/info/exclude" | grep -q "design_assets"); then
    echo "design_assets" >> "$1/.git/info/exclude"
  fi
}

# Manage 'design_assets' directories for project.
design() {
  local project=`basename $(pwd)`
  local int_dirs="_Fonts _IconSets"
  local base_dirs="Images Backgrounds Logos Icons Mockups Screenshots"
  local av_dirs="Music Samples Animations Videos Flash"

  # Ensure design dir contains all subdirectories
  unset IFS
  for dir in $int_dirs $base_dirs $av_dirs; do mkdir -p "$design_dir/$dir"; done

  if [ -z "$1" ]; then
    echo -e "design: Manage design directories for project assets that are external to source control.\n"
    echo -e "  Examples:\n"
    echo "    $ design init        # Creates default directory structure at $design_dir/**/$project and symlinks into project."
    echo "                           ($base_dirs)"
    echo "    $ design link        # Links existing design directories into existing repos"
    echo "    $ design init --av   # Adds extra directories for audio/video assets"
    echo "                           ($base_dirs $av_dirs)"
    echo "    $ design rm          # Removes any design directories for $project"
    echo "    $ design trim        # Trims empty design directories for $project"
    echo
  else

    if [ "$1" = "init" ]; then
      if [ "$2" = "--av" ]; then base_dirs+=" $av_dirs"; fi
      echo "Creating the following design directories for $project: $base_dirs"
      mkdir -p design_assets
      # Create and symlink each directory
      for dir in $base_dirs; do
        mkdir -p "$design_dir/$dir/$project"
        if [ ! -e ./design_assets/$dir ]; then ln -sf "$design_dir/$dir/$project" design_assets/$dir; fi
      done
      _design_add_git_exclude $PWD

    elif [ "$1" = "link" ]; then
      shopt -s nullglob
      echo "== Linking existing Design directories into existing repos..."
      for dir in $base_dirs $av_dirs; do
        for design_path in $design_dir/$dir/*; do
          proj=$(basename $design_path)
          repo_path=$(grep "/$proj$" $GIT_REPO_DIR/.git_index)
          if [ -n "$repo_path" ]; then
            mkdir -p "$repo_path/design_assets"
            if [ -e "$repo_path/design_assets/*" ]; then rm $repo_path/design_assets/*; fi
            _design_add_git_exclude $repo_path
            if ! [ -e "$repo_path/design_assets/$dir" ]; then ln -fs "$design_path" "$repo_path/design_assets/$dir"; fi
            echo "=> $repo_path/design_assets/$dir"
          fi
        done
      done
      shopt -u nullglob

    elif [ "$1" = "rm" ]; then
      echo "Removing all design directories for $project..."
      base_dirs+=" $av_dirs"
      for dir in $base_dirs; do rm -rf "$design_dir/$dir/$project"; done
      rm -rf design_assets

    elif [ "$1" = "trim" ]; then
      echo "Trimming empty design directories for $project..."
      base_dirs+=" $av_dirs"
      for dir in $base_dirs; do
        if ! [ -e "$design_dir/$dir/$project/*" ]; then
          rm -rf "$design_dir/$dir/$project"
          rm -f design_assets/$dir
        fi
      done

    else
      echo -e "Invalid command.\n"
      design
    fi
  fi
}

