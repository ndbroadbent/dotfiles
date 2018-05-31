# Run Rails commands on any version
rails_cmd(){
  # Rails 3
  if [ -e ./script/rails ]; then bundle_install_wrapper bundle exec rails3_with_editor "$@"
  # Rails <= 2
  elif [ -e ./script/$1 ]; then bundle_install_wrapper "./script/$@"
  # Rails 4
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

alias   rs="rails_cmd server"
alias  rsd="rails_cmd server -u"
alias   rc="rails_cmd console"
alias  rdb="rails_cmd dbconsole"
alias   rg="rails_cmd generate"
alias   ru="rails_cmd runner"

# Aliases for running Rails on different ports
for p in $(seq 3001 3009); do
  alias "rs$p"="rails_cmd server --binding=127.0.0.1 -p $p"
  alias "rsd$p"="rails_cmd server --binding=127.0.0.1 -u -p $p"
done
