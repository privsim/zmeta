# XDG Base Directory Specification handling for both macOS and Linux
declare -gx XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
declare -gx XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
declare -gx XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

# Platform-specific runtime directory handling
if [[ -z "$XDG_RUNTIME_DIR" ]]; then
    case "$OSTYPE" in
        darwin*)
            # macOS uses a different temporary directory structure
            declare -gx XDG_RUNTIME_DIR=$TMPDIR/runtime-$(id -u)
            mkdir -p "$XDG_RUNTIME_DIR"
            chmod 700 "$XDG_RUNTIME_DIR"
            ;;
        linux*)
            declare -gx XDG_RUNTIME_DIR=/run/user/$(id -u)
            if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
                if sudo mkdir -p "$XDG_RUNTIME_DIR" &>/dev/null; then
                    sudo chmod 700 "$XDG_RUNTIME_DIR"
                    sudo chown $(id -u):$(id -g) "$XDG_RUNTIME_DIR"
                else
                    declare -gx XDG_RUNTIME_DIR=/tmp/runtime-$(id -u)
                    mkdir -p "$XDG_RUNTIME_DIR"
                    chmod 700 "$XDG_RUNTIME_DIR"
                fi
            fi
            ;;
        *)
            # Fallback for other systems
            declare -gx XDG_RUNTIME_DIR=/tmp/runtime-$(id -u)
            mkdir -p "$XDG_RUNTIME_DIR"
            chmod 700 "$XDG_RUNTIME_DIR"
            ;;
    esac
fi

# Ensure base directories exist
for dir in "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"; do
    [[ -d "$dir" ]] || mkdir -p "$dir"
done
