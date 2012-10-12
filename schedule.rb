# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#
# Install this crontab with: whenever -f schedule.rb -w
#
# 'Git index' jobs require SCM Breeze: https://github.com/ndbroadbent/scm_breeze
job_type :git_index, "git_index --:task"

# -----------------------------------------------------------------------
every 1.minute do
  # Rebuild SCM Breeze index
  git_index "rebuild"
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

every 30.minutes do
  # Fetch all remotes for indexed git repos, and fast-forward if possible
  # Send notifications using notify-send
  git_index "update-all-with-notifications"

  # Update Travis CI build statuses for current branch of indexed git repos
  git_index "batch-cmd update_travis_ci_status"
end

every :hour do
  # Install gem dependencies via Bundler, for all indexed repos that contain a Gemfile.
  git_index "batch-cmd bundle_check_or_install"

  # Cache rails commands for Rake, Capistrano, etc.
  git_index "batch-cmd cache_rails_commands"
end

every 2.hours do
  # Only run one sdoc generation at a time.
  # The initial run for all your projects will take a really long time (a few hours),
  # but subsequent runs will be much shorter.
  # We need to use a lock file called GENERATING to ensure that tasks don't overlap.

  command <<-CMD.gsub(/\s{2,}/, ' ').strip
    mkdir -p $HOME/.sdoc &&
    ! [ -e $HOME/.sdoc/GENERATING ] &&
    touch $HOME/.sdoc/GENERATING &&
    git_index --batch-cmd generate_sdoc;
    rm -f $HOME/.sdoc/GENERATING
  CMD
end