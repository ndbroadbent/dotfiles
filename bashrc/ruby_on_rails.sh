# bundler
ensure_gem() { if ! gem list $1 | grep -q $1; then gem install $1; fi; }
alias b="ensure_gem bundler; bundle"
alias bu="ensure_gem bundler; bundle update"
# rubygems
alias gmi="gem install"
alias gml="gem list"
alias gmb="gem build"

# Use bundler for commands, if Gemfile is present
bundle_exec_if_possible() {
  ensure_gem bundler
  if find_in_cwd_or_parent Gemfile > /dev/null; then
    bundle_install_wrapper bundle exec "$@"
  else
    /usr/bin/env "$@"
  fi
}
alias be="bundle_exec_if_possible"

# Alias most rails commands to use the bundle exec wrapper
for c in cap cucumber rspec spec spork tane thin unicorn unicorn_rails; do
  alias $c="bundle_exec_if_possible $c"
done

# Run Rails commands on any version
rails_cmd(){
  # Rails 3
  if [ -e ./script/rails ]; then bundle_install_wrapper rails3_with_editor $@
  # Rails <= 2
  elif [ -e ./script/$1 ]; then bundle_install_wrapper ./script/$@
  # Rails 4
  elif [ -e ./config.ru ] && grep -q Rails config.ru; then bundle_install_wrapper rails $@
  else echo "== I don't think this is a Rails application!"
  fi
}
alias   rs="rails_cmd server"
alias  rsd="rails_cmd server -u"
alias   rc="rails_cmd console"
alias   rg="rails_cmd generate"
rge()     { rails_cmd generate "$@" --editor; }
rgm()     { rails_cmd generate migration "$@" --editor; }

# If a bundler exits with status '7' (GemNotFound),
# then run 'bundle install' and try again.
bundle_install_wrapper() {
  # Run command
  eval "$@"
  if [ $? = 7 ]; then
    # If command crashes, try a bundle install
    echo -e "\033[1;31m'$@' failed with exit code 7."
    echo    "This probably means that your system is missing gems defined in your Gemfile."
    echo -e "Executing 'bundle install'...\033[0m"
    bundle install
    # If bundle install was successful, try running command again.
    if [ $? = 0 ]; then
      echo "'bundle install' was successful. Retrying '$@'..."
      eval "$@"
    fi
  fi
}

# Aliases for running Rails on different ports
for p in $(seq 1 9); do
  alias "rs$p"="rails_cmd server -p 300$p"
  alias "rsd$p"="rails_cmd server -u -p 300$p"
done

# Start passenger
alias pst="passenger start"

# Tab completion without trailing space, for adding line number filtering. e.g. :23
complete -o nospace -f rspec
complete -o nospace -f cucumber


# Capistrano aliases for each stage
for stage in staging production; do
  char=`echo $stage | head -c 1`
  alias  c$char\d="cap $stage deploy"
  alias c$char\dm="cap $stage deploy:migrations"
  alias  c$char\l="cap $stage deploy:lock"
  alias  c$char\u="cap $stage deploy:unlock"
  alias  c$char\r="cap $stage deploy:revisions"
  # Push, then deploy
  alias pc$char\d="git push; cap  $stage deploy"
done
alias cdp='cap deploy'

# RAILS_ENV aliases
alias  redev="RAILS_ENV=development"
alias retest="RAILS_ENV=test"
alias reprod="RAILS_ENV=production"


# Rake aliases
alias r="rake"
# Run all rake commands with bundle exec, and --trace flag
alias rake="bundle_exec_if_possible rake"
alias rdbc="rake db:create"
alias rdbd="rake db:drop"
alias rdbm="rake db:migrate"
alias  rsp="rake spec"
alias  rts="rake test"
alias  rdp="rake deploy"

# RVM
alias rvmi='rvm install'
alias rvml='rvm list'
alias rvmgl='rvm gemset list'
alias rvmp='rvm pkg'
# -- ruby versions
alias r193='rvm use 1.9.3'
alias r192='rvm use 1.9.2'
alias r187='rvm use 1.8.7'
alias r186='rvm use 1.8.6'
alias  rjr='rvm use jruby'

alias gemdir='cd $GEM_HOME/gems'

alias gu="guard"

alias vu="vagrant up"
alias vs="vagrant ssh"
alias vr="vagrant reload"
alias vh="vagrant halt"

# Gem development shortcuts
# Toggle between gem development and production mode
# (Set / unset $GEM_DEV variable)
gdv() {
  local flag_var="GEM_DEV"
  if env | grep -q "^$flag_var="; then
    unset $flag_var
  else
    export $flag_var=true
  fi
}


# Tab completion for cached Rails commands (Rake, Capistrano, etc.)

function _cached_task_completion() {
  # Do nothing if cache file doesn't exist.
  if ! [ -e "$1" ]; then return 0; fi
  local cur
  # Don't treat ':' as a word-break character
  _get_comp_words_by_ref -n : cur
  COMPREPLY=( $(compgen -W "$(cat "$1")" -- $cur) )
  # Remove matches from LHS
  __ltrim_colon_completions "$cur"
}
function _cached_rake_task_completion() { _cached_task_completion ".cached_rake_tasks~"; }
function _cached_cap_task_completion()  { _cached_task_completion ".cached_cap_tasks~"; }

complete -F _cached_rake_task_completion rake r
complete -F _cached_cap_task_completion cap
