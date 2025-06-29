function extract --description "Extract files from archives"
    for file in $argv
        if test -f $file
            switch $file
                case '*.tar.gz' '*.tgz'
                    tar -xzvf $file
                case '*.tar.bz2' '*.tbz2'
                    tar -xjvf $file
                case '*.tar.xz' '*.txz'
                    tar -xJvf $file
                case '*.tar'
                    tar -xvf $file
                case '*.gz'
                    gunzip $file
                case '*.bz2'
                    bunzip2 $file
                case '*.xz'
                    unxz $file
                case '*.zip'
                    unzip $file
                case '*.rar'
                    unrar x $file
                case '*.7z'
                    7z x $file
                case '*'
                    echo "Unknown archive format: $file"
            end
        else
            echo "File does not exist: $file"
        end
    end
end