# -------------------------------------------------------
# Prompt / Xterm
# -------------------------------------------------------

# Prompt colors
_txt_col="\e[00m"     # Std text (white)
_bld_col="\e[1;37m"   # Bold text (white)
_wrn_col="\e[1;31m"   # Warning
_sep_col="\e[2;32m"   # Separators
_usr_col="\e[1;32m"   # Username
_cwd_col=$_txt_col    # Current directory
_hst_col="\e[0;32m"   # Host
_env_col="\e[0;36m"   # Prompt environment
_git_col="\e[1;36m"   # Git branch
_chr_col=$_txt_col    # Prompt char

# Returns the current git branch (returns nothing if not a git repository)
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_git_dirty() {
  [ -n "$(git status --short 2> /dev/null)" ] && echo "±"
}

# Returns the current ruby version.
parse_ruby_version() {
  if (which ruby | grep -q ruby); then
    ruby -v | cut -d ' ' -f2
  fi
}

# Returns the Travis CI status for a github project
parse_travis_status() {
  if [ -e ".travis_status~" ]; then
    cat .travis_status~
  fi
}

# Allow symbols to represent users & machines
user_symbol(){ [ -e $HOME/.user_sym ] && cat $HOME/.user_sym || echo '\u'; }
host_symbol(){ [ -e /home/.hostname_sym ] && cat /home/.hostname_sym || echo '\h'; }

# Set the prompt string (PS1)
# Looks like this:
#     user@computer ~/src/ubuntu_config [master|1.8.7]$

# (Prompt strings need '\['s around colors.)
set_ps1() {
  local user_str="\[$_usr_col\]$(user_symbol)\[$_sep_col\]@\[$_hst_col\]$(host_symbol)\[$_txt_col\]"
  local dir_str="\[$_cwd_col\]\w"
  local git_branch=`parse_git_branch`
  local git_dirty=`parse_git_dirty`
  local ruby=`parse_ruby_version`
  local trav_str=""
  case "$(parse_travis_status)" in
  Passing) trav_str="\[\e[01;32m\]✔ ";;  # green
  Failing) trav_str="\[\e[01;31m\]✘! ";; # red
  Running) trav_str="\[\e[01;33m\]⁇ ";;  # yellow
  esac

  git_str="\[$_git_col\]$git_branch\[$_wrn_col\]$git_dirty"
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

  # < username >@< hostname > < current directory > < ci status > [< git branch >|< ruby version >]
  PS1="${debian_chroot:+($debian_chroot)}$user_str $dir_str $trav_str$env_str\[$_chr_col\]$ \[$_txt_col\]"
}

# Set custom prompt
PROMPT_COMMAND='set_ps1;'

# Set GREP highlight color
export GREP_COLOR='1;32'

# Custom Xterm/RXVT Title
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND+='echo -ne "\e]0;$(user_symbol)@$(host_symbol) ${PWD/$HOME/~}\007";'
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

