#!/bin/bash
# The following programs will run on system startup

echo "== Configuring chrome, terminal & geany to run on startup..."

# Create startup script including delay (wait for panels to be shown, otherwise app title bar is hidden.)
cat > ~/.start_dev_applications.sh <<EOF
#!/bin/sh
sleep 15
google-chrome &
geany &
if which gnome-terminal; then \$(gnome-terminal &); else \$(xfce4-terminal &); fi
EOF
chmod +x ~/.start_dev_applications.sh

# Start applications on startup
cat > ~/.config/autostart/dev_applications.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=$HOME/.start_dev_applications.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_HK]=Development Applications
Name=Development Applications
Comment=
EOF

