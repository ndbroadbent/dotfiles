#!/bin/bash
if [ -n "$2" ]; then
  git_name=$1
  git_email=$2
fi
if [ -n "$git_name" ]; then
  echo "== Setting up git config..."
  cat > ~/.gitconfig <<EOF
[user]
	name = $git_name
	email = $git_email
[branch "master"]
	remote = origin
	merge = refs/heads/master
[core]
	editor = vim

[color]
  branch = auto
  diff = auto
  status = auto

[color "branch"]
  current = yellow reverse
  local = yellow
  remote = green

[color "diff"]
  meta = yellow bold
  frag = magenta bold
  old = red bold
  new = green bold

[color "status"]
  added = yellow
  changed = green
  untracked = cyan
EOF
chown $USER:$USER ~/.gitconfig

else
  echo "Usage:  $0 <user name> <user email>"
fi

