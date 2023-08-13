function __trash_exec -a var
    set toplevel (git rev-parse --show-toplevel)

    # is numeric
    if [ "$var" -eq "$var" ] 2>/dev/null
        # number
        set myarg $arr[$var]

        # -- (hyphen hyphen) compare
        set hyphen (printf "%b" (printf '%s%x' '\x' 45))
        if [ "$myarg" = "$hyphen$hyphen" ] 2>/dev/null
            set myarg './'$myarg
        end

        /opt/homebrew/bin/trash $toplevel/$myarg
    else
        # not a number
        /opt/homebrew/bin/trash $toplevel/$var
    end
end

function __trash
    # number
    set res (string split "-" -- (string trim $argv))
    set first $res[1]
    set length (count $res)
    set last ""

    # >
    if [ $length -gt 1 ]
        set last $res[2]
        # >
    else
        # just one
        __trash_exec $res
        return
    end

    # last exists
    if [ $last != '' ]
        set arr_length (count $arr)

        # clamp as array length
        if [ $arr_length -lt $last ]
            set last $arr_length
        end

        # first < last
        if [ $first -lt $last ]
            for i in (seq $first 1 $last)
                __trash_exec $i
            end
        else
            echo 'Argument is not valid.'
        end
    else
        __trash_exec $first
    end
end

function trash
    if not find_in_cwd_or_parent ".git" >/dev/null || [ $argv = --help ] || [ $argv = -h ]
        /opt/homebrew/bin/trash $argv
        return
    end


    # space like, `trash 1 2 3`
    set res (string split " " -- (string trim $argv))
    set length (count $res)

    # only one
    if [ $length -eq 0 ]
        __trash $argv
        return
    end

    for i in $res
        #echo $i
        __trash $i
    end
end
