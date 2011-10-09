alias r='rake'
alias gemdir='cd $GEM_HOME/gems'

# -- bundler
ensure_bundler() { if ! type bundle > /dev/null 2>&1; then gem install bundler; fi; }
alias bi="ensure_bundler; bundle install"
# Always invoke bundler for rake, if necessary.
# (uses file_exists_inverse_recursive function from 'functions.sh')
be() {
  ensure_bundler
  if exists_in_cwd_or_parent Gemfile; then bundle exec "$@"; else /usr/bin/env "$@"; fi
}
# Test whether file exists in current or parent directories
exists_in_cwd_or_parent() {
  local slashes=${PWD//[^\/]/}; local directory=$PWD;
  for (( n=${#slashes}; n>0; --n )); do
    test -e $directory/$1 && return 0
    directory=$directory/..
  done; return 1
}
# Alias most rails commands to use the be() bundle exec wrapper
for c in cucumber heroku rackup rails rake rspec shotgun spec spork thin unicorn unicorn_rails; do
  alias $c="be $c"
done


# Run rails commands on either 2.x and 3.x
rails_cmd(){
  if [ -e ./script/rails ]; then ./script/rails $@
  elif [ -e ./script/$1 ]; then ./script/$@
  else echo "== Command not found. (Are you sure this is a rails 2.x or 3.x application?)"
  fi
}
rs() { rails_cmd server "$@"; }
rc() { rails_cmd console "$@"; }
rg() { rails_cmd generate "$@"; }


# Capistrano aliases for each stage
for stage in dev preview staging live; do
  char=`echo $stage | head -c 1`
  alias c$char\d="cap  $stage deploy"
  alias c$char\dm="cap $stage deploy:migrations"
  alias c$char\r="cap  $stage revisions"
  # Push, then deploy
  alias pc$char\d="git push; cap  $stage deploy"
done
alias cdp='cap deploy'


# RVM ruby versions
alias 192='rvm use ruby-1.9.2'
alias 187='rvm use ruby-1.8.7'
alias 186='rvm use ruby-1.8.6'
alias jr='rvm use jruby'

