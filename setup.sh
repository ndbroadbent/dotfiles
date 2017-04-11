#!/bin/bash
. setup/_shared.sh
# This bash script will set up (or update) your development environment.

scripts=""

if [[ $EUID -eq 0 ]]; then
  echo -e "\e[01;31mPlease do not use sudo to run this script!\e[00m" 2>&1
  exit 1
fi

echo -e "
---------------------------------
| Mac Developer Setup Script |
---------------------------------\n"

# Prerequisites
# -------------------------------------
# Requires root permissions (requests password here)
sudo true

# '--all' flag installs everything
if [ "$1" = "--all" ]; then
  echo "== Setting up default environment..."
  scripts="packages bashrc git_config rvm rvm_hooks "
  prompt_for_git

# '--update' flag updates everything that doesn't require user input
elif [ "$1" = "--update" ]; then
  echo "== Running default update..."
  scripts="packages bashrc rvm_hooks "

# If no flag given, ask user which scripts they would like to run.
else
  confirm_by_default "Git config" 'git_config'
  if [[ "$scripts" =~ "git_config" ]]; then prompt_for_git; fi # prompt for git user details

  confirm_by_default "Brew packages"                'packages'
  confirm_by_default "Dotfiles (bashrc, etc.)"      'bashrc'
  confirm_by_default "SCM Breeze"                   'scm_breeze'
  confirm_by_default "RVM (Ruby Version Manager)"   'rvm'
  confirm_by_default "RVM Hooks (symlink to current gemset)" 'rvm_hooks'
fi

scripts=`echo $scripts`  # Remove line-breaks
echo -e "\n===== Executing the following scripts:"
echo -e   "      [ $scripts ]\n"


# Include each configured script
# --------------------------------------------------------------
for script in $scripts; do
  source setup/$script.sh
done

echo -e "\n===== Development machine has been set up!\n"

