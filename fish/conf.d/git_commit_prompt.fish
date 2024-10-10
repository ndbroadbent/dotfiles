function find_in_cwd_or_parent
    set -l slashes (string replace -r '[^/]' '' -- $PWD)
    set -l directory $PWD
    set -l n (string length -- $slashes)
    while test $n -gt 0
        if test -e "$directory/$argv[1]"
            echo "$directory/$argv[1]"
            return 0
        end
        set directory "$directory/.."
        set n (math $n - 1)
    end
    return 1
end

function fail_if_not_git_repo
    if not find_in_cwd_or_parent ".git" >/dev/null
        echo -e "\033[31mNot a git repository (or any of the parent directories)\033[0m"
        return 1
    end
    return 0
end

function git_commit_all_keybinding
    set -l cmd "git_commit_all "
    commandline -C 0 # Move the cursor to the beginning of the line
    commandline -i -- "$cmd" # Insert the text
    commandline -f execute # Execute the command
end

function git_add_and_commit_keybinding
    set -l cmd "git_add_and_commit "
    commandline -C 0 # Move the cursor to the beginning of the line
    commandline -i -- "$cmd" # Insert the text
    commandline -f execute # Execute the command
end

# Git commit prompts
function git_commit_prompt
    set -l commit_msg
    set -l saved_commit_msg
    if test -f "/tmp/.git_commit_message~"
        set saved_commit_msg (cat "/tmp/.git_commit_message~")
        echo -e "\033[0;36mLeave blank to use saved commit message: \033[0m$saved_commit_msg"
    end
    read -l -P "Commit Message: " commit_msg

    if test -z "$commit_msg"
        if test -n "$saved_commit_msg"
            set commit_msg "$saved_commit_msg"
        else
            echo -e "\033[0;31mAborting commit due to empty commit message.\033[0m"
            return
        end
    end

    if test -n "$GIT_COMMIT_MSG_SUFFIX"
        set commit_msg "$commit_msg $GIT_COMMIT_MSG_SUFFIX"
    end

    set escaped_msg (echo "$commit_msg" | sed -e 's/"/\\"/g' -e "s/!/\"'!'\"/g")
    echo "$commit_msg" >"/tmp/.git_commit_message~"
    eval $argv # run any prequisite commands

    set -l git_commit_output (echo "$commit_msg" | git commit -F -)
    set -l GIT_COMMIT_STATUS $status
    echo "$git_commit_output" | tail -n +2

    if test "$GIT_COMMIT_STATUS" -eq 0
        # Delete saved commit message if commit was successful
        /bin/rm -f "/tmp/.git_commit_message~"
    end
end

# Prompt for commit message, then commit all modified and untracked files.
function git_commit_all
    fail_if_not_git_repo; or return 1
    set changes (git status --porcelain | wc -l | tr -d ' ')
    if test "$changes" -gt 0
        if test -n "$GIT_COMMIT_MSG_SUFFIX"
            set appending " | \033[0;36mappending '\033[1;36m$GIT_COMMIT_MSG_SUFFIX\033[0;36m' to commit message.\033[0m"
        end
        echo -e "\033[0;33mCommitting all files (\033[0;31m$changes\033[0;33m)\033[0m$appending"
        git_commit_prompt "git add --all ."
    else
        echo "# No changed files to commit."
    end
end

# Add paths or expanded args if any given, then commit all staged changes.
function git_add_and_commit
    fail_if_not_git_repo; or return 1
    ga $argv
    set changes (git diff --cached --numstat | wc -l)
    if test "$changes" -gt 0
        gs 1 # only show staged changes
        git_commit_prompt
    else
        echo "# No staged changes to commit."
    end
end
