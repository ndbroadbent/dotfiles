#!/bin/bash
. _shared.sh
if [ -z "$git_name" ]; then prompt_for_git; fi

echo "== Setting up git config..."
cat > ~/.gitconfig <<EOF
[user]
	name = $git_name
	email = $git_email
[core]
	editor = vim -c start

[color]
  branch = auto
  diff = auto
  status = always

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

