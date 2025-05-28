function p
    # ----------------------------------------------------------------------------
    # Setup
    # ----------------------------------------------------------------------------
    set -l o_all o_almost_all o_human o_si o_directory o_group_directories
    set -l o_no_directory o_no_vcs o_sort o_sort_reverse o_help
    set -l show_help 0

    # ----------------------------------------------------------------------------
    # Parse arguments
    # ----------------------------------------------------------------------------
    for arg in $argv
        switch $arg
            case '-a' '--all'
                set o_all 1
            case '-A' '--almost-all'
                set o_almost_all 1
            case '-c'
                set o_sort 'ctime'
            case '-d' '--directory'
                set o_directory 1
            case '--group-directories-first'
                set o_group_directories 1
            case '-h' '--human'
                set o_human 1
            case '--si'
                set o_si 1
            case '-n' '--no-directory'
                set o_no_directory 1
            case '-r' '--reverse'
                set o_sort_reverse 1
            case '-S'
                set o_sort 'size'
            case '-t'
                set o_sort 'mtime'
            case '-u'
                set o_sort 'atime'
            case '-U'
                set o_sort 'none'
            case '--no-vcs'
                set o_no_vcs 1
            case '--help'
                set show_help 1
        end
    end

    if test $show_help -eq 1
        echo "Usage: p [options] DIR"
        echo "Options:"
        echo "  -a      --all           list entries starting with ."
        echo "  -A      --almost-all    list all except . and .."
        echo "  -c                      sort by ctime (inode change time)"
        echo "  -d      --directory     list only directories"
        echo "  -n      --no-directory  do not list directories"
        echo "  -h      --human         show filesizes in human-readable format"
        echo "          --si            with -h, use powers of 1000 not 1024"
        echo "  -r      --reverse       reverse sort order"
        echo "  -S                      sort by size"
        echo "  -t                      sort by time (modification time)"
        echo "  -u                      sort by atime (use or access time)"
        echo "  -U                      Unsorted"
        echo "          --sort WORD     sort by WORD: none (U), size (S),"
        echo "                          time (t), ctime or status (c),"
        echo "                          atime or access or use (u)"
        echo "          --no-vcs        do not get VCS status (much faster)"
        echo "          --help          show this help"
        return 0
    end

    # ----------------------------------------------------------------------------
    # Define color scheme
    # ----------------------------------------------------------------------------
    set -l K_COLOR_DI "0;34"
    set -l K_COLOR_LN "0;35"
    set -l K_COLOR_SO "0;32"
    set -l K_COLOR_PI "0;33"
    set -l K_COLOR_EX "0;31"
    set -l K_COLOR_SU "30;41"
    set -l K_COLOR_TW "30;42"
    set -l K_COLOR_OW "30;43"

    # ----------------------------------------------------------------------------
    # Process directories and files
    # ----------------------------------------------------------------------------
    set -l base_dirs '.'
    if not test -z $argv
        set base_dirs $argv
    end

    for base_dir in $base_dirs
        # Display name if multiple paths were passed
        if test (count $base_dirs) -gt 1
            if test $base_dir != $base_dirs[1]
                echo
            end
            echo "$base_dir:"
        end

        # Get directory listing
        set -l files (ls -lh $base_dir)

        for file in $files
            set -l perms (echo $file | awk '{print $1}')
            set -l owner (echo $file | awk '{print $3}')
            set -l group (echo $file | awk '{print $4}')
            set -l size (echo $file | awk '{print $5}')
            set -l date (echo $file | awk '{print $6, $7, $8}')
            set -l name (echo $file | awk '{print $9}')

            # Check for colors based on type
            set -l color $K_COLOR_EX
            if string match -q "d*" $perms
                set color $K_COLOR_DI
            end
            if string match -q "l*" $perms
                set color $K_COLOR_LN
            end

            # Print formatted output
            echo -e "$perms $owner $group $size $date \e[$color""m$name\e[0m"
        end
    end
end
