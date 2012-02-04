#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;

# Symlink SCM Breeze example config files, if installed.
if [ -n "$scmbDir" ]; then
  ln -fs "$scmbDir/scmbrc.example" "$HOME/.scmbrc"
  ln -fs "$scmbDir/git.scmbrc.example" "$HOME/.git.scmbrc"
fi
