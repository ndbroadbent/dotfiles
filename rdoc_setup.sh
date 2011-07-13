#!/bin/bash
rdoc_version=rails-v3.0.8rc1_ruby-v1.9.2
doc_path=/usr/share/doc/rdoc-$rdoc_version

wget http://railsapi.com/doc/$rdoc_version/rdoc.zip -O /tmp/$rdoc_version.zip
sudo unzip /tmp/$rdoc_version.zip -d $doc_path
# Open in firefox
firefox $doc_path/index.html &

