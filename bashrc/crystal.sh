# Use ./bin/crystal during development of the Crystal language
alias crystal="CRYSTAL_BIN=\$([ -f ./bin/crystal ] && echo ./bin/crystal || echo \$(which crystal)); \$CRYSTAL_BIN"
