#!/bin/bash
# This bash script will set up (or update) your development environment for Ubuntu (v=>9.10)

# Check for root user
if [[ $EUID -ne 0 ]]; then
  echo -e "\n\033[01;31mYou must be root to run this script!\033[00m\n" 2>&1
  exit 1
fi

scripts=""
apt_packages=""  # Installs all packages in a single transaction

# User confirmation for optional scripts.
function confirm_by_default() {
  read -p "== Set up $1? (default='y') (y/n): "
  if [ "$REPLY" != "n" ] && [ "$REPLY" != "no" ]; then
    scripts+="$2 "
  else
    echo "===== Skipping $1 setup."
  fi
}

function prompt_for_git_user() {
  read -p "===== [Git config] Please enter your name: ";  git_name="$REPLY"
  read -p "===== [Git config] Please enter your email: "; git_email="$REPLY"
}

echo -e "\n[ Ubuntu Developer Setup Script ]"
echo -e "=================================\n"

# '--all' flag installs everything
if [ "$1" = "--all" ]; then
  echo "== Setting up default environment..."
  scripts="packages bashrc git_config rvm ruby_dotfiles gimp gedit vim gnome conky startup tomate "
  prompt_for_git_user

# '--update' flag reinstalls everything that doesn't require user input
elif [ "$1" = "--update" ]; then
  echo "== Running default update..."
  scripts="packages bashrc ruby_dotfiles gimp gedit vim gnome conky startup tomate "

# If no flag given, ask user which scripts they would like to run.
else
  confirm_by_default "Git config" 'git_config'
  if [[ "$scripts" =~ "git_config" ]]; then
    prompt_for_git_user    # If installing git, prompt for name and email
  fi
  confirm_by_default "apt packages"                'packages'
  confirm_by_default "bashrc"                      'bashrc'
  confirm_by_default "ruby config (dotfiles)"      'ruby_dotfiles'
  confirm_by_default "Gimp (latest ppa version)"   'gimp'
  confirm_by_default "Tomate (widget)"             'tomate'
  confirm_by_default "RVM (Ruby Version Manager)"  'rvm'
  confirm_by_default "gedit customizations"        'gedit'
  confirm_by_default "vim customizations"          'vim'
  confirm_by_default "gnome themes and fonts"      'gnome'
  confirm_by_default "conky (system stats)"        'conky'
  confirm_by_default "firefox, terminal and gedit on startup"  'startup'
  echo -e "\n===== Thanks. Now executing 'rm -rf /'...       No, not really."
fi

echo -e "\n===== Now executing the following scripts:"
echo -e   "      [ $scripts]\n"


# Include each configured script
# --------------------------------------------------------------
for script in $scripts; do
  . $script\_setup.sh
done


# Update sources and install apt packages
# --------------------------------------------------------------
echo "== Updating apt sources..."
apt-get update -qq
echo "== Installing apt packages..."
apt-get install -ym $apt_packages | grep -v "is already the newest version"


# Restarting nautilus for dropbox and image resizer
nautilus -q


echo -e "\n===== Ubuntu development machine has been set up!\n"
echo -e "Further manual configuration may be needed:\n"
echo "    Gnome   - Set theme to 'Custom Theme'"
echo "    Compiz  - Import settings from './assets/compiz.profile'"
echo "    Cortina - Start cortina and configure wallpaper directory"
echo "    Synergy - Copy your synergy conf to '/etc/synergy.conf' & add to startup:"
echo "              synergys --config '/etc/synergy.conf'"
echo

