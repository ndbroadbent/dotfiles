#? /bin/bash
#
# Change default editor for the listed filetypes on MacOS.
# Required duti to be installed. `brew install duti`

extensions=(
  public.plain-text public.unix-executable 
  .c .cpp .cs .css .env .erb .haml .hbs .hs .java .js .json 
  .lock .map .md .rb .sass .scss .svg .sh .ts .txt .yaml .yml .zsh)
vscodeinsiders=com.microsoft.VSCodeInsiders
vscode=com.microsoft.VSCode
atom=com.github.atom
sublime2=com.sublimetext.2
sublime3=com.sublimetext.3
macvim=org.vim.MacVim

editor=$vscode

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

for extension in "${extensions[@]}"; do
  echo "duti -s $editor $extension"
  duti -s $editor $extension all
done
