# -------------------------------------------------------
# Prompt / Xterm
# -------------------------------------------------------

# Prompt colors
_txt_col="\033[00m"     # Std text (white)
_bld_col="\033[1;37m"   # Bold text (white)
_wrn_col="\033[1;31m"   # Warning
_sep_col="\033[2;32m"   # Separators
_usr_col="\033[1;32m"   # Username
_cwd_col=$_txt_col      # Current directory
_hst_col="\033[0;32m"   # Host
_env_col="\033[0;36m"   # Prompt environment
_ruby_col="\033[1;36m"  # Ruby version
_git_col="\033[1;36m"   # Git branch
_chr_col=$_txt_col      # Prompt char

parse_git_branch() {
  \git rev-parse --abbrev-ref HEAD 2> /dev/null
}

parse_git_dirty() {
  local START_TIME ELAPSED_TIME
  if [ -f .git/info/slow-status ]; then
    echo -e "\[\033[1;33m\]?"
    return
  fi

  START_TIME=$(gdate +%s%3N)
  # git_status=$(\git status --short --porcelain 2>/dev/null)
  local git_dirty
  git_dirty=$(\git diff --quiet 2>/dev/null || echo "true")
  # Slow version that can also show untracked files:
  # if [ -z "$git_status" ]; then
  #   rm -f .git/info/dirty*
  # elif echo "$git_status" | grep -q '^[^?]'; then
  #   touch .git/info/dirty
  # else
  #   touch .git/info/dirty-untracked
  # fi
  ELAPSED_TIME=$(( $(gdate +%s%3N) - START_TIME ))

  # Show a warning for huge repos where git status is slow, e.g. Chromium, Linux.
  # Then touch '.git/info/slow-status' to disable the prompt for this repo.
  if [ "$ELAPSED_TIME" -gt 5000 ]; then
    touch .git/info/slow-status
    echo -e "\033[1;31m'git status' took $ELAPSED_TIME milliseconds." \
      "That's a really long time." 1>&2
    echo -e "You might want to install 'rs-git-fsmonitor' to set up a" \
      "file watcher daemon." 1>&2
    echo -e "See: https://github.com/jgavris/rs-git-fsmonitor" 1>&2
    echo -e "Then run: git config core.fsmonitor rs-git-fsmonitor" 1>&2
    echo 1>&2
    echo -e "Unfortunately it will still be too slow to show the git status" 1>&2
    echo -e "in your bash prompt, so we've disabled it for this repo." 1>&2
    echo -e "(A file was created at: .git/info/slow-status)\033[0m" 1>&2
    echo 1>&2
  fi

  if [ -n "$git_dirty" ]; then
    echo -e "\[$_wrn_col\]±"
  fi
  # Slow version that can also show untracked files:
  # if [ -f .git/info/dirty ] || [ -f .git/info/dirty-untracked ]; then
  #   if [ -f .git/info/dirty ]; then
  #     # Red if not just untracked files.
  #     local color="$_wrn_col"
  #   else
  #     # Default blue for only untracked files
  #     local color="\033[1;34m"
  #   fi
  #   echo -e "\[$color\]±"
  # fi
}

# Returns the current ruby version.
parse_ruby_version() {
  \cat .ruby-version 2>/dev/null && return

  local RUBY_VERSION_FILE
  RUBY_VERSION_FILE=$(find_in_cwd_or_parent ".ruby-version")
  if [ -f "$RUBY_VERSION_FILE" ]; then
    \cat "$RUBY_VERSION_FILE"
    return
  fi

  if (which ruby | grep -q ruby); then
    ruby -v | cut -d ' ' -f2 | cut -d 'p' -f 1
  fi
}

# Returns the Travis CI status for a given branch, default 'main'
parse_travis_status() {
  local stat_file branch="$1"
  if [ -z "$branch" ]; then branch="main"; fi

  stat_file=$(find_in_cwd_or_parent ".travis_status~")
  if [ -f "$stat_file" ]; then
    case "$(grep -m 1 "^$branch " "$stat_file")" in
    *passed)  echo "\[\033[1;32m\]✔ ";; # green
    *failed)  echo "\[\033[1;31m\]✘ ";; # red
    *running) echo "\[\033[1;33m\]⁇ ";; # yellow
    esac
  fi
}

parse_branched_db_status() {
  if [ -n "$DB_SUFFIX" ]; then
    # Show that our current database is a unique snowflake
    echo "\[\033[1;35m\]❅ "
  fi
}

# When developing gems ($GEM_DEV is exported), display a hammer and pick
parse_gem_development() {
  if env | grep -q "^GEM_DEV="; then echo "\[\033[0;33m\]⚒ "; fi
}

