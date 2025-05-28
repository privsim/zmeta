function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    # Git status
    set -l git_info
    if command -sq git
        set -l git_branch (git branch 2>/dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
        if test -n "$git_branch"
            set git_branch (echo $git_branch | string trim)
            set -l git_status (git status -s --ignore-submodules=dirty 2>/dev/null)
            if test -n "$git_status"
                set git_info "$git_branch*"
            else
                set git_info "$git_branch"
            end
        end
    end

    # User
    set_color cyan
    echo -n (whoami)
    set_color normal
    echo -n '@'

    # Host
    set_color blue
    echo -n (hostname -s)
    set_color normal
    echo -n ':'

    # PWD
    set_color green
    echo -n (prompt_pwd)
    set_color normal

    # Git
    if test -n "$git_info"
        set_color yellow
        echo -n " ($git_info)"
        set_color normal
    end

    # Error code
    if test $last_status -ne 0
        set_color red
        echo -n " [$last_status]"
        set_color normal
    end

    echo -n '$ '
end