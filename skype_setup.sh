#!/bin/bash
. _shared.sh
echo "== Installing skype..."

apt_queue_or_install "skype"

echo "==== Configuring skype to run on startup..."
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/skype.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=skype
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Skype
Comment=
EOF

