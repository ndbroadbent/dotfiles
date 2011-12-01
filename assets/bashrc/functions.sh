# -------------------------------------------------------
# Functions
# -------------------------------------------------------

# Bash Colors index
# ------------------------------------------------
color_index() {
  # Show an index of all available bash colors
  echo -e "\n              Usage: \\\e[*;**(;**)m"
  echo -e   "            Default: \\\e[0m"
  local blank_line="\e[0m\n     \e[0;30;40m$(printf "%41s")\e[0m"
  echo -e "$blank_line" # Top border
  for STYLE in 2 0 1 4 9; do
    echo -en "     \e[0;30;40m "
    # Display black fg on white bg
    echo -en "\e[${STYLE};30;47m${STYLE};30\e[0;30;40m "
    for FG in $(seq 31 37); do
        CTRL="\e[${STYLE};${FG};40m"
        echo -en "${CTRL}"
        echo -en "${STYLE};${FG}\e[0;30;40m "
    done
    echo -e "$blank_line" # Separators
  done
  echo -en "     \e[0;30;40m "
  # Background colors
  echo -en "\e[0;37;40m*;40\e[0;30;40m \e[0m" # Display white fg on black bg
  for BG in $(seq 41 47); do
      CTRL="\e[0;30;${BG}m"
      echo -en "${CTRL}"
      echo -en "*;${BG}\e[0;30;40m "
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
      if [ -f "$input" ]; then input="$(cat $input)"; fi
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}
# Aliases leveraging the cb() function
# -- Copy SSH public key to clipboard.
alias cbssh="cb ~/.ssh/id_rsa.pub"
# -- Copy current working directory
alias cbwd="pwd | cb"
# -- Copy the most recent command in bash history
alias cbhs="cat $HISTFILE | tail -n 1 | cb"


# Calculator
? () { echo "$*" | bc -l; }  # $ ? 1337 - 1295   => 42


# Search and replace strings recursively in current dir
# -----------------------------------------------------
gsed() {
  if [ -n "$3" ]; then
    egrep --exclude-dir=.git -lRZ "$1" $3 | xargs -0 -l sed -i -e "s%${1//\\/}%$2%g"
  else
    echo "== Usage: gsed search_string replace_string [path]"
  fi
}


# Strip whitespace from all ruby files in the current directory (and subdirectories)
# ----------------------------------------------------------------------------------
fix_whitespace() {
  find . -not -path '.git' -iname '*.rb' -print0 | xargs -0 sed -i -e 's/[[:space:]]*$//g' -e '${/^$/!s/$/\n/;}'
}

# Import SSL cert from remote host

import_ssl_cert() {
  if [ -n "$1" ]; then
    REMHOST=$1
    if [ "$REPLACE" != "true" ] && certutil -L -d sql:$HOME/.pki/nssdb | grep $REMHOST; then
      echo "Certificate already added. To replace, prepend command with REPLACE=true"
    else
      if [ "$REPLACE" = "true" ]; then
        certutil -D -n $REMHOST -d sql:$HOME/.pki/nssdb 2>&1 | cat > /dev/null
      fi
      REMPORT=${2:-443}
      exec 6>&1
      exec > $REMHOST
      echo | openssl s_client -connect ${REMHOST}:${REMPORT} 2>&1 |sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
      certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "$REMHOST" -i $REMHOST
      exec 1>&6 6>&-
      echo "Certificate added for $REMHOST"
    fi
  else
    echo "Usage:  import_cert remote.host.name [port]"
  fi
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

