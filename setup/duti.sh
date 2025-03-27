#? /bin/bash
#
# Change default editor for the listed filetypes on MacOS.
# Required duti to be installed. `brew install duti`

extensions=(
  .bash
  .bashrc
  .builder
  .c
  .cjs
  .cjsx
  .coffee
  .config
  .cpp
  .cppm
  .cs
  .css
  .dockerignore
  .editorconfig
  .env
  .envrc
  .erb
  .eslintrc
  .fish
  .gemspec
  .gitattributes
  .gitconfig
  .gitignore
  .gitmodules
  .go
  .graphql
  .haml
  .hbs
  .hcl
  .hs
  .htm
  .html
  .ico
  .java
  .js
  .js.map
  .json
  .json5
  .jsx
  .jsx.map
  .less
  .lock
  .log
  .map
  .md
  .mjs
  .mk
  .npmrc
  .p12
  .pem
  .php
  .postcss
  .prettierrc
  .ps1
  .puma
  .py
  .r
  .rake
  .rb
  .rbi
  .rbs
  .rbw
  .rdoc
  .resx
  .rjs
  .rs
  .rubocop.yml
  .ruby-version
  .sass
  .scss
  .scss.map
  .sh
  .sh.example
  .sql
  .svelte
  .svg
  .swift
  .targets
  .tf
  .tfstate
  .toml
  .ts
  .ts.map
  .tsx
  .tsx.map
  .txt
  .vb
  .vue
  .wasm
  .xml
  .yaml
  .yml
  .zsh
  .zshrc
  Dockerfile
  Gemfile
  Makefile
  Procfile
  public.plain-text
  public.unix-executable
  Rakefile
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
