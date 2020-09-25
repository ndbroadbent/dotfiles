# See: https://docs.gitlab.com/ee/user/project/push_options.html

# Configure any merge requests to get automatically merged when
# the CI build is successful
alias gpsm="git push -o merge_request.merge_when_pipeline_succeeds"
