#!/bin/bash
echo "== Installing ~/.bashrc ..."
this_dir=$(pwd)

IFS=" "

bashrc_parts="auto_reload default functions aliases prompt tab_completion ruby_on_rails crossroads"

# Header
cat > ~/.bashrc <<EOF
# Export path of dotfiles repo
export DOTFILES_PATH="$this_dir"
export PROMPT_COMMAND=""

EOF

for part in $bashrc_parts; do
  if [ "$1" = "copy" ]; then
    # Assemble bashrc from parts
    cat assets/bashrc/$part.sh >> ~/.bashrc
  else
    # Source bashrc from parts
    echo "source \"\$DOTFILES_PATH/bashrc/$part.sh\"" >> ~/.bashrc
  fi
done

# Footer
cat >> ~/.bashrc <<EOF

# This loads SCM Breeze into the shell session.
[[ -s "$HOME/.scm_breeze/scm_breeze.sh" ]] && . "$HOME/.scm_breeze/scm_breeze.sh"

# Set bashrc autoreload variable at start
export BASHRC_LAST_UPDATED="\$(bashrc_last_modified)"

# Update this file from GitHub
alias pull_bashrc='cd $this_dir && git pull origin master && . bashrc_setup.sh && cd -'

# Finalize auto_reload sourced files
finalize_auto_reload
EOF


# If this script was sourced from the terminal, update current shell
if ! [[ "$0" =~ "dev_machine_setup.sh" ]] && [[ "$0" == *bash ]]; then source ~/.bashrc; fi

IFS=$' \t\n'
