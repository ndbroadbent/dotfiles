# -------------------------------------------------------
# Functions
# -------------------------------------------------------

# Bash Colors index
# ------------------------------------------------
color_index() {
  # Show an index of all available bash colors
  echo -e "\n              Usage: \\\033[*;**(;**)m"
  echo -e   "            Default: \\\033[0m"
  local blank_line="\033[0m\n     \033[0;30;40m$(printf "%41s")\033[0m"
  echo -e "$blank_line" # Top border
  for STYLE in 2 0 1 4 9; do
    echo -en "     \033[0;30;40m "
    # Display black fg on white bg
    echo -en "\033[${STYLE};30;47m${STYLE};30\033[0;30;40m "
    for FG in $(seq 31 37); do
        CTRL="\033[${STYLE};${FG};40m"
        echo -en "${CTRL}"
        echo -en "${STYLE};${FG}\033[0;30;40m "
    done
    echo -e "$blank_line" # Separators
  done
  echo -en "     \033[0;30;40m "
  # Background colors
  echo -en "\033[0;37;40m*;40\033[0;30;40m \033[0m" # Display white fg on black bg
  for BG in $(seq 41 47); do
      CTRL="\033[0;30;${BG}m"
      echo -en "${CTRL}"
      echo -en "*;${BG}\033[0;30;40m "
  done
  echo -e "$blank_line" "\n" # Bottom border
}

# XClip clipboard helper function
# ------------------------------------------------
cb() {
  _success_col="\e[1;32m"
  _warn_col='\e[1;31m'
  if [ -n "$1" ]; then
    # Check user is not root (root doesn't have access to user xorg server)
    if [[ $(whoami) == root ]]; then
      echo -e "$_warn_col  Must be regular user to copy a file to the clipboard!\e[0m"
      exit
    fi
    # Copy text to clipboard
    echo -n $1 | xclip -selection c
    echo -e "$_success_col  Copied to clipboard:\e[0m $1"
  else
    echo "Copies first argument to clipboard. Usage: cb <string>"
  fi
}

# Calculator function
#   $ ? 1337 - 1295
#   => 42
# ------------------------------------------------
? () { echo "$*" | bc -l; }


# Search and replace strings recursively in current dir
# -----------------------------------------------------
gsed() {
  if [ -n "$3" ]; then
    egrep --exclude-dir=.git -lRZ "$1" $3 | xargs -0 -l sed -i -e "s~$1~$2~g"
  else
    echo "== Usage: gsed search_string replace_string [path]"
  fi
}


# Processes your git status output, exporting bash variables
# for the filepaths of each modified file.
# To ensure colored output, please run: $ git config --global color.status always
# Written by Nathan D. Broadbent (www.madebynathan.com)
# -----------------------------------------------------------
gs() {
  # Set your preferred shortcut letter here
  pfix="e"
  # Max changes before reverting to standard 'git status' (can be very slow otherwise)
  max_changes=15
  # ------------------------------------------------
  # Only export variables for less than $max_changes
  status=`git status --porcelain`
  IFS=$'\n'
  if [ $(echo "$status" | wc -l) -lt $max_changes ]; then
    f=0  # Counter for the number of files
    for line in $status; do
      file=$(echo $line | sed "s/^.. //g")
      let f++
      files[$f]=$file           # Array for formatting the output
      export $pfix$f=$file     # Exporting variable for use.
    done
    full_status=`git status`  # Fetch full status
    # Search and replace each line, showing the exported variable name next to files.
    for line in $full_status; do
      i=1
      while [ $i -le $f ]; do
        search=${files[$i]}
        # Need to strip the color character from the end of the line, otherwise
        # EOL '$' doesn't work. This gave me a headache for long time.
        # The echo ~> regex is very time-consuming, so we perform a simple search first.
        if [[ $line = *$search* ]]; then
          replace="\\\033[2;37m[\\\033[0m\$$pfix$i\\\033[2;37m]\\\033[0m $search"
          line=$(echo $line | sed -r "s:$search(\x1B\[m)?$:$replace:g")
          break
        fi
        let i++
      done
      echo -e $line                        # Print the final transformed line.
    done
  else
    # If there are too many changed files, this 'gs' function will slow down.
    # In this case, fall back to plain 'git status'
    git status
  fi
  # Reset IFS separator to default.
  unset IFS
}


# Permanently remove files/folders from git repository
# -----------------------------------------------------------
# Author: David Underhill
# Script to permanently delete files/folders from your git repository.  To use
# it, cd to your repository's root and then run the script with a list of paths
# you want to delete, e.g., git-delete-history path1 path2

git-remove-history() {
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

# Strip whitespace from all ruby files in the current directory (and subdirectories)
# ----------------------------------------------------------------------------------
ruby-strip-whitespace() {
  find . -not -path '.git' -iname '*.rb' -print0 | xargs -0 sed -i 's/[[:space:]]*$//'
}


# Download streaming mp3s & sanitize with ffmpeg
# -----------------------------------------------------------
grooveshark_dl() {
  if [ -n "$2" ]; then
    echo "== Downloading .."
    axel $1 -o "/tmp/$2.tmp"
    echo "== Converting .."
    ffmpeg -ab 128000 -i "/tmp/$2.tmp" "$2.mp3"
    rm "/tmp/$2.tmp"
    echo "== Finished!"
  else
    echo "Usage: grooveshark_dl <url> <title (w/o .mp3)>"
  fi
}

# Restart Atlassian Bamboo server
# -----------------------------------------------------------
restart_bamboo() {
  bamboo_server="root@integration.crossroadsint.org"
  echo "=== Restarting Bamboo server at: $bamboo_server ..."
  ssh root@integration.crossroadsint.org "/etc/init.d/bamboo restart"
  echo "===== Restarted. Bamboo agents will automatically restart."
}


# Look busy
random_hex() { for i in $(seq 1 2); do echo -n $(echo "obase=16; $(($RANDOM % 16))" | bc | tr '[A-Z]' '[a-z]'); done; }
look_busy() { clear; while true; do head -n 500 /dev/urandom | hexdump -C | grep --color=auto "`random_hex` `random_hex`"; done; }


# Archive and backup all iPhone applications
# ------------------------------------------
idevicearchiveallapps() {
  if [ -n "$1" ]; then
    for app in $(ideviceinstaller -l | grep " - " | sed "s/ - .*//g"); do
      echo "== Archiving and backing up: $app ..."
      ideviceinstaller -a $app -o copy=$1 -o remove
    done
  else
    echo "Usage: $0 <backup path>"
  fi
}