parse_convox_host() {
  local CONVOX_CURRENT

  if ! [[ $PWD == */code/docspring* ]] || \
     ! [ -f "$HOME/Library/Preferences/convox/current" ]; then
    return
  fi
  # CONVOX_HOST="$(jq -r ".name" "$HOME/Library/Preferences/convox/current")"
  CONVOX_CURRENT="$(\cat "$HOME/Library/Preferences/convox/current")"
  if [[ $CONVOX_CURRENT == *"production-v3"* ]]; then
    echo "\[\033[1;35m\]P"
  elif [[ $CONVOX_CURRENT == *"europe-v3"* ]]; then
    echo "\[\033[1;33m\]EU"
  # else
  #   echo "\[\033[1;32m\]S"
  fi
}

parse_ci_status() {
  if ! [ -f "scripts/circleci_pipeline_status" ]; then return; fi
  ./scripts/circleci_pipeline_status -b "$1"
}


# Allow symbols to represent users & machines
user_symbol(){ [ -e "$HOME"/.user_sym ] && \cat "$HOME"/.user_sym || echo "$USER"; }
host_symbol(){ [ -e "$HOME/.hostname_sym" ] && \cat "$HOME"/.hostname_sym || echo "$HOSTNAME"; }
user_host_sep() { ([ -e "$HOME"/.user_sym ] && [ -e "$HOME/.hostname_sym" ]) || echo "@"; }

# Set the prompt string (PS1)
# Looks like this:
#     user@computer ~/src/ubuntu_config [main|1.8.7]$

# (Prompt strings need '\['s around colors.)
set_ps1() {
  local user_str dir_str git_branch git_dirty ruby convox_host ci_status bg_procs

  user_str="\[$_usr_col\]$(user_symbol)\[$_sep_col\]$(user_host_sep)\[$_hst_col\]$(host_symbol)\[$_txt_col\]"
  dir_str="\[$_cwd_col\]\w"
  git_branch=$(parse_git_branch)
  git_dirty=$(parse_git_dirty)
  ruby=$(parse_ruby_version)
  convox_host=$(parse_convox_host)
  ci_status=$(parse_ci_status "$git_branch")

  local num_procs
  num_procs=$(jobs -p | wc -l)
  if [ "$num_procs" -gt 0 ]; then
    bg_procs=" \033[1;31m[${num_procs}]"
  fi

  git_str="\[$_git_col\]$git_branch$git_dirty"

  # Git repo & ruby version & Convox host & CI status
  if [ -n "$git_branch" ] && [ -n "$ruby" ] && [ -n "$convox_host" ] && [ -n "$ci_status" ]; then
    env_str="\[$_env_col\][$git_str\[$_env_col\]|\[$_ruby_col\]$ruby\[$_env_col\]|$convox_host\[$_env_col\]|$ci_status\[$_env_col\]]$bg_procs"
  # Git repo & ruby version
  elif [ -n "$git_branch" ] && [ -n "$ruby" ]; then
    env_str="\[$_env_col\][$git_str\[$_env_col\]|\[$_ruby_col\]$ruby\[$_env_col\]]$bg_procs"
  # Just git repo
  elif [ -n "$git_branch" ]; then
    env_str="\[$_env_col\][$git_str\[$_env_col\]]$bg_procs"
  # Just ruby version
  elif [ -n "$ruby" ]; then
    env_str="\[$_env_col\][\[$_ruby_col\]$ruby\[$_env_col\]]$bg_procs"
  else
    unset env_str
  fi

  # < username >@< hostname > < current directory > [< git branch >|< ruby version >] < ci status > < db status > < gem dev status >
  PS1="${debian_chroot:+($debian_chroot)}$user_str $dir_str \
$env_str\[$_chr_col\] \$ \[$_txt_col\]"
}

# Set custom prompt
autoreload_prompt_command+='set_ps1;'

# Set GREP highlight color to lime green
export GREP_COLOR='1;32'

# Custom Xterm/RXVT Title
case "$TERM" in
xterm*|rxvt*)
    #ßautoreload_prompt_command+='echo -ne "\033]0;$(user_symbol)$(user_host_sep)$(host_symbol) ${PWD/$HOME/~}\007";'
    ;;
*)
    ;;
esac

# Correct spelling errors for 'cd' command, and auto cd to directory
# Only run this for debian systems (AWS doesn't have 'shopt')
if [ -f /etc/debian_version ]; then
  shopt -s cdspell
  shopt -s autocd
fi
