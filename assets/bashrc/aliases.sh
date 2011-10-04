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
alias ...='cd ../..';
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias n='nautilus .'
function g() { gedit $1 2>&1 > /dev/null & }
alias ak='ack-grep'

# -- apt
alias apt-install='sudo apt-get install -y'
alias apt-search='apt-cache search'

# -- git
alias gpl='git pull'
alias gps='git push'
alias gpsom='git pull origin master'
alias gplom='git push origin master'
alias gf='git fetch'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -m'
alias gca='git commit -am'
alias gcm='git commit --amend'
alias gcmh='git commit --amend -C HEAD'  # Amend commit without changing message
alias gcamh='git add -A; git commit --amend -C HEAD'  # Add everything, amend latest commit
alias gsh='git show'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log'
alias gco='git checkout'
alias gcl='git clone'
alias gb='git branch'
alias gm='git merge'
alias grb='git rebase'
alias gcp='git cherry-pick'
alias gr='git remote'
alias rebase_live='git checkout live && git rebase master && git checkout master'
ours (){ git checkout --ours $1; git add $1; }
theirs (){ git checkout --theirs $1; git add $1; }

# Ctrl~>[space] or Ctrl~>x~>[space] gives a git commit prompt,
# where you don't have to worry about escaping anything.
# See here for more info about why this is cool: http://qntm.org/bash#sec1
git_prompt(){ read -e -p "Commit message for '$1': " git_msg; echo $git_msg | $1 -F -; }
case "$TERM" in
xterm*|rxvt*)
    bind "\"\C- \":  \"git_prompt 'git commit -a'\n\""
    bind "\"\C-x \": \"git_prompt 'git commit'\n\""
    ;;
esac

# Attach git tab completion to aliases
complete -o default -o nospace -F _git_pull gpl
complete -o default -o nospace -F _git_push gps
complete -o default -o nospace -F _git_fetch gf
complete -o default -o nospace -F _git_branch gb
complete -o default -o nospace -F _git_rebase grb
complete -o default -o nospace -F _git_merge gm
complete -o default -o nospace -F _git_log gl
complete -o default -o nospace -F _git_checkout gco
complete -o default -o nospace -F _git_remote gr
complete -o default -o nospace -F _git_show gs

# -- update and deploy CR branch.
alias update_cr="gco crossroads; git merge master; git push; cap deploy; gco master"

# -- capistrano commands for each stage
for stage in dev preview staging live; do
  char=`echo $stage | head -c 1`
  alias c$char\d="cap  $stage deploy"
  alias c$char\dm="cap $stage deploy:migrations"
  alias c$char\r="cap  $stage revisions"
  # Push, then deploy
  alias pc$char\d="git push; cap  $stage deploy"
done
alias cdp='cap deploy'


# -- rvm / ruby / rails
alias r='rake'
alias gemdir='cd $GEM_HOME/gems'
ensure_bundler() { if ! test $(which bundle); then gem install bundler; fi; }
alias bi="ensure_bundler; bundle install"
alias be="ensure_bundler; bundle exec"
# Automatically invoke bundler for rake, if necessary.
# (uses file_exists_inverse_recursive function from 'functions.sh')
rake() {
  if $(file_exists_inverse_recursive Gemfile); then
    bundle exec rake "$@"
  else
    /usr/bin/env rake "$@"
  fi
}

# RVM ruby versions
alias 192='rvm use ruby-1.9.2'
alias 187='rvm use ruby-1.8.7'
alias 186='rvm use ruby-1.8.6'
alias jr='rvm use jruby'

# Use the same rails command for both 2.x and 3.x
rails_cmd(){
  if [ -e ./script/rails ]; then ./script/rails $@
  elif [ -e ./script/$1 ]; then ./script/$@
  else echo "== Command not found. (Are you sure this is a rails 2.x or 3.x application?)"
  fi
}
rs() { rails_cmd server "$@"; }
rc() { rails_cmd console "$@"; }
rg() { rails_cmd generate "$@"; }


# -------------------------------------------------
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

