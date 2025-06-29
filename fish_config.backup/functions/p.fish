function p --description "Enhanced directory listing with git status and colors"
    # ----------------------------------------------------------------------------
    # Setup
    # ----------------------------------------------------------------------------
    set -l options "a/all" "A/almost-all" "c" "d/directory" "h/human" "si" "n/no-directory" "no-vcs" "r/reverse" "S" "t" "u" "U" "sort=" "help"
    argparse $options -- $argv

    # Print help if requested
    if set -q _flag_help
        echo "Usage: p [options] [DIR]"
        echo "Options:"
        echo "  -a, --all           list entries starting with ."
        echo "  -A, --almost-all    list all except . and .."
        echo "  -c                  sort by ctime (inode change time)"
        echo "  -d, --directory     list only directories"
        echo "  -n, --no-directory  do not list directories"
        echo "  -h, --human         show filesizes in human-readable format"
        echo "      --si            with -h, use powers of 1000 not 1024"
        echo "  -r, --reverse       reverse sort order"
        echo "  -S                  sort by size"
        echo "  -t                  sort by time (modification time)"
        echo "  -u                  sort by atime (use or access time)"
        echo "  -U                  Unsorted"
        echo "      --sort WORD     sort by WORD: none (U), size (S), time (t),"
        echo "                      ctime (c), atime (u)"
        echo "      --no-vcs        do not get VCS status (much faster)"
        return 0
    end

    # Check for conflicts
    if set -q _flag_directory; and set -q _flag_no_directory
        echo "Error: --directory and --no-directory cannot be used together"
        return 1
    end

    # ----------------------------------------------------------------------------
    # Colors
    # ----------------------------------------------------------------------------
    set -l K_COLOR_DI "0;34"  # di:directory
    set -l K_COLOR_LN "0;35"  # ln:symlink
    set -l K_COLOR_SO "0;32"  # so:socket
    set -l K_COLOR_PI "0;33"  # pi:pipe
    set -l K_COLOR_EX "0;31"  # ex:executable
    set -l K_COLOR_BD "34;46" # bd:block special
    set -l K_COLOR_CD "34;43" # cd:character special
    set -l K_COLOR_SU "30;41" # su:executable with setuid bit set
    set -l K_COLOR_SG "30;46" # sg:executable with setgid bit set
    set -l K_COLOR_TW "30;42" # tw:directory writable to others, with sticky bit
    set -l K_COLOR_OW "30;43" # ow:directory writable to others, without sticky bit
    set -l K_COLOR_BR "0;30"  # branch

    # ----------------------------------------------------------------------------
    # File size and age colors
    # ----------------------------------------------------------------------------
    set -l LARGE_FILE_COLOR 196
    set -l SIZELIMITS_TO_COLOR \
        1024  46    \
        2048  82    \
        3072  118   \
        5120  154   \
        10240 190   \
        20480 226   \
        40960 220   \
        102400 214  \
        262144 208  \
        524288 202

    set -l ANCIENT_TIME_COLOR 236
    set -l FILEAGES_TO_COLOR \
        0 196    \
        60 255   \
        3600 252 \
        86400 250 \
        604800 244 \
        2419200 244 \
        15724800 242 \
        31449600 240 \
        62899200 238

    # ----------------------------------------------------------------------------
    # Process directories
    # ----------------------------------------------------------------------------
    set -l base_dirs
    if test (count $argv) -eq 0
        set base_dirs .
    else
        set base_dirs $argv
    end

    for base_dir in $base_dirs
        if test (count $base_dirs) -gt 1
            if test "$base_dir" != "$base_dirs[1]"
                echo
            end
            echo "$base_dir:"
        end

        # ----------------------------------------------------------------------------
        # Build file list
        # ----------------------------------------------------------------------------
        set -l show_list
        if not test -e "$base_dir"
            echo "p: cannot access $base_dir: No such file or directory"
            continue
        else if test -f "$base_dir"
            set show_list "$base_dir"
        else
            # Add . and .. if --all is specified
            if set -q _flag_all; and not set -q _flag_almost_all; and not set -q _flag_no_directory
                set show_list "$base_dir/." "$base_dir/.."
            end

            # Build the find command
            set -l find_cmd "find $base_dir -maxdepth 1"
            if not set -q _flag_all; and not set -q _flag_almost_all
                set find_cmd "$find_cmd -not -name '.*'"
            end
            if set -q _flag_directory
                set find_cmd "$find_cmd -type d"
            else if set -q _flag_no_directory
                set find_cmd "$find_cmd -not -type d"
            end

            # Sort options
            if set -q _flag_sort
                switch $_flag_sort
                    case "none" "U"
                        set find_cmd "$find_cmd -printf '%T@ %p\n' | sort -n | cut -d' ' -f2-"
                    case "size" "S"
                        set find_cmd "$find_cmd -printf '%s %p\n' | sort -n | cut -d' ' -f2-"
                    case "time" "t"
                        set find_cmd "$find_cmd -printf '%T@ %p\n' | sort -n | cut -d' ' -f2-"
                    case "ctime" "c"
                        set find_cmd "$find_cmd -printf '%C@ %p\n' | sort -n | cut -d' ' -f2-"
                    case "atime" "u"
                        set find_cmd "$find_cmd -printf '%A@ %p\n' | sort -n | cut -d' ' -f2-"
                end
            end

            if set -q _flag_reverse
                set find_cmd "$find_cmd | tac"
            end

            set show_list (eval $find_cmd)
        end

        # ----------------------------------------------------------------------------
        # Process and display files
        # ----------------------------------------------------------------------------
        set -l total_blocks 0
        set -l max_lens 0 0 0 0 0 0

        # First pass: calculate max lengths and total blocks
        for file in $show_list
            set -l stat (stat -f "%N %z %m %l %u %g %a" "$file" 2>/dev/null)
            if test $status -eq 0
                set -l size (echo $stat | cut -d' ' -f2)
                set -l blocks (math "ceil($size / 512)")
                set total_blocks (math "$total_blocks + $blocks")

                # Update max lengths
                set -l mode (stat -f "%Sp" "$file")
                set -l nlink (stat -f "%l" "$file")
                set -l uid (stat -f "%u" "$file")
                set -l gid (stat -f "%g" "$file")
                set -l size_str
                if set -q _flag_human
                    set size_str (numfmt --to=iec $size)
                else
                    set size_str $size
                end

                set max_lens[1] (math "max($max_lens[1], "(string length $mode)")")
                set max_lens[2] (math "max($max_lens[2], "(string length $nlink)")")
                set max_lens[3] (math "max($max_lens[3], "(string length $uid)")")
                set max_lens[4] (math "max($max_lens[4], "(string length $gid)")")
                set max_lens[5] (math "max($max_lens[5], "(string length $size_str)")")
            end
        end

        echo "total $total_blocks"

        # Second pass: display files
        for file in $show_list
            set -l stat (stat -f "%N %z %m %l %u %g %a" "$file" 2>/dev/null)
            if test $status -ne 0
                continue
            end

            set -l name (echo $stat | cut -d' ' -f1)
            set -l size (echo $stat | cut -d' ' -f2)
            set -l mtime (echo $stat | cut -d' ' -f3)
            set -l nlink (echo $stat | cut -d' ' -f4)
            set -l uid (echo $stat | cut -d' ' -f5)
            set -l gid (echo $stat | cut -d' ' -f6)
            set -l mode (stat -f "%Sp" "$file")

            # Format size
            set -l size_str
            if set -q _flag_human
                if set -q _flag_si
                    set size_str (numfmt --to=si $size)
                else
                    set size_str (numfmt --to=iec $size)
                end
            else
                set size_str $size
            end

            # Format date
            set -l date_str (date -r $mtime "+%b %d %H:%M")
            if test (math "(date +%s) - $mtime") -gt 15724800
                set date_str (date -r $mtime "+%b %d  %Y")
            end

            # Git status
            set -l git_marker " "
            if not set -q _flag_no_vcs
                if git rev-parse --is-inside-work-tree >/dev/null 2>&1
                    set -l git_status (git status --porcelain --ignored --untracked-files=normal "$file" 2>/dev/null)
                    switch $git_status
                        case " M*"
                            set git_marker (set_color red)"+"(set_color normal)
                        case "M *"
                            set git_marker (set_color 082)"+"(set_color normal)
                        case "??*"
                            set git_marker (set_color 214)"+"(set_color normal)
                        case "!!*"
                            set git_marker (set_color 238)"|"(set_color normal)
                        case "A *"
                            set git_marker (set_color 082)"+"(set_color normal)
                        case "*"
                            set git_marker (set_color 082)"|"(set_color normal)
                    end
                end
            end

            # Color the file based on type
            set -l color
            if test -d "$file"
                set color $K_COLOR_DI
            else if test -L "$file"
                set color $K_COLOR_LN
            else if test -S "$file"
                set color $K_COLOR_SO
            else if test -p "$file"
                set color $K_COLOR_PI
            else if test -x "$file"
                set color $K_COLOR_EX
            else if test -b "$file"
                set color $K_COLOR_BD
            else if test -c "$file"
                set color $K_COLOR_CD
            else if test -u "$file"
                set color $K_COLOR_SU
            else if test -g "$file"
                set color $K_COLOR_SG
            end

            # Format the output
            printf "%*s %*s %*s %*s %*s %s %s %s\n" \
                $max_lens[1] $mode \
                $max_lens[2] $nlink \
                $max_lens[3] $uid \
                $max_lens[4] $gid \
                $max_lens[5] $size_str \
                $date_str \
                $git_marker \
                (set_color $color)(basename "$file")(set_color normal)
        end
    end
end 