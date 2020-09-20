# NVM
[[ -n $DEBUG_BASHRC ]] && echo "Loading NVM..."
export NVM_DIR="$HOME/.nvm"
if [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
  source "/usr/local/opt/nvm/nvm.sh"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi
if [ -s '/usr/local/opt/nvm/etc/bash_completion.d/nvm' ]; then
  source '/usr/local/opt/nvm/etc/bash_completion.d/nvm'
elif [ -s "$NVM_DIR/bash_completion" ]; then
  source "$NVM_DIR/bash_completion"
fi
