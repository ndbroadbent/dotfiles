# Calculator
? () { echo "$*" | bc -l; }  # $ ? 1337 - 1295   => 42

# Grep/Sed - Search and replace strings recursively in a given dir
gsed() {
  if [ -n "$2" ]; then
    if [ -n "$3" ]; then local path="$3"; else local path="."; fi
    ag -l "$1" "$path" | xargs -I {} -- sed -i "" -e "s%${1//\\/}%$2%g" {}
  else
    echo "== Usage: gsed search_string replace_string [path = .]"
  fi
}

# Replace all instances of a simple string in all files, as well as renaming any files
# Use -c option to substitute both lowercase and capitalized search string
total_replace() {
  if [ -n "$2" ]; then
    local search="$1"
    local replace="$2"

    if [ "$3" = "-c" ] || [ "$4" = "-c" ]; then
      local lowercased=$(printf $search | sed 's/[^ _-]*/\L&/g')
      local capitalized=$(printf $search | sed 's/[^ _-]*/\L\u&/g')
      search="$lowercased $capitalized"
    fi
    if [ "$3" = "-c" ]; then
      # Set default path if path option skipped
      local path="."
    else
      if [ -n "$3" ]; then local path="$3"; else local path="."; fi
    fi

    for search_string in $search; do
      gsed "$search_string" "$replace" "$path"
      # Replace strings in filenames (exclude tmp and git)
      # Repeat until there are no move failures.
      local repeat=true
      while [ $repeat = true ]; do
        repeat=false
        for file in $(find "$path" -type d \( -name .git -o -name tmp -o -name log \) -prune -o -name "*$search_string*" -print); do
          mv "$file" "${file/$search_string/$replace}" > /dev/null 2>&1 || repeat=true
        done
      done
    done
  else
    echo "== Usage: total_replace search_string replace_string [path = .] [-c ? replaces both lower case and capitalized strings]"
  fi
}

pwgen() {
  ruby -e "require 'securerandom'; puts SecureRandom.hex(${1:-16})"
}

timer() {
  if [ -z "$1" ]; then
    echo "Usage: timer <time> <message (or blank for random message)>"
    echo "E.g. timer 5s"
    echo "E.g. timer 10m \"The pizza is ready\""
    return 1
  fi

  message="$2"
  # Pick a random message if not provided
  if [ -z "$message" ]; then
    messages[0]="The time is now, do that thing."
    messages[1]="Do that thing that you need to do."
    messages[2]="The task is at hand. Godspeed."
    messages[3]="Time is short, you must act now."
    messages[4]="Sir, it is time."
    messages[5]="The timer has spoken, your destiny awaits."
    messages[6]="Do what you came here to do."
    messages[7]="What has been planned must now be executed."
    rand=$[ $RANDOM % 8 ]
    message="${messages[$rand]}"
  fi

  (gsleep $1 && beep && say "$message") &
}

# Test whether file exists in current or parent directories
find_in_cwd_or_parent() {
  local slashes=${PWD//[^\/]/}; local directory=$PWD;
  for (( n=${#slashes}; n>0; --n )); do
    test -e "$directory/$1" && echo "$directory/$1" && return 0
    directory="$directory/.."
  done
  return 1
}

# Strip trailing whitespace, and ensure files end with a newline.
fix_whitespace() {
  local exclude_dirs;
  for d in .git tmp log public; do exclude_dirs+="-path './$d' -prune -o "; done
  eval find . $exclude_dirs -type f | \
  xargs file | grep -P "ASCII|UTF-8" | cut -d: -f1 | \
  xargs -I % sh -c "{ rm % && awk 1 > %; } < %; sed -i % -e 's/[[:space:]]*$//g'"
}

ping() {
  for host; do true; done # Set host as last argument
  if grep -q "\(\t\| \)$host" /etc/hosts; then
    echo -e "\033[33m/etc/hosts contains an entry for hostname: $host\033[0m"
  fi
  /sbin/ping "$@"
}

moar_wifi_plz() {
  NEW_MAC=$(openssl rand -hex 3 | sed 's/\(..\)/\1:/g; s/.$//; s/^\(.\)/00:60:2f:\1/')
  echo "Changing Wifi MAC address to: $NEW_MAC"
  sudo ifconfig en0 ether "$NEW_MAC"
}

# Rejustify the user/group/size columns after username/group is replaced with symbols
rejustify_ls_columns(){
  ruby -e "o=STDIN.read;re=/^(([^ ]* +){2})(([^ ]* +){3})/;u,g,s=o.lines.map{|l|l[re,3]}.compact.map(&:split).transpose.map{|a|a.map(&:size).max+1};puts o.lines.map{|l|l.sub(re){|m|\"%s%-#{u}s %-#{g}s%#{s}s \"%[\$1,*\$3.split]}}"
}

if [ "$(uname)" != Darwin ]; then
  # If not on mac, set up 'say' command using
  # Google Translate text-to-speech | mplayer
  say() { if [[ "${1}" =~ -[a-z]{2} ]]; then local lang=${1#-}; local text="${*#$1}"; else local lang=${LANG%_*}; local text="$*";fi; mplayer "http://translate.google.com/translate_tts?ie=UTF-8&tl=${lang}&q=${text}" &> /dev/null ; }
fi

# Look busy
random_hex() { for i in $(seq 1 2); do echo -n $(echo "obase=16; $(($RANDOM % 16))" | bc | tr '[A-Z]' '[a-z]'); done; }
look_busy() { clear; while true; do head -n 500 /dev/urandom | hexdump -C | grep --color=auto "`random_hex` `random_hex`"; done; }


# Archive and backup all iPhone applications
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

