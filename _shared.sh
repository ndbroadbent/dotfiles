# Shared functions for running individual scripts in isolation
function apt_queue_or_install() {
  if [ -n "$1" ]; then
    if [[ "$0" =~ "dev_machine_setup.sh" ]]; then
      apt_packages+="$1 "   # (trailing space is important.)
    else
      sudo apt-get update
      sudo apt-get install -ym $1
    fi
  else
    echo "queue_or_isolated_install() requires a list of packages"
  fi
}

# Add ppa if not already added
function apt_add_new_ppa() {
  if [ -n "$2" ]; then
    if ! (ls /etc/apt/sources.list.d/ | grep $1 | grep -q $2 ); then
      sudo add-apt-repository ppa:$1/$2
    fi
  else
    echo "apt_add_new_ppa() requires: < user > < ppa_name >"
  fi
}

