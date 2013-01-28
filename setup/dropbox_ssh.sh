#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
echo "== Decrypting .ssh from Dropbox..."

openssl aes-256-cbc -d -in $HOME/Dropbox/ssh.tar.gz.encrypted -out $HOME/ssh.tar.gz

cd $HOME
tar xvf ssh.tar.gz
