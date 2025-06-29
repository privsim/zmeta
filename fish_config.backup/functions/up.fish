function up --description "Move up n directories"
    set -l ups
    if test (count $argv) -eq 0
        set ups 1
    else
        set ups $argv[1]
    end

    for i in (seq $ups)
        cd ..
    end
end