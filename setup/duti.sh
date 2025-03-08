#? /bin/bash
#
# Change default editor for the listed filetypes on MacOS.
# Required duti to be installed. `brew install duti`

extensions=(
  public.plain-text
  public.unix-executable
  .c
  .cpp
  .cs
  .css
  .env
  .erb
  .go
  .haml
  .hbs
  .hs
  .java
  .js
  .jsx
  .json
  .lock
  .map
  .md
  .php
  .py
  .rb
  .rbi
  .rbs
  .rake
  Gemfile
  Procfile
  Rakefile
  .gemspec
  .lock
  .sass
  .scss
  .sh
  .fish
  .svg
  .tf
  .tfstate
  .ts
  .tsx
  .txt
  .xml
  .yaml
  .yml
  .zsh
)
vscodeinsiders=com.microsoft.VSCodeInsiders
vscode=com.microsoft.VSCode
cursor=com.todesktop.230313mzl4w4u92
windsurf=com.exafunction.windsurf
atom=com.github.atom
sublime2=com.sublimetext.2
sublime3=com.sublimetext.3
macvim=org.vim.MacVim

# editor=$vscode
editor=$cursor

# editors=("Atom" "MacVim" "SublimeText2" "SublimeText3" "VisualStudioCode" "VisualStudioCodeInsiders")

# echo "Which editor would you like to be default?"

# select opt in ${editors[@]}; do
#   if [ "$opt" = "Atom" ]; then
#     editor=$atom
#     break
#   elif [ "$opt" = "MacVim" ]; then
#     editor=$macvim
#     break
#   elif [ "$opt" = "SublimeText2" ]; then
#     editor=$sublime2
#     break
#   elif [ "$opt" = "SublimeText3" ]; then
#     editor=$sublime3
#     break
#   elif [ "$opt" = "VisualStudioCode" ]; then
#     editor=$vscode
#     break
#   elif [ "$opt" = "VisualStudioCodeInsiders" ]; then
#     editor=$vscodeinsiders
#     break
#   fi
# done

echo "Setting default editor to $editor"
echo "-----------------------------------------"

for extension in "${extensions[@]}"; do
  echo "duti -s $editor $extension"
  duti -s $editor "$extension" all
done
