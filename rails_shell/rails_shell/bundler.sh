# Test whether file exists in current or parent directories
find_in_cwd_or_parent() {
  local slashes=${PWD//[^\/]/}; local directory=$PWD;
  for (( n=${#slashes}; n>0; --n )); do
    test -e "$directory/$1" && echo "$directory/$1" && return 0
    directory="$directory/.."
  done
  return 1
}

ensure_bundler() { which bundle >/dev/null 2>&1 || gem install bundler; }

# Use bundler for commands, if Gemfile is present
bundle_exec_if_possible() {
  ensure_bundler
  if find_in_cwd_or_parent Gemfile > /dev/null; then
    bundle_install_wrapper bundle exec "$@"
  else
    /usr/bin/env "$@"
  fi
}

# If a bundler exits with status '7' (GemNotFound),
# then run 'bundle install' and try again.
bundle_install_wrapper() {
  ensure_bundler
  # Try running command
  if ! "$@"; then
    exit_code=$?
    if [ $exit_code = 7 ]; then
      # If command crashes, try a bundle install
      echo -e "\033[1;31m'$*' failed with exit code 7."
      echo    "This probably means that your system is missing gems defined in your Gemfile."
      echo -e "Executing 'bundle install'...\033[0m"
      if bundle install; then
        echo "'bundle install' was successful. Retrying '$*'..."
        "$@"
      fi
    else
      return $exit_code
    fi
  fi
}

# The following is based on https://github.com/gma/bundler-exec
bundled_commands="rails rake rspec spring"
for cmd in $bundled_commands; do
  eval "$cmd() { bundle_exec_if_possible $cmd \"\$@\"; }"
done

# shellcheck disable=SC2139
alias b="ensure_bundler; bundle --jobs=$ACTUAL_CPU_CORES"
# shellcheck disable=SC2139
alias bi="ensure_bundler; bundle install --jobs=$ACTUAL_CPU_CORES"
alias bu="ensure_bundler; bundle update"
alias be="ensure_bundler; bundle exec"
alias bl="ensure_bundler; bundle list"
alias bp="ensure_bundler; bundle package"
alias bo="ensure_bundler; bundle open"
