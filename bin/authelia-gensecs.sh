#!/bin/bash

# Define the output directory for secrets
SECRET_DIR="authelia/.secrets"
mkdir -p "${SECRET_DIR}"

# Define the secrets mapping file
SECRETS_FILE="authelia/secrets"
echo "### Authelia ENV vars mapping:" > "${SECRETS_FILE}"

# Function to generate a 64-character alphanumeric secret and append the mapping to the secrets file
generate_secret() {
  local secret_name=$1
  local secret_file="${SECRET_DIR}/${secret_name}"
  tr -cd '[:alnum:]' < /dev/urandom | fold -w 64 | head -n 1 > "${secret_file}"
  echo "AUTHELIA_${secret_name^^}_FILE=/config/.secrets/${secret_name}" >> "${SECRETS_FILE}"
}

# Generate and save JWT Secret
generate_secret "jwt_secret"

# Generate and save Session Secret
generate_secret "session_secret"

# Generate and save Redis Password
generate_secret "session_redis_password"

# Generate and save Storage Encryption Key
generate_secret "storage_encryption_key"

# Generate and save MariaDB Password
generate_secret "storage_mysql_password"

# Generate and save OIDC HMAC Secret
generate_secret "identity_providers_oidc_hmac_secret"

# Prompt for SMTP Password
echo "Enter SMTP password:"
stty -echo
read SMTP
stty echo
echo "${SMTP}" > "${SECRET_DIR}/smtp"
echo "AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE=/config/.secrets/smtp" >> "${SECRETS_FILE}"
echo

# Generate and save OIDC Private Key and Public Key
openssl genrsa -out "${SECRET_DIR}/oidc.pem" 4096
openssl rsa -in "${SECRET_DIR}/oidc.pem" -outform PEM -pubout -out "${SECRET_DIR}/oidc.pub.pem"
echo "AUTHELIA_IDENTITY_PROVIDERS_OIDC_ISSUER_PRIVATE_KEY_FILE=/config/.secrets/oidc.pem" >> "${SECRETS_FILE}"
echo "AUTHELIA_IDENTITY_PROVIDERS_OIDC_ISSUER_PUBLIC_KEY_FILE=/config/.secrets/oidc.pub.pem" >> "${SECRETS_FILE}"

# Prompt for domain name for the TLS certificate
echo "Enter the domain name for the TLS certificate (e.g., yourdomain.com):"
read DOMAIN

# Generate and save TLS Private Key and Certificate
openssl genpkey -algorithm RSA -out "${SECRET_DIR}/tlskey.pem" -pkeyopt rsa_keygen_bits:4096
openssl req -new -key "${SECRET_DIR}/tlskey.pem" -out "${SECRET_DIR}/tlskey.csr" -subj "/CN=${DOMAIN}"
openssl x509 -req -days 365 -in "${SECRET_DIR}/tlskey.csr" -signkey "${SECRET_DIR}/tlskey.pem" -out "${SECRET_DIR}/tlscert.pem"
rm "${SECRET_DIR}/tlskey.csr" # Remove CSR as it's no longer needed
echo "AUTHELIA_SERVER_TLS_KEY_FILE=/config/.secrets/tlskey.pem" >> "${SECRETS_FILE}"
echo "AUTHELIA_SERVER_TLS_CERTIFICATE_FILE=/config/.secrets/tlscert.pem" >> "${SECRETS_FILE}"

# Set the correct privileges
chmod 600 -R "${SECRET_DIR}"

echo "Secrets generated and saved in ${SECRET_DIR}"
echo "Environment variable mappings saved in ${SECRETS_FILE}"
