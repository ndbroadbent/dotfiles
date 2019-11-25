#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
echo "== Decrypting .ssh from Dropbox..."

openssl aes-256-cbc -d -in "$HOME/Dropbox/ssh.tar.gz.encrypted" -out /tmp/ssh.tar.gz

mkdir -p "$HOME/.ssh"
cd "$HOME/.ssh"
tar xvf /tmp/ssh.tar.gz
rm -rf /tmp/ssh.tar.gz
