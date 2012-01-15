#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;

# If name was passed in ENV variable, use it
if [ -z "$git_name" ]; then
  # Check for existing git config
  git_name=$(git config --get user.name)
  git_email=$(git config --get user.email)
  github_user=$(git config --get github.user)
  github_token=$(git config --get github.token)
  
  # If still no name, prompt.
  if [ -z "$git_name" ] || [ -z "$git_email" ]; then
    prompt_for_git
  fi
fi

echo "== Setting up git config..."
echo "   name: '$git_name',  email: '$git_email' "
echo "   github user: '$github_user',  github token: '$github_token'"
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
