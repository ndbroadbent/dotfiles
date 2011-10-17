# This loads Git Breeze into the shell session.
exec_string='[[ -s "$HOME/.git_breeze/git_breeze.sh" ]] && . "$HOME/.git_breeze/git_breeze.sh"'

# Add line to bashrc and zshrc if not already present.
for rc in bashrc zshrc; do
  if [[ -s "$HOME/.$rc" ]] && ! grep -q "$exec_string" "$HOME/.$rc"; then
    echo -e "\n$exec_string" >> "$HOME/.$rc"
  fi
done

