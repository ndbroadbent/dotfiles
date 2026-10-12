#!/usr/bin/env bash
set -eo pipefail

# Raise the kernel vnode table limit (one entry per open or cached file).
# Docker Desktop file sharing plus many parallel dev sessions and test runs
# filled the default table (263168 on a 32 GB Mac) in Oct 2026: launchd died
# with SIGBUS and the kernel panicked. sysctl settings reset on reboot, so a
# LaunchDaemon applies the limit at every boot.
MAXVNODES=1048576
PLIST=/Library/LaunchDaemons/com.ndbroadbent.maxvnodes.plist

if [[ $EUID -eq 0 ]]; then
  echo -e "\033[01;31mPlease do not use sudo to run this script!\033[00m" 2>&1
  exit 1
fi

TMP_PLIST="$(mktemp)"
trap 'rm -f "$TMP_PLIST"' EXIT

cat > "$TMP_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.ndbroadbent.maxvnodes</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/sbin/sysctl</string>
      <string>-w</string>
      <string>kern.maxvnodes=${MAXVNODES}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF
plutil -lint "$TMP_PLIST" > /dev/null

if cmp -s "$TMP_PLIST" "$PLIST"; then
  echo "kern.maxvnodes boot setting already installed ($PLIST)"
else
  echo "Installing $PLIST (kern.maxvnodes=${MAXVNODES} at boot)..."
  sudo install -m 644 -o root -g wheel "$TMP_PLIST" "$PLIST"
fi

if [[ "$(sysctl -n kern.maxvnodes)" -lt "$MAXVNODES" ]]; then
  echo "Raising kern.maxvnodes to ${MAXVNODES} for the current boot..."
  sudo sysctl -w "kern.maxvnodes=${MAXVNODES}"
fi
