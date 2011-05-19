#!/bin/bash
if [ -n "$2" ]; then
  git_name=$1
  git_email=$2
  echo "== Setting up git and ssh..."
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
  git config --global branch.master.remote origin
  git config --global branch.master.merge refs/heads/master
  git config --global core.editor vim  
  ssh-keygen -t rsa -C "$git_email"
  echo "===== Done."
else
  echo "Usage:  $0 <user name> <user email>"
fi

