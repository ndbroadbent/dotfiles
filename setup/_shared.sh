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
    git_name=$(git config --get user.name)
    git_email=$(git config --get user.email)
    github_user=$(git config --get github.user)
    github_token=$(git config --get github.token)
    if [ -n "$git_name" ]; then
      echo "Git already configured:"
      echo "   name: '$git_name',  email: '$git_email' "
      echo "   github user: '$github_user',  github token: '$github_token'"
    else
      read -p "===== [Git config] Please enter your name: " git_name
      read -p "===== [Git config] Please enter your email: " git_email
      read -p "===== [Git config] Please enter your github username: " github_user
      read -p "===== [Git config] Please enter your github API token: " github_token
    fi
  }

  # Packages
  # --------------------------------------------
  function apt_add_dependency() {
    if [ -n "$1" ]; then
	  for pkg in $@; do
        if ! type $pkg > /dev/null 2>&1; then
          apt_queue_or_install $pkg
        fi
      done
    else
      echo "apt_add_dependency() requires a list of packages"
    fi
  }

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
