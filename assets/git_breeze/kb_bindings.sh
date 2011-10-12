# Keyboard Bindings
# -----------------------------------------------------------
# Ctrl+Space and Ctrl+x+Space give 'git commit' prompts.
# See here for more info about why a prompt is more useful: http://qntm.org/bash#sec1

case "$TERM" in
xterm*|rxvt*)
    # Keyboard bindings invoke wrapper functions with a leading space,
    # so they are not added to history. (set HISTCONTROL=ignorespace:ignoredups)

    # CTRL-SPACE => $  git_status_with_shortcuts {ENTER}
    bind "\"\C- \":  \" git_status_with_shortcuts\n\""
    # CTRL-x-SPACE => $  git_commit_all {ENTER}
    bind "\"\C-x \":  \" git_commit_all\n\""
    # CTRL-x-c => $  git_add_and_commit {ENTER}
    # 1 3 CTRL-x-c => $  git_add_and_commit 1 3 {ENTER}
    bind "\"\C-xc\": \"\e[1~ git_add_and_commit \n\""
esac

