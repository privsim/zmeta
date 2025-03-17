# ~/.zmeta/hosts/platforms/_core/init.zsh
function {
    typeset -g -U path
    typeset platform_dir="${ZMETA}/hosts/platforms/${$(uname -s):l}-$(uname -m)"
    typeset essence_dir="${platform_dir}/essence"

    if [[ -d "$essence_dir" ]]; then
        command mkdir -p "${HOME}/.config"
        command cp -r "${essence_dir}/"* "${HOME}/.config/"
    fi
}
