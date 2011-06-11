#!/bin/bash
# Set this script to automatically update the system on startup

echo "== Configuring this script to automatically update the system on startup..."
cat > ~/.config/autostart/ubuntu_config_update.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=cd `pwd` && git pull origin master && sudo ./dev_machine_setup.sh --update
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Auto-update system config from GitHub
Comment=
EOF

