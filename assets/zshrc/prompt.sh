MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}"
local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%}"

#ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
#ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
#ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
#ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
#ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

#function prompt_char() {
#  git branch >/dev/null 2&1> /dev/null && echo "%{$fg[green]%}±%{$reset_color%}" && return
#  hg root >/dev/null 2>/dev/null && echo "%{$fg_bold[red]%}☿%{$reset_color%}" && return
#  echo "%{$fg[cyan]%}◯ %{$reset_color%}"
#}

# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# -------------------------------------------------------
# Prompt / Xterm
# -------------------------------------------------------

# Prompt colors
_txt_col=$reset_color     # Std text (white)
_bld_col=$fg_bold[white]  # Bold text (white)
_wrn_col=$fg_bold[red]  # Warning
_sep_col=$_txt_col      # Separators
_usr_col=$fg_bold[green]  # Username
_cwd_col=$_txt_col      # Current directory
_hst_col=$fg[green]   # Host
_env_col=$fg[cyan]   # Prompt environment
_git_col=$fg_bold[cyan]  # Git branch


## Returns the current git branch (returns nothing if not a git repository)
#parse_git_branch() {
#  git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
#}

#parse_git_dirty() {
#  [[ $(git status | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "±"
#}

## Returns the current ruby version.
#parse_ruby_version() {
#  if (which ruby | grep -q ruby); then
#    ruby -v | cut -d ' ' -f2
#  fi
#}

#set_prompt() {
#  user_str="$_usr_col%n$_hst_col%m$_txt_col"
#  dir_str="$_cwd_col\w"
#  git_branch=`parse_git_branch`
#  git_dirty=`parse_git_dirty`
#  ruby=`parse_ruby_version`
#  # Git repo & ruby version
#  if [ -n "$git_branch" ] && [ -n "$ruby" ]; then
#    env_str="$_env_col[$_git_col$git_branch$_wrn_col$git_dirty$_env_col|$ruby]"
#  # Just git repo
#  elif [ -n "$git_branch" ]; then
#    env_str="$_env_col[$_git_col$git_branch$_env_col]"
#  # Just ruby version
#  elif [ -n "$ruby" ]; then
#    env_str="$_env_col[$ruby]"
#  else
#    unset env_str
#  fi

#  # < username >@< hostname > < current directory > [< git branch >|< ruby version >]
#  echo "${debian_chroot:+($debian_chroot)}$user_str $dir_str $env_str$_sep_col$ $_txt_col"
#}

RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

#PROMPT='%{$fg_bold[green]%}%n%{$fg_no_bold[green]%}@%m%{$reset_color%}\
#%{$reset_color%} %~ %{$reset_color%}$(git_prompt_info)‹$(~/.rvm/bin/rvm-prompt i v)›\
#%{$fg[red]%}%!%{$reset_color%} $(prompt_char)'

ZSH_THEME_GIT_PROMPT_PREFIX="‹%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}›"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}±"
ZSH_THEME_GIT_PROMPT_CLEAN=""

#RPROMPT='${return_status}$(git_prompt_status)%{$reset_color%}'

# Set custom prompt

#PROMPT='%{$(set_prompt)}'

# Set GREP highlight color
export GREP_COLOR='1;32'

# Custom Xterm/RXVT Title
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND+='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007";'
    ;;
*)
    ;;
esac

