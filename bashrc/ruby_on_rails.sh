rge()     { rails_cmd generate "$@" --editor; }
rgm()     { rails_cmd generate migration "$@" --editor; }

alias rubomaster="be rubocop \$(git diff HEAD..origin/master --name-only | grep '\.rb')"
alias rubomain="be rubocop \$(git diff HEAD..origin/main --name-only | grep '\.rb')"

export THOR_MERGE="code -d \$1 \$2"

alias ro="bundle_exec_if_possible rspec --only-failures"
alias rf='bundle_exec_if_possible rspec --next-failure'
alias rch='bundle_exec_if_possible rspec $(git ls-files --modified --others spec | grep "_spec\.rb$")'
alias rt='bundle_exec_if_possible rspec'
