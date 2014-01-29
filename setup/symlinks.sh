#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;

echo "== Setting up symlinks (SCM Breeze, *.symlink, ~/bin)..."

# Symlink SCM Breeze example config files, if installed.
if [ -n "$scmbDir" ]; then
  ln -fs "$scmbDir/scmbrc.example" "$HOME/.scmbrc"
  ln -fs "$scmbDir/git.scmbrc.example" "$HOME/.git.scmbrc"
fi

# Symlink any files with .symlink extension
for file in **/*.symlink; do 
  target="$HOME/.$(basename ${file/.symlink})"
  ln -fs "$(greadlink -f $file)" "$target"
done

# Symlink ./bin to home directory
ln -fs "$(greadlink -f bin)" "$HOME"
