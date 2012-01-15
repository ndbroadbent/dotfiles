# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

every 10.minutes do
  # Fetch all remotes for indexed git repos, and fast-forward if possible
  command "git_index --rebuild && git_index --update-all"
  # Update dotfiles (set up new symlinks, update generated bashrc, git config, etc.)
  command "cd $DOTFILES_PATH && OVERWRITE_ALL=true rake install"
end

# Update Travis CI build statuses for indexed git repos
every 2.minutes do
  command "git_index --rebuild && NOCD=true git_index --batch-cmd git_update_travis_status"
end