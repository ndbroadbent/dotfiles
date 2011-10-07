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


# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# - If the input is a filename that exists, then it
#   uses the contents of that file.
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string or the contents of a file to the clipboard."
      echo "Usage: cb <string or file>"
      echo "       echo <string or file> | cb"
    else
      # If the input is a filename that exists, then use the contents of that file.
      if [ -e "$input" ]; then input="$(cat $input)"; fi
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}
# Shortcut to copy SSH public key to clipboard.
alias cb_ssh="cb ~/.ssh/id_rsa.pub"


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
  local pfix="e"
  # Max changes before reverting to standard 'git status' (can be very slow otherwise)
  local max_changes=15
  # ------------------------------------------------
  # Only export variables for less than $max_changes
  local status=`git status --porcelain`
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
          # Only break the while loop if a replacement was made.
          # This is to support cases like 'Gemfile' and 'Gemfile.lock' both being modified.
          if echo $line | grep -q "\$$pfix$i"; then break; fi
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

# Can be used in conjunction with the gs() function.
# - Allows you to stage numbered files, ranges of files, or filepaths.
# - Option to detect and use 'git rm' for deleted files.
#   So instead of meaning 'Add file contents to the index',
#   the default meaning of this shortcut is 'stage the change to this file'.
# -------------------------------------------------------------------------------
ga() {
  local pfix="e" # Prefix for environment variable shortcuts
  local auto_remove="yes" # Use 'git rm' for deleted files.
  if [ -z "$1" ]; then
    echo "Usage: ga <file>  => git add <file>"
    echo "       ga 1       => git add \$e1"
    echo "       ga 2..4    => git add \$e2 \$e3 \$e4"
    echo "       ga 2 5..7  => git add \$e2 \$e5 \$e6 \$e7"
    if [[ $auto_remove == "yes" ]]; then
      echo -e "\nNote: Deleted files will also be staged using this shortcut."
      echo "      To turn off this behaviour, change the 'auto_remove' option."
    fi
  else
    # Expand each argument into sets of files.
    for arg in "$@"; do
      # If passed an integer, use the corresponding $e{*} variable
      if [[ "$arg" =~ ^[0-9]+$ ]] ; then
        files=$(eval echo \$$pfix$arg)
      # If passed a range, expand the range for each $e{*} variable
      elif [[ $arg == *..* ]]; then
        files=""
        for i in $(seq $(echo $arg | tr ".." " ")); do
          files="$files $(eval echo \$$pfix$i)"
        done
      # Fall back to treating $arg as a filepath.
      else
        files="$arg"
      fi
      # Process each file
      for file in $files; do
        # If 'auto_remove' is enabled and file doesn't exist,
        # use 'git rm' instead of 'git add'.
        if [[ $auto_remove == "yes" ]] && ! [ -e $file ]; then
          git rm $file
        else
          git add $file
          echo "add '$file'"  # similar output to 'git rm'
        fi
      done
    done
  fi
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
fix_whitespace() {
  find . -not -path '.git' -iname '*.rb' -print0 | xargs -0 sed -i -e 's/[[:space:]]*$//g' -e '${/^$/!s/$/\n/;}'
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

