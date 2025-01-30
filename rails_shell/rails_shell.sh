export RAILS_SHELL_DIR="$(dirname ${BASH_SOURCE:-$0})"

export PATH="$PATH:$RAILS_SHELL_DIR/bin"

export RAILS_G_COMP_FILE=".cached_rails_g_completions~"
export RAKE_COMP_FILE=".cached_rake_completions~"
export CAP_COMP_FILE=".cached_cap_completions~"

if [[ "$(uname)" == 'Darwin' ]]
then
  CPU_CORES="$(sysctl hw.ncpu | awk '{print $2}')"
else
  CPU_CORES="$(nproc)"
fi
ACTUAL_CPU_CORES=$CPU_CORES
# # Some parallel tasks run faster when only using actual CPU cores (instead of hyper-threads)
# if [ $CPU_CORES = 8 ]; then ACTUAL_CPU_CORES=4; fi
# if [ $CPU_CORES = 4 ]; then ACTUAL_CPU_CORES=2; fi

source "$RAILS_SHELL_DIR/rails_shell/bundler.sh"
source "$RAILS_SHELL_DIR/rails_shell/rubygems.sh"
source "$RAILS_SHELL_DIR/rails_shell/rails.sh"
source "$RAILS_SHELL_DIR/rails_shell/rake.sh"
source "$RAILS_SHELL_DIR/rails_shell/vagrant.sh"
# source "$RAILS_SHELL_DIR/rails_shell/tab_completion.sh"
