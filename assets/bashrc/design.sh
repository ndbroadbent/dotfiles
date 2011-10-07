# -------------------------------------------------------
# Design and Binary Assets Management (for Git projects)
# Written by Nathan Broadbent (www.madebynathan.com)
# -------------------------------------------------------
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
design_dir="$HOME/Design"

# Manage 'Design' directories for project.
function design {
  local project=`basename $(pwd)`
  local int_dirs="Fonts IconSets"
  local base_dirs="Images Backgrounds Logos Icons Mockups Screenshots"
  local av_dirs="Music Samples Animations Videos Flash"

  # Setup internal dirs (that aren't per-project)
  for dir in $int_dirs; do mkdir -p "$design_dir/$dir"; done

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
      # Add ignore rule to .git/info/exclude if not already present
      if ! $(touch .git/info/exclude && cat .git/info/exclude | grep -q "Design"); then
        echo "Design" >> .git/info/exclude
      fi

    elif [ "$1" = "rm" ]; then
      echo "Removing all design directories for $project..."
      base_dirs+=" $av_dirs"
      for dir in $base_dirs; do rm -rf "$design_dir/$dir/$project"; done
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

