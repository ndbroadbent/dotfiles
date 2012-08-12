# Calculator
? () { echo "$*" | bc -l; }  # $ ? 1337 - 1295   => 42


# Search and replace strings recursively in current dir
gsed() {
  if [ -n "$3" ]; then
    egrep --exclude-dir=.git -lRZ "$1" $3 | xargs -0 -l sed -i -e "s%${1//\\/}%$2%g"
  else
    echo "== Usage: gsed search_string replace_string [path]"
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

# Strip whitespace from all ruby files in the current directory (and subdirectories)
fix_whitespace() {
  find . -not -path '.git' -iname '*.rb' -print0 | xargs -0 sed -i -e 's/[[:space:]]*$//g' -e '${/^$/!s/$/\n/;}'
}


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

