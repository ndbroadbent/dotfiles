# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#
# Install this crontab with: whenever -f schedule.rb -w
#
# 'Git index' jobs require SCM Breeze: https://github.com/ndbroadbent/scm_breeze
job_type :git_index, "git_index --:task"

# -----------------------------------------------------------------------
# Rebuild SCM Breeze index
every 5.minutes do
  git_index "rebuild"
end
