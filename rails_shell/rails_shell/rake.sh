# Rake aliases
alias r="bundle_exec_if_possible rake"
# Run rake commands with bundle exec (when there is a Gemfile)
alias rdc="bundle_exec_if_possible rake db:create"
alias rdp="bundle_exec_if_possible rake db:drop"
alias rdm="bundle_exec_if_possible rake db:migrate"
alias rdu="bundle_exec_if_possible rake db:migrate:up"
alias rdd="bundle_exec_if_possible rake db:migrate:down"
alias rdr="bundle_exec_if_possible rake db:rollback"
alias rdtp="bundle_exec_if_possible rake db:test:prepare"
alias  rsp="bundle_install_wrapper test_rake spec"
alias  rts="bundle_install_wrapper test_rake test"

# Aliases for https://github.com/grosser/parallel_tests
alias rps="bundle_install_wrapper test_rake parallel:spec[$ACTUAL_CPU_CORES]"
alias rpl="bundle_install_wrapper test_rake parallel:load_schema[$ACTUAL_CPU_CORES]"
alias rpls="bundle_install_wrapper test_rake parallel:load_schema[$ACTUAL_CPU_CORES] parallel:spec[$ACTUAL_CPU_CORES]"
