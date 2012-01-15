# Shared functions for running individual scripts in isolation
# ============================================================

# Only include once.
if [ -z "$_shared_functions" ]; then
  _shared_functions="true"

  ubuntu_codename=`grep DISTRIB_CODENAME= /etc/lsb-release | sed s/DISTRIB_CODENAME=//`

  # Prompts
  # --------------------------------------------

  # User confirmation for optional scripts.
  function confirm_by_default() {
    read -p "== Set up $1? (default='y') (y/n): "
    if [ "$REPLY" != "n" ] && [ "$REPLY" != "no" ]; then
      scripts+="$2 "
    else
      echo "===== Skipping $1 setup."
    fi
  }

  function prompt_for_git() {
    read -p "===== [Git config] Please enter your name: " git_name
    read -p "===== [Git config] Please enter your email: " git_email
    read -p "===== [Git config] Please enter your github username: " github_user
    read -p "===== [Git config] Please enter your github API token: " github_token
  }

  function prompt_for_netrc() {
    read -p "===== [.netrc config] Machine (default = code.crossroads.org.hk): " netrc_machine
    if [ -z "$netrc_machine" ]; then netrc_machine="code.crossroads.org.hk"; fi
    read -p "===== [.netrc config] Login: " netrc_login
    stty -echo; read -p "===== [.netrc config] Password: " netrc_password; stty echo; echo
  }


  # Packages
  # --------------------------------------------

  function apt_queue_or_install() {
    if [ -n "$1" ]; then
      if [[ "$0" =~ "dev_machine_setup.sh" ]]; then
        apt_packages+="$1 "
      else
        sudo apt-get update
        sudo apt-get install -ym $1
      fi
    else
      echo "apt_queue_or_install() requires a list of packages"
    fi
  }

  # Add ppa if not already added
  function apt_add_new_ppa() {
    if [ -n "$2" ]; then
      if ! (ls /etc/apt/sources.list.d/ | grep $1 | grep -q $2 ); then
        sudo add-apt-repository ppa:$1/$2
      fi
    else
      echo "Usage: apt_add_new_ppa < user > < ppa_name >"
    fi
  }

fi
