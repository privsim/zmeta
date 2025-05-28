function proj --description "Jump to project directory"
    set -l project_dirs $HOME/projects $HOME/Documents/projects $HOME/code $HOME/work $HOME/dev

    if set -q argv[1]
        for base in $project_dirs
            if test -d $base/$argv[1]
                cd $base/$argv[1]
                return 0
            end
        end
        echo "Project '$argv[1]' not found in any project directory"
        return 1
    else
        for base in $project_dirs
            if test -d $base
                cd $base
                return 0
            end
        end
        echo "No project directory found"
        return 1
    end
end