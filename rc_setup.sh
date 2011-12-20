#!/bin/bash
echo "== Installing ~/.bashrc & other related dot files..."
this_dir=$(pwd)

IFS=" "

bashrc_parts="default prompt aliases functions ruby_on_rails crossroads"
rc_files="inputrc ackrc irbrc livereload"

cat /dev/null > ~/.bashrc

for part in $bashrc_parts; do
  if [ "$1" = "copy" ]; then
    # Assemble bashrc from parts
    cat assets/bashrc/$part.sh >> ~/.bashrc
  else
    # Source bashrc from parts
    echo "source '$this_dir/assets/bashrc/$part.sh'" >> ~/.bashrc
  fi
done

# Add scm_breeze
echo '[[ -s "$HOME/.scm_breeze/scm_breeze.sh" ]] && . "$HOME/.scm_breeze/scm_breeze.sh"' >> ~/.bashrc

# Export ubuntu_config_path
echo "export UBUNTU_CONFIG_PATH=\"$this_dir\"" >> ~/.bashrc

# Append dynamic update command
cat >> ~/.bashrc <<EOF
# Update this file from GitHub
alias pull_bashrc='cd $this_dir && git pull origin master && . bashrc_setup.sh && cd -'
EOF

for rc in $rc_files; do
  rm -f ~/.$rc
  if [ "$1" = "copy" ]; then
    # Copy other *rc files
    cp -f "$this_dir/assets/$rc" "$HOME/.$rc"
  else
    # Symlink other *rc files
    ln -fs "$this_dir/assets/$rc" "$HOME/.$rc"
  fi
done


# If run from dev_machine_setup, we cannot update current shell.
if ! [[ "$0" =~ "dev_machine_setup.sh" ]]; then
  # If this script was sourced properly from the terminal, update current shell
  if [[ "$0" == *bash ]]; then
    source ~/.bashrc
  else
    echo "===== Please run this command to update your current shell: $ source ~/.bashrc"
    echo "      In the future, you should run this script like this:  $ . bashhrc_setup.sh"
  fi
fi

unset IFS
