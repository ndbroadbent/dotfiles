#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;

if type git_index > /dev/null 2>&1; then
  echo "SCM Breeze already installed\!"

else
  if [ -n "$GIT_REPO_DIR" ]; then
    install_to="$GIT_REPO_DIR"
  else
    install_to="$HOME/code"
  fi

  mkdir -p "$install_to"

  (
    # Update or clone
    if [ -d "$install_to/scm_breeze" ]; then
      cd "$install_to/scm_breeze" && git pull origin master
    else
      git clone git://github.com/ndbroadbent/scm_breeze.git "$install_to/scm_breeze"
      cd "$install_to/scm_breeze"
    fi

    # Run SCM Breeze install script
    . install.sh

    # If this script was sourced from the terminal, update current shell with SCM Breeze
    if ! [[ "$0" =~ "dev_machine_setup.sh" ]] && [[ "$0" == *bash ]]; then source ~/.bashrc; fi
  )
fi