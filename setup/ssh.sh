# Requires your SSH configuration to be stored in Dropbox.
# But keep your private keys safe!

ssh_conf_path="$HOME/Dropbox/UbuntuSync/ssh"
mkdir -p $HOME/.ssh/

for f in $ssh_conf_path/*; do
  rm -f "$HOME/.ssh/$(basename $f)"
  ln -fs "$f" "$HOME/.ssh/"
done