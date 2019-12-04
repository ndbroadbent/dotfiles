#!/bin/bash
if [ -d "$HOME/code/scm_breeze" ]; then
  echo "SCM Breeze is already installed!"
else
  mkdir -p "$HOME/code"
  (
    cd "$HOME/code"
    git clone git://github.com/ndbroadbent/scm_breeze.git scm_breeze
    cd scm_breeze
    source install.sh
  )
fi
