# Rake aliases
alias r="bundle_install_wrapper rake"
# Run all rake commands with bundle exec, and --trace flag
alias rake="bundle_install_wrapper rake"
alias rdc="bundle_install_wrapper  rake db:create"
alias rdp="bundle_install_wrapper  rake db:drop"
alias rdm="bundle_install_wrapper  rake db:migrate"
alias rdu="bundle_install_wrapper  rake db:migrate:up"
alias rdd="bundle_install_wrapper  rake db:migrate:down"
alias rdr="bundle_install_wrapper  rake db:rollback"
alias rdtp="bundle_install_wrapper rake db:test:prepare"
alias  rsp="bundle_install_wrapper test_rake spec"
alias  rts="bundle_install_wrapper test_rake test"

# Aliases for https://github.com/grosser/parallel_tests
alias rps="bundle_install_wrapper test_rake parallel:spec[$ACTUAL_CPU_CORES]"
alias rpl="bundle_install_wrapper test_rake parallel:load_schema[$ACTUAL_CPU_CORES]"
alias rpls="bundle_install_wrapper test_rake parallel:load_schema[$ACTUAL_CPU_CORES] parallel:spec[$ACTUAL_CPU_CORES]"
