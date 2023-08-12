function __gbu
    # number
    set res (string split "-" -- (string trim $argv))
    set length (count $res)

    if [ $length -gt 0 ]
        echo 'You must set argment.'
        # >
    else if [ $length -gt 1 ]
        echo 'You must set only one argment.'
        # >
    else
        # just one
        git branch --set-upstream-to=origin/master $argv
        return
    end
end

function gbu
    if ! fail_if_not_git_repo
        return
    end
    __gbu
end
