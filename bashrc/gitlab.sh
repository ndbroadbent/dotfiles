# See: https://docs.gitlab.com/ee/user/project/push_options.html

# Create a new merge request if it doesn't already exist.
# Configure any merge requests to get automatically merged when the CI build is successful.
alias gpsm="git push -o merge_request.create -o merge_request.target=master -o merge_request.merge_when_pipeline_succeeds"
