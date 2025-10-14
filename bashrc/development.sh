# cspell:disable

alias ds='cat .dev.scpt | osascript - "$(pwd)" &'
alias dds='cd ~/code/docspring && ds'
alias sds='cd ~/code/spin && ds'
alias d='cd ~/code/docspring'
alias dt='cd ~/code/dotfiles'

alias da='direnv allow'

# pnpm
alias p="pnpm"
alias pi="pnpm install"

# Git
# -------------------------------------------------
# Adds all changes to current commit and then force pushes.
# Never use this on a team project!!
alias GFORCE='git add -A && git commit --amend -C HEAD && git push -f'

# A bash alias that checks out the main branch, pulls the latest changes,
# checks out the previous branch, and then rebases onto main.
alias grbl='MAIN_BRANCH=$((! [ -f .git/config ] && echo "master") || (grep -q '"'"'branch "master"'"'"' .git/config && echo master || echo main)) && git checkout "$MAIN_BRANCH" && git pull && git checkout - && git rebase "$MAIN_BRANCH"'

# Helper function for git push with CI approvals
_git_push_and_approve() {
  local push_flags=""
  local approvals=()

  # Check for -f flag
  if [[ "$1" == "-f" ]]; then
    push_flags="-f"
    shift
  fi

  # Collect remaining arguments as approvals
  approvals=("$@")

  # Execute git push and approvals
  git push $push_flags && {
    for approval in "${approvals[@]}"; do
      ./scripts/ci/approve "$approval" || return 1
    done
  }

  ./scripts/wait_for_ci_build
}

gpss() { _git_push_and_approve "$@" staging; }
gpsbs() { _git_push_and_approve "$@" build staging; }
gpsa() { _git_push_and_approve "$@" all; }
gpsba() { _git_push_and_approve "$@" build all; }

# Gitlab CI (DocSpring)
# -------------------------------------------------
# Show latest CI pipeline in terminal
# alias ci="./scripts/circleci_pipeline_status -f '#%n: %s. URL: %u'"
# Show latest CI pipeline in browser
# alias sci="./scripts/show_latest_circleci_pipeline"
# # Run failed tests from the most recent failed CI pipeline
# alias rci="./scripts/run_failed_ci_pipeline_specs"
# # Refresh CI status in prompt
# alias rfci="./scripts/circleci_pipeline_status > /dev/null"

# Delete git branch locally and on remote
function gbDA() {
  if [ "$1" == 'master' ] || [ "$1" == 'main' ]; then
    echo "Cannot delete $1 branch."
    return 1
  fi
  _scmb_git_branch_shortcuts -D "$1";
  exec_scmb_expand_args git push origin --delete "$1";
}


# Shortcut.com
# ------------------------------------------------
# Create new git branch for a story ID
alias stb="short st --git-branch-short"
alias sss="./scripts/start_shortcut_story"

# - Open all development tabs in iTerm2
# - Start and reset VS Code (close all files, collapse folders)
# - Start git branch for current story in development
# - Open story in new Chrome window
dev() (
  cd ~/code/docspring || exit
  ./scripts/dev_iterm
)

# Git worktree navigation
# ------------------------------------------------
# Use fzf to select a git worktree and cd to it
dw() {
  local worktree_list
  local selected_worktree
  local filter="$1"

  # Get list of worktrees, filter out main branch
  worktree_list="$(git -C ~/code/docspring worktree list | grep -v '\[main\]')"

      # Use fzf with optional filter and auto-select if single match
  local fzf_opts=(
    --prompt="Select worktree: "
    --height=~40%
    --layout=reverse
    --border=rounded
    --info=right
    --exact
  )

  if [ -n "$filter" ]; then
    fzf_opts+=(--select-1 -q "$filter")
  fi

  selected_worktree="$(echo "$worktree_list" | fzf "${fzf_opts[@]}")"

  # If a worktree was selected, cd to it
  if [ -n "$selected_worktree" ]; then
    local worktree_path
    worktree_path="$(echo "$selected_worktree" | awk '{print $1}')"
    cd "$worktree_path" || return 1
  fi
}

# Global cache for rust deps
RUSTC_WRAPPER="$(command -v sccache)"
SCCACHE_DIR="${SCCACHE_DIR:-$HOME/.cache/sccache}"
export RUSTC_WRAPPER SCCACHE_DIR
