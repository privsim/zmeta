#!/usr/bin/env bash
set -euo pipefail

# 1Password Secret Management Script
# Place this in your dotfiles, e.g., ~/.1password-secrets.sh

# Display usage instructions
show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [SECRET_NAME] [VAULT_NAME] [USE_CASE]

Manage secrets using 1Password CLI.

Options:
  -h, --help     Show this help message and exit
  -g, --get      Retrieve a secret
  -l, --list     List secrets in a vault
  -c, --create   Create a new secret (default action if no option is specified)

Arguments:
  SECRET_NAME    Name of the secret (default: directory_name_YYYYMMDD)
  VAULT_NAME     Name of the 1Password vault (default: Development)
  USE_CASE       Description of the secret's use case

Examples:
  $(basename "$0")                           # Create a secret with default name and vault
  $(basename "$0") -c my_api_key             # Create a secret named "my_api_key"
  $(basename "$0") -g my_api_key             # Retrieve the "my_api_key" secret
  $(basename "$0") -l Production             # List all secrets in the Production vault
  $(basename "$0") -g my_api_key Production  # Retrieve "my_api_key" from Production vault

Note: Ensure you're authenticated with 1Password CLI before running this script.
EOF
}

# Function to generate a high-entropy secret
generate_secret() {
    openssl rand -base64 32
}

# Function to get default vault name
get_default_vault() {
    echo "Infrastructure"
}

# Function to get default secret name
get_default_secret_name() {
    local date_stamp
    date_stamp=$(date +"%Y%m%d")
    local dir_name
    dir_name=$(basename "$PWD")
    echo "${dir_name}_${date_stamp}"
}

# Function to add a secret to 1Password
add_secret_to_1password() {
    local secret_name="${1:-$(get_default_secret_name)}"
    local secret_value="$2"
    local vault_name="${3:-$(get_default_vault)}"
    local use_case="${4:-Auto-generated secret for $secret_name}"

    op item create --vault="$vault_name" --category="Password" \
        "name=$secret_name" "password=$secret_value" \
        "notes=Use case: $use_case"
}

# Function to retrieve a secret from 1Password
get_secret_from_1password() {
    local secret_name="${1:-$(get_default_secret_name)}"
    local vault_name="${2:-$(get_default_vault)}"

    op item get "$secret_name" --vault="$vault_name" --fields password
}

# Function to list secrets in a vault
list_secrets() {
    local vault_name="${1:-$(get_default_vault)}"
    echo "Listing secrets in vault: $vault_name"
    op item list --vault="$vault_name" --categories password --format json | jq -r '.[] | "\(.title) (\(.id))"'
}

# Create and store a secret
create_and_store_secret() {
    local secret_name="${1:-$(get_default_secret_name)}"
    local vault_name="${2:-$(get_default_vault)}"
    local use_case="${3:-Auto-generated secret for $secret_name}"

    local secret_value
    secret_value=$(generate_secret)
    if add_secret_to_1password "$secret_name" "$secret_value" "$vault_name" "$use_case"; then
        echo "Secret '$secret_name' created and stored in 1Password vault '$vault_name'"
    else
        echo "Error: Failed to create secret '$secret_name'" >&2
        return 1
    fi
}

# Ensure 1Password CLI is authenticated
ensure_1password_auth() {
    if ! op account get &>/dev/null; then
        echo "Error: Not authenticated with 1Password CLI. Please run 'op signin' first." >&2
        exit 1
    fi
}

# Main script
main() {
    ensure_1password_auth

    local action="create"
    local secret_name=""
    local vault_name=""
    local use_case=""

    # Parse options
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -h|--help) show_usage; exit 0 ;;
            -g|--get) action="get"; shift ;;
            -l|--list) action="list"; shift ;;
            -c|--create) action="create"; shift ;;
            *)
                if [ -z "$secret_name" ]; then
                    secret_name="$1"
                elif [ -z "$vault_name" ]; then
                    vault_name="$1"
                elif [ -z "$use_case" ]; then
                    use_case="$1"
                else
                    echo "Error: Too many arguments" >&2
                    show_usage
                    exit 1
                fi
                shift
                ;;
        esac
    done

    case "$action" in
        create)
            create_and_store_secret "$secret_name" "$vault_name" "$use_case"
            ;;
        get)
            local secret_value
            secret_value=$(get_secret_from_1password "$secret_name" "$vault_name")
            if [ -n "$secret_value" ]; then
                echo "Retrieved secret: $secret_name"
                echo "Secret value retrieved successfully (not displayed for security)"
            else
                echo "Error: Failed to retrieve secret '$secret_name'" >&2
                exit 1
            fi
            ;;
        list)
            list_secrets "$vault_name"
            ;;
    esac
}

# Run the main function if the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
