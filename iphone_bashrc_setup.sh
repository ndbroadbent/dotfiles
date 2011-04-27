#!/bin/bash
iPhone="root@nathans-iphone"

cat assets/iphone_bashrc.sh | \
ssh $iPhone 'cat > /var/root/.bashrc && \
             if ! (grep "source /var/root/.bashrc" /etc/profile); then \
                  echo "source /var/root/.bashrc" >> /etc/profile; \
             fi'
echo "== Installed iPhone bashrc on $iPhone."

