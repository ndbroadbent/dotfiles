#!/bin/bash
. _shared.sh

# If name was passed in ENV variable, use it
if [ -z "$git_name" ]; then
  # Check for existing git config
  git_name=$(git config --get user.name)
  git_email=$(git config --get user.email)
  github_user=$(git config --get github.user)
  # If still no name, prompt.
  if [ -z "$git_name" ]; then
    prompt_for_git
  fi
fi

echo "== Setting up git config..."
echo "   Name: $git_name    |    email: $git_email    |    github user: $github_user"
# Add user to gitconfig
cat > ~/.gitconfig <<EOF
[user]
  name = $git_name
  email = $git_email

[github]
  user = $github_user

EOF

# Add the rest of assets/gitconfig
cat assets/gitconfig >> ~/.gitconfig
