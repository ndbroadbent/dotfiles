#!/usr/bin/env bash
# locate the dir where this script is stored
export RAILS_SHELL_DIR="$( cd -P "$( dirname "$0" )" && pwd )"

# Symlink to ~/.rails_shell if installing from another path
if [ "$RAILS_SHELL_DIR" != "$HOME/.rails_shell" ] && ! [ -s "$HOME/.rails_shell" ]; then
  ln -fs "$RAILS_SHELL_DIR" "$HOME/.rails_shell"
fi

# This loads Rails Shell into the shell session.
exec_string="[ -s \"$HOME/.rails_shell/rails_shell.sh\" ] && source \"$HOME/.rails_shell/rails_shell.sh\""

# Add line to bashrc
if ! grep -q "$exec_string" "$HOME/.bashrc"; then
  printf "\n$exec_string\n" >> "$HOME/.bashrc"
  printf "== Added Rails Shell to '~/.bashrc'\n"
fi

echo "== Run 'source ~/.bashrc' to load Rails Shell into your current shell."
# echo
# echo "== Installing scheduled task to generate tab completion caches..."

# if [ -e "$HOME/.scm_breeze" ]; then
#   # Use SCM Breeze git_index if available
#   cron_task="git_index --batch-cmd cache_rails_tab_completions"
# else
#   # Fall back to basic 'for_each_rails_repo' script, which iterates over
#   # directories listed in ~/.rails_repos
#   cron_task="for_each_rails_repo cache_rails_tab_completions"
# fi

# Add task to crontab
# crontab -l 2>/dev/null | grep -v "cache_rails_tab_completions" | \
  # { cat; echo "0 * * * * /bin/bash -l -c '$cron_task'"; } | crontab -

echo
echo "How to setup scheduled tab completion cache"
echo "-------------------------------------------"
echo
echo "1) Basic (works by default)"
echo
echo "  * Create a file at $HOME/.rails_repos, where each line is an absolute path to a Rails repo."
echo "  * The scheduled task will run every hour to update cached tab completions for each of these repos."
echo
echo "2) Use SCM Breeze's Repository Index"
echo
echo "  * Install SCM Breeze from https://github.com/ndbroadbent/scm_breeze"
echo "  * After installing, re-run \`~/.rails_shell/install.sh\`, and the scheduled task will be updated to use the repository index from SCM Breeze."
echo
