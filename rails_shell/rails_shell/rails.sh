# Run Rails commands on any version
rails_cmd() {
  if [ -e ./script/"$1" ]; then bundle_install_wrapper "./script/$@"
  elif [ -e ./bin/rails ]; then bundle_install_wrapper "./bin/rails $@"
  elif [ -e ./config.ru ] && grep -q Rails ./config.ru; then bundle_install_wrapper bundle exec rails "$@"
  else echo "== I don't think this is a Rails application!"
  fi
}

# This is annoying, don't use it
start_rails_server_on_available_port() {
  for p in $(seq 3000 3099); do
    if ! pgrep -qf "127\.0\.0\.1:$p"; then
      rails_cmd server --binding=127.0.0.1 -p "$p" "$@"
      break
    fi
  done
}

alias   rs="rails_cmd server --binding=127.0.0.1"
alias  rsd="rails_cmd server -u --binding=127.0.0.1"
alias   rc="rails_cmd console"
alias  rdb="rails_cmd dbconsole"
alias   rgn="rails_cmd generate"
alias   ru="rails_cmd runner"

alias   fs="foreman start"

alias crb='crystalball'

export PARALLEL_TEST_PROCESSORS=8
parallel_rspec() {
  if [ -f ./bin/parallel_rspec ]; then ./bin/parallel_rspec "$@";
  else $(which parallel_rspec) "$@"; fi
}
alias prs=parallel_rspec

# Aliases for running Rails on different ports
for p in $(seq 3001 3009); do
  alias "rs$p"="rails_cmd server --binding=127.0.0.1 -p $p"
  alias "rsd$p"="rails_cmd server --binding=127.0.0.1 -u -p $p"
done
