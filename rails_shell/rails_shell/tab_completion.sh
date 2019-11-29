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
function _cached_rake_task_completion() { _cached_task_completion "$RAKE_COMP_FILE"; }
function _cached_cap_task_completion()  { _cached_task_completion "$CAP_COMP_FILE"; }

complete -F _cached_rake_task_completion rake r
complete -F _cached_cap_task_completion cap

# Tab completion without trailing space
complete -o nospace -f rspec
complete -o nospace -f cucumber


# Rails commands
# ------------------

__railscomp(){
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $( compgen -W "$1" -- "$cur" ) )
}

#
# @param $1 Name of variable to return result to
# @param $2 Command list
# __railscmd(){
#   any_command=$(echo $2 | sed -e 's/[[:space:]]/|/g')
#   for (( i=0; i < ${#COMP_WORDS[@]}-1; i++ )); do
#     if [[ ${COMP_WORDS[i]} == @($any_command) ]]; then
#       eval $1="${COMP_WORDS[i]}"
#     fi
#   done
# }

__rails_env(){
  __railscomp "{-e,--environment=}{test,development,staging,sandbox,production}"
}

__rails_database(){
  __railscomp "{-d,--database=}{mysql,oracle,postgresql,sqlite3,frontbase,ibm_db,jdbcmysql,jdbcsqlite3,jdbcpostgresql,jdbc}"
}

#
# @param $1 Field's name
__rails_types(){
  __railscomp "${1%:*}:{string,text,integer,float,decimal,datetime,timestamp,date,time,binary,boolean,references,index,uniq}"
}

__rails_new(){
  local cur prev
  _get_comp_words_by_ref cur prev

  case "$cur" in
    -d*|--database=*)
      __rails_database
      return
      ;;
    --ruby=*|--builder=*|--template=*)
      _filedir
      return
      ;;
    -*) __railscomp "$1" ;;
  esac

  _filedir
}

# end of helper functions ------------------------------------------------------


# generators -------------------------------------------------------------------
__rails_generators_opts(){
  echo "
    require 'yaml'
    generator = '$1'
    generators_opts = YAML.load_file('${RAILS_G_COMP_FILE}')
    opts = generator.empty? ? generators_opts.keys : generators_opts[generator]
    opts.each { |opt| puts opt }
  " | ruby
}

__rails_generators(){
  if [ -e "$RAILS_G_COMP_FILE" ]; then
    __railscomp "$(__rails_generators_opts)"
  fi
}

__rails_generator_options(){
  local cur
  _get_comp_words_by_ref cur

  if [[ $cur == *:* ]]; then
    __rails_types "$cur"
  else
    __railscomp "$(__rails_generators_opts $1)"
  fi
}

#
# @param $1 file's path
# @param $2 filename suffix
# @param $3 name's suffix
# @param $4 kind. Defaults to class.
__rails_destroy(){
  local cur
  _get_comp_words_by_ref cur

  case "$cur" in
    -*) __railscomp "--pretend --force --skip --quiet" ;;
    *) __railscomp "$(find "$1" -name "*$2.rb" -exec grep ".*${4-class}.*$3.*" {} \; \
                  | awk '{ print $2 }' | sed s/$3$//g)" ;;
  esac
}

# end of generators ------------------------------------------------------------


# rails commands ---------------------------------------------------------------

_rails_new(){
  if [ "${COMP_WORDS[1]}" == "plugin" ]; then
    __rails_new "--ruby= --builder= --template=
      --skip-gemfile --skip-bundle --skip-git --skip-active-record --skip-sprockets
      --database= --javascript= --skip-javascript --dev --edge --skip-test-unit
      --old-style-hash --dummy-path= --full --mountable --skip-gemspec
      --force --pretend --quiet --skip --help"
  else
    __rails_new "--ruby= --builder= --template=
      --skip-gemfile --skip-bundle --skip-git --skip-active-record --skip-sprockets
      --database= --javascript= --skip-javascript --dev --edge --skip-test-unit
      --old-style-hash --force --pretend --quiet --skip --help"
  fi
}

_rails_plugin(){
  if [[ -f "script/rails" ]]; then
    __railscomp "--help --verbose --root= install remove"
  else
    __railscomp "new"
  fi
}

