# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

# Install this crontab with: whenever -f schedule.rb -w

# 'Git index' jobs require SCM Breeze: https://github.com/ndbroadbent/scm_breeze
job_type :git_index, <<-CMD.gsub(/\s{2,}/, ' ').strip
  source #{ENV['HOME']}/.scm_breeze/scm_breeze.sh;
  git_index --:task
CMD


every 30.minutes do
  # Fetch all remotes for indexed git repos, and fast-forward if possible
  # Send notifications using notify-send
  git_index "update-all-with-notifications"
end

every 10.minutes do
  # Update dotfiles
  # - Set up new symlinks
  # - Update generated bashrc, git config, etc.
  # - Update this cron task
  command <<-CMD.gsub(/\s{2,}/, ' ').strip
    cd $DOTFILES_PATH && (
      ./setup/symlinks.sh;
      ./setup/bashrc.sh;
      ./setup/git_config.sh;
      ensure_gem whenever && whenever -f schedule.rb -w)
  CMD
end

# Rebuild SCM Breeze index
every 1.minute do
  git_index "rebuild"
end

# Update Travis CI build statuses for current branch of indexed git repos
every 30.minutes do
  git_index "batch-cmd update_travis_ci_status"
end

# Install gem dependencies via Bundler, for all indexed repos that contain a Gemfile.
every 1.hour do
  git_index "batch-cmd bundle_check_or_install"
end

