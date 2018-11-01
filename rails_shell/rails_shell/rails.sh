# Run Rails commands on any version
rails_cmd() {
  if [ -e ./script/$1 ]; then bundle_install_wrapper "./script/$@"
  elif [ -e ./bin/rails ]; then bundle_install_wrapper "./bin/rails $@"
  elif [ -e ./config.ru ] && grep -q Rails ./config.ru; then bundle_install_wrapper bundle exec rails "$@"
  else echo "== I don't think this is a Rails application!"
  fi
}
is_rails_app() {
  [ -e ./script/rails ] || [ -e ./script/$1 ] || ([ -e ./config.ru ] && grep -q Rails ./config.ru)
}

# This is annoying, don't use it
start_rails_server_on_available_port() {
  for p in $(seq 3000 3099); do
    if ! pgrep -qf "127\.0\.0\.1:$p"; then
      rails_cmd server --binding=127.0.0.1 -p $p "$@"
      break
    fi
  done
}

alias   rs="rails_cmd server --binding=127.0.0.1"
alias  rsd="rails_cmd server -u --binding=127.0.0.1"
alias   rc="rails_cmd console"
alias  rdb="rails_cmd dbconsole"
alias   rg="rails_cmd generate"
alias   ru="rails_cmd runner"

alias   fs="foreman start"

alias crb='crystalball'

# RVM keeps pushing itself to the front of the PATH.
# Workaround is to use functions.
rspec() { if [ -f ./bin/rspec ]; then ./bin/rspec "$@"; else $(which rspec) "$@"; fi }
rails() { if [ -f ./bin/rails ]; then ./bin/rails "$@"; else $(which rails) "$@"; fi }
rake() { if [ -f ./bin/rake ]; then ./bin/rake "$@"; else $(which rake) "$@"; fi }
spring() { if [ -f ./bin/spring ]; then ./bin/spring "$@"; else $(which spring) "$@"; fi }

# Aliases for running Rails on different ports
for p in $(seq 3001 3009); do
  alias "rs$p"="rails_cmd server --binding=127.0.0.1 -p $p"
  alias "rsd$p"="rails_cmd server --binding=127.0.0.1 -u -p $p"
done