_rails_server(){
  local cur prev
  _get_comp_words_by_ref cur prev

  case "$cur" in
    -e*|--environment=*)
      __rails_env
      return
      ;;
  esac

  case "$prev" in
    --config=*|--pid=*) _filedir ;;
    *) __railscomp "--help --pid= -e --environment= --debugger --daemon --config= --binding= --port=" ;;
  esac
}

_rails_console(){
  __railscomp "test development production --sandbox --debugger --help"
}

_rails_dbconsole(){
  local environment

  __railscmd environment "test development production"

  if [ -z "$environment" ]; then
    __railscomp "test development production"
  else
    __railscomp "--include-password --header --mode"
  fi
}

_rails_generate(){
  local cur generator generators
  _get_comp_words_by_ref cur

  generators=$(test -f "$RAILS_G_COMP_FILE" && __rails_generators_opts)
  __railscmd generator "$generators"

  if [ -z "$generator" ]; then
    case "$cur" in
      -*) __railscomp "--help" ;;
      *) __rails_generators ;;
    esac
    return
  fi

  __rails_generator_options "$generator"
}

_rails_destroy(){
  local cur generator generators
  _get_comp_words_by_ref cur

  generators=$(test -f "$RAILS_G_COMP_FILE" && __rails_generators_opts)
  __railscmd generator "$generators"

  if [ -z "$generator" ]; then
    case "$cur" in
      -*) __railscomp "--help" ;;
      *) __rails_generators ;;
    esac
    return
  fi

  case "$generator" in
    model|scaffold|resource) __rails_destroy "app/models/" ;;
    migration|session_migration) __rails_destroy "db/migrate/" ;;
    mailer) __rails_destroy "app/mailers/" ;;
    observer) __rails_destroy "app/models/" "_observer" "Observer" ;;
    controller|scaffold_controller) __rails_destroy "app/controllers/" "_controller" "Controller" ;;
    helper) __rails_destroy "app/helpers/" "_helper" "Helper" "module" ;;
    integration_test) __rails_destroy "test/integration/" "_test" "Test" ;;
    performance_test) __rails_destroy "test/performance/" "_test" "Test" ;;
    generator) __rails_destroy "lib/generators/" "_generator" "Generator" ;;
    *) __railscomp "--pretend --force --skip --quiet" ;;
  esac
}

_rails_runner(){
  local cur prev
  _get_comp_words_by_ref cur prev

  case "$cur" in
    -e*|--environment=*)
      __rails_env
      return
      ;;
  esac

  case "$prev" in
    *) __railscomp "--help -e --environment=" ;;
  esac
}

_rails_profiler(){
  local cur prev
  _get_comp_words_by_ref cur

  case "$cur" in
    -*) __railscomp "--help --runs --output --metrics --formats" ;;
    *) COMPREPLY=() ;;
  esac
}

_rails_benchmarker(){
  local cur prev
  _get_comp_words_by_ref cur

  case "$cur" in
    -*) __railscomp "--help --runs --output --metrics" ;;
    *) COMPREPLY=() ;;
  esac
}

# end of rails commands --------------------------------------------------------
_rails(){
  local cur options command commands
  _get_comp_words_by_ref cur

  options="--help --version"
  if [[ -f "script/rails" ]]; then
    commands="s server c console g generate d destroy r runner profiler plugin benchmarker db dbconsole"
  else
    commands="new plugin"
  fi

  __railscmd command "$commands"

  if [ -z "$command" ]; then
    case "$cur" in
      -*) __railscomp "$options" ;;
      *) __railscomp "$commands" ;;
    esac
    return
  fi

  case "$command" in
    new)          _rails_new ;;
    plugin)       _rails_plugin ;;
    s|server)     _rails_server ;;
    c|console)    _rails_console ;;
    db|dbconsole) _rails_dbconsole ;;
    g|generate)   _rails_generate ;;
    d|destroy)    _rails_destroy ;;
    r|runner)     _rails_runner ;;
    profiler)     _rails_profiler ;;
    benchmarker)  _rails_benchmarker ;;
    *) COMPREPLY=() ;;
  esac
}

complete -o default -o nospace -F _rails rails
complete -o default -o nospace -F _rails_server rs rsd
complete -o default -o nospace -F _rails_console rc
complete -o default -o nospace -F _rails_generate rg
