#!/bin/bash
. _shared.sh
if [ -z "$netrc_password" ]; then prompt_for_netrc; fi

echo "== Setting up ~/.netrc..."
cat > ~/.netrc <<EOF
machine $netrc_machine
login $netrc_login
password $netrc_password
EOF

