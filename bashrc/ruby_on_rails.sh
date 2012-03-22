# bundler
ensure_gem() { if ! gem list $1 | grep -q $1; then gem install $1; fi; }
alias bi="ensure_gem bundler; bundle install"
alias bu="ensure_gem bundler; bundle update"
# rubygems
alias gmi="gem install"
alias gml="gem list"
alias gmb="gem build"

# Use bundler for commands, if Gemfile is present
bundle_exec_if_possible() {
  ensure_gem bundler
  if find_in_cwd_or_parent Gemfile > /dev/null; then
    bundle exec "$@"
  else
    /usr/bin/env "$@"
  fi
}
alias be="bundle_exec_if_possible"

# Alias most rails commands to use the bundle exec wrapper
for c in cap cucumber rspec spec spork thin unicorn unicorn_rails; do
  alias $c="bundle_exec_if_possible $c"
done

# Run rails commands on either 2.x and 3.x
rails_cmd(){
  if [ -e ./script/rails ]; then ./script/rails $@
  elif [ -e ./script/$1 ]; then ./script/$@
  else echo "== Command not found. (Are you sure this is a rails 2.x or 3.x application?)"
  fi
}
alias   rs="rails_cmd server"
alias  rsd="rails_cmd server -u"
alias  rst="rails_cmd server thin"
alias rstd="rails_cmd server thin -u"
alias   rc="rails_cmd console"
alias   rg="rails_cmd generate"

# Start passenger
alias pst="passenger start"

# Tab completion without trailing space, for adding line number filtering. e.g. :23
complete -o nospace -f rspec
complete -o nospace -f cucumber


# Capistrano aliases for each stage
for stage in dev preview staging live; do
  char=`echo $stage | head -c 1`
  alias  c$char\d="cap $stage deploy"
  alias c$char\dm="cap $stage deploy:migrations"
  alias  c$char\r="cap $stage revisions"
  # Push, then deploy
  alias pc$char\d="git push; cap  $stage deploy"
done
alias cdp='cap deploy'

# RAILS_ENV aliases
alias  redev="RAILS_ENV=development"
alias retest="RAILS_ENV=test"
alias reprod="RAILS_ENV=production"


# Rake aliases
alias    r="rake"
# Run all rake commands with bundle exec, and --trace flag
alias rake="bundle_exec_if_possible rake --trace"
alias rdbc="rake db:create"
alias rdbd="rake db:drop"
alias rdbm="rake db:migrate"
alias  rsp="rake spec"
alias  rts="rake test"


# RVM ruby versions
alias 192='rvm use ruby-1.9.2'
alias 187='rvm use ruby-1.8.7'
alias 186='rvm use ruby-1.8.6'
alias  jr='rvm use jruby'

alias gemdir='cd $GEM_HOME/gems'

alias gu="guard"

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
