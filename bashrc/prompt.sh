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
_git_col="\033[1;36m"   # Git branch
_chr_col=$_txt_col      # Prompt char

# Returns the current git branch (returns nothing if not a git repository)
parse_git_branch() {
  \git branch 2> /dev/null | sed "s/^\* \([^ ]*\)/\1/;tm;d;:m"
}

parse_git_dirty() {
  local git_status="$(\git status --short --porcelain 2> /dev/null)"
  if [ -n "$git_status" ]; then
    # Default blue for only untracked files
    local color="\033[1;34m"

    if echo "$git_status" | grep -q '^[^?]'; then
      # Red if not just untracked files.
      local color="$_wrn_col"
    fi
    echo -e "\[$color\]±"
  fi
}

# Returns the current ruby version.
parse_ruby_version() {
  if (which ruby | grep -q ruby); then
    ruby -v | cut -d ' ' -f2
  fi
}

# Returns the Travis CI status for a given branch, default 'master'
parse_travis_status() {
  local branch="$1"
  if [ -z "$branch" ]; then branch="master"; fi

  local stat_file=$(find_in_cwd_or_parent ".travis_status~")
  if [ -e "$stat_file" ]; then
    case "$(grep -m 1 "^$branch " "$stat_file")" in
    *passed)  echo "\[\033[01;32m\]✔ ";; # green
    *failed)  echo "\[\033[01;31m\]✘ ";; # red
    *running) echo "\[\033[01;33m\]⁇ ";; # yellow
    esac
  fi
}

parse_branched_db_status() {
  if [ -n "$DB_SUFFIX" ]; then
    # Show that our current database is a unique snowflake
    echo "\[\033[01;35m\]❅ "
  fi
}

# When developing gems ($GEM_DEV is exported), display a hammer and pick
parse_gem_development() {
  if env | grep -q "^GEM_DEV="; then echo "\[\033[0;33m\]⚒ "; fi
}

parse_convox_host() {
  if [[ $PWD == */code/form_api* ]]; then
    if [ -e ~/.convox/host ]; then
      local CONVOX_HOST="$(cat ~/.convox/host)"
      if [ $CONVOX_HOST = "console.convox.com" ]; then
        echo " \[\033[00;35m\][P]\033[00m "
      else
        echo " \[\033[00;32m\][S]\033[00m "
      fi
    fi
  fi
}

# Allow symbols to represent users & machines
user_symbol(){ [ -e $HOME/.user_sym ] && cat $HOME/.user_sym || echo "$USER"; }
host_symbol(){ [ -e "$HOME/.hostname_sym" ] && cat $HOME/.hostname_sym || echo "$HOSTNAME"; }
user_host_sep() { ([ -e $HOME/.user_sym ] && [ -e "$HOME/.hostname_sym" ]) || echo "@"; }

# Set the prompt string (PS1)
# Looks like this:
#     user@computer ~/src/ubuntu_config [master|1.8.7]$

# (Prompt strings need '\['s around colors.)
set_ps1() {
  local user_str="\[$_usr_col\]$(user_symbol)\[$_sep_col\]$(user_host_sep)\[$_hst_col\]$(host_symbol)\[$_txt_col\]"
  local dir_str="\[$_cwd_col\]\w"
  local git_branch=`parse_git_branch`
  local git_dirty=`parse_git_dirty`
  local trav_str=`parse_travis_status "$git_branch"`
  local db_str=`parse_branched_db_status`
  local gem_dev=`parse_gem_development`
  local ruby=`parse_ruby_version`
  local convox_host=`parse_convox_host`

  git_str="\[$_git_col\]$git_branch$git_dirty"
  # Git repo & ruby version
  if [ -n "$git_branch" ] && [ -n "$ruby" ]; then
    env_str="\[$_env_col\][$git_str\[$_env_col\]|$ruby]"
  # Just git repo
  elif [ -n "$git_branch" ]; then
    env_str="\[$_env_col\][$git_str\[$_env_col\]]"
  # Just ruby version
  elif [ -n "$ruby" ]; then
    env_str="\[$_env_col\][$ruby]"
  else
    unset env_str
  fi

  # < username >@< hostname > < current directory > [< git branch >|< ruby version >] < ci status > < db status > < gem dev status >
  PS1="${debian_chroot:+($debian_chroot)}$user_str $dir_str \
$env_str$trav_str$db_str$gem_dev$convox_host\[$_chr_col\]\$ \[$_txt_col\]"
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
