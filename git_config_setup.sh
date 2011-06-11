#!/bin/bash
if [ -n "$2" ]; then
  git_name=$1
  git_email=$2
fi
if [ -n "$git_name" ]; then
  echo "== Setting up git config..."
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
  git config --global branch.master.remote origin
  git config --global branch.master.merge refs/heads/master
  git config --global core.editor vim

  # Git colors
  cat >> ~/.gitconfig <<EOF
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

else
  echo "Usage:  $0 <user name> <user email>"
fi

