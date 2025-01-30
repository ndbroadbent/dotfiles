# Set up Yubikey for SSH
mkdir -p "$HOME"/.ssh/yubikey
export SSH_AUTH_SOCK="${HOME}/.ssh/yubikey/spin.sock"
ssh_agent_running=$(ps -ef | grep -v grep | grep /usr/bin/ssh-agent)
if [[ "$ssh_agent_running" == '' ]]; then
  rm -f "${HOME}"/.ssh/yubikey/spin.sock
  test ! -e "${HOME}"/.ssh/yubikey/spin.sock && eval "$(/usr/bin/ssh-agent -a "$HOME"/.ssh/yubikey/spin.sock)" >/dev/null 2>&1
fi
