# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

every 10.minutes do
  # Fetch all remotes for indexed git repos, and fast-forward if possible
  command "git_index --rebuild && git_index --update-all"
  # Update dotfiles
  # - Set up new symlinks
  # - Update generated bashrc, git config, etc.
  # - Update this cron task
  command "cd $DOTFILES_PATH && OVERWRITE_ALL=true rake install && whenever -f schedule.rb -w"
end

# Update Travis CI build statuses for indexed git repos
every 2.minutes do
  command "git_index --rebuild && NOCD=true git_index --batch-cmd git_update_travis_status"
end
