#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;

echo "== Setting up git config..."

# If name was passed in ENV variable, use it
if [ -z "$git_name" ]; then
  prompt_for_git
fi

# Add user to gitconfig
cat > ~/.gitconfig <<EOF
[user]
  name = $git_name
  email = $git_email

[github]
  user = $github_user
  token = $github_token

EOF

# Add the rest of gitconfig
cat git/gitconfig >> ~/.gitconfig
