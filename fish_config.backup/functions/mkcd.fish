function mkcd --description 'Create a directory and set CWD'
    mkdir -p $argv[1]
    if test $status = 0
        cd $argv[1]
    end
end