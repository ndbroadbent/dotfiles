#!/bin/bash
# Use ./bin/crystal during development of the Crystal language
export PKG_CONFIG_PATH=/opt/homebrew/opt/openssl/lib/pkgconfig
alias crystal="CRYSTAL_BIN=\$([ -f ./bin/crystal ] && echo ./bin/crystal || echo \$(which crystal)); \$CRYSTAL_BIN"
