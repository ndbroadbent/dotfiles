#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;
echo "== Decrypting .ssh from Dropbox..."

openssl aes-256-cbc -d -in $HOME/Dropbox/UbuntuSync/ssh.tar.gz.encrypted -out /tmp/ssh.tar.gz

cd /tmp
tar xvf ssh.tar.gz
mkdir -p $HOME/.ssh
cp -R /tmp/home/ndbroadbent/.ssh/* ~/.ssh/
rm -rf /tmp/ssh.tar.gz /tmp/home/ndbroadbent/.ssh/ 
