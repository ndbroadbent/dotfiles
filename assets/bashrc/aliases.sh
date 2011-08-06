# -------------------------------------------------------
# Aliases, functions & key bindings
# -------------------------------------------------------

# -- bash
alias s='sudo'

alias l='ls -Cv --group-directories-first'
alias ll='ls -lv --group-directories-first'
alias la='ls -lvA --group-directories-first'

alias ~='cd ~'
alias ..='cd ..'
alias ...='..;..';
alias ....='...;..'
alias .....='....;..'
alias ......='.....;..'
alias n='nautilus .'
function g() { gedit $1 &> /dev/null; }
alias ack='ack-grep'; alias ak='ack-grep'

# -- apt
alias apt-install='sudo apt-get install -y'
alias apt-search='apt-cache search'

# -- git
alias gpl='git pull'
alias gps='git push'
alias gpsom='git pull origin master'
alias gplom='git push origin master'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -m'
alias gca='git commit -am'
alias gcam='git commit --amend'
alias gd='git diff'
alias gdc='git diff --cached'
alias gb='git branch'
alias gl='git log'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias rebase_live='git checkout live && git rebase master && git checkout master'
ours (){ git checkout --ours $1; git add $1; }
theirs (){ git checkout --theirs $1; git add $1; }
bind "\"\C- \": \"gca ''\C-b\""  # ctrl+[SPACE] => gca '|'
bind "\"\C-xc\": \"gc ''\C-b\""  # ctrl+x, c    => gc '|'

# -- capistrano commands for each stage
for stage in $(echo "dev preview staging live"); do
  char=`echo $stage | head -c 1`
  alias c$char\d="cap  $stage deploy"
  alias c$char\dm="cap $stage deploy:migrations"
  alias c$char\r="cap  $stage revisions"
  # Push, then deploy
  alias pc$char\d="git push; cap  $stage deploy"
done

# -- rvm / ruby / rails
alias r='rake'
alias gemdir='cd $GEM_HOME/gems'
ensure_bundler() { if ! test $(which bundle); then gem install bundler; fi; }
alias bi="ensure_bundler; bundle install"
alias be="ensure_bundler; bundle exec"

# Run a rails command for either 2.x or 3.x
rails_cmd(){
  char=`echo $1 | head -c 1`
  if [ -e ./script/rails ]; then ./script/rails $char $(echo $@ | sed "s/$1//g" )
  elif [ -e ./script/$1 ]; then ./script/$@
  else echo "== Command not found. (Are you sure this is a rails 2.x or 3.x application?)"
  fi
}
rs() { rails_cmd server -u "$@"; }
rc() { rails_cmd console "$@"; }
rg() { rails_cmd generate "$@"; }

# Automatically invoke bundler for rake, if necessary.
rake() { if [ -e ./Gemfile.lock ]; then bundle exec rake "$@"; else /usr/bin/env rake "$@"; fi; }

# Include configurable bash aliases, if file exists
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# ---------------------------------------------------------
# Alias management (helper functions for ~/.bash_aliases)
# ---------------------------------------------------------

# Adds an alias to ~/.bash_aliases.
# ------------------------------------------------
function add_alias() {
  if [ -n "$1" ] && [ -n "$2" ]; then
    touch ~/.bash_aliases
    echo "alias $1=\"$2\"" >> ~/.bash_aliases
    source ~/.bashrc
  else
    echo "Usage: add_alias <alias> <command>"
  fi
}
# Adds a change directory alias to ~/.bash_aliases.
# Use '.' for current working directory.
# Changes directory, then lists directory contents.
# ------------------------------------------------
function add_dir_alias() {
  if [ -n "$1" ] && [ -n "$2" ]; then
    path=`dirname $2/.`   # Fetches absolute path.
    touch ~/.bash_aliases
    echo "alias $1=\"cd $path; ll\"" >> ~/.bash_aliases
    source ~/.bashrc
  else
    echo "Usage: add_dir_alias <alias> <path>"
  fi
}
# Remove an alias
# ------------------------------------------------
function rm_alias() {
  if [ -n "$1" ]; then
    touch ~/.bash_aliases
    grep -Ev "alias $1=" ~/.bash_aliases > ~/.bash_aliases.tmp
    mv ~/.bash_aliases.tmp ~/.bash_aliases
    unalias $1
    source ~/.bashrc
  else
    echo "Usage: rm_alias <alias>"
  fi
}

