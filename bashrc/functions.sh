# Calculator
? () { echo "$*" | bc -l; }  # $ ? 1337 - 1295   => 42


# Search and replace strings recursively in dir
gsed() {
  if [ -n "$2" ]; then
    if [ -n "$3" ]; then local path="$3"; else local path="."; fi
    egrep --exclude-dir=.git --exclude-dir=tmp --exclude-dir=log -lRZ "$1" "$path" | xargs -0 -l sed -i -e "s%${1//\\/}%$2%g"
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
      for file in $(find "$path" -type d \( -name .git -o -name tmp \) -prune -o -name "*$search_string*" -print); do
        mv "$file" "${file/$search_string/$replace}"
      done
    done
  else
    echo "== Usage: total_replace search_string replace_string [path = .] [-c ? replaces both lower case and capitalized strings]"
  fi
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

# Rejustify the user/group/size columns after username/group is replaced with symbols
rejustify_ls_columns(){
  ruby -e "o=STDIN.read;re=/^(([^ ]* +){2})(([^ ]* +){3})/;u,g,s=o.lines.map{|l|l[re,3]}.compact.map(&:split).transpose.map{|a|a.map(&:size).max+1};puts o.lines.map{|l|l.sub(re){|m|\"%s%-#{u}s %-#{g}s%#{s}s \"%[\$1,*\$3.split]}}"
}

# Google Translate text-to-speech | mplayer
say() { if [[ "${1}" =~ -[a-z]{2} ]]; then local lang=${1#-}; local text="${*#$1}"; else local lang=${LANG%_*}; local text="$*";fi; mplayer "http://translate.google.com/translate_tts?ie=UTF-8&tl=${lang}&q=${text}" &> /dev/null ; }

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

