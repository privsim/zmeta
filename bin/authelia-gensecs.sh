#!/bin/bash

# Define the output directory
SECRET_DIR="authelia/secrets"
mkdir -p "${SECRET_DIR}"

# Function to generate a 64-character alphanumeric secret
generate_secret() {
  tr -cd '[:alnum:]' < /dev/urandom | fold -w 64 | head -n 1
}

# Generate and save JWT Secret
generate_secret > "${SECRET_DIR}/jwtsecret"

# Generate and save Session Secret
generate_secret > "${SECRET_DIR}/session"

# Generate and save Storage Encryption Key
generate_secret > "${SECRET_DIR}/storage"

# Generate and save MariaDB Password
generate_secret > "${SECRET_DIR}/mariadb"

# SMTP Password
echo "enter smtp password";
read SMTP;
echo "${SMTP}" > "${SECRET_DIR}/smtp"

# Generate and save OIDC HMAC Secret
generate_secret > "${SECRET_DIR}/oidcsecret"

# Generate and save OIDC Private Key
openssl genrsa -out "${SECRET_DIR}/oidc.key" 4096
openssl rsa -in "${SECRET_DIR}/oidc.key" -outform PEM -pubout -out "${SECRET_DIR}/oidc.pem"

# Set the correct privileges
chmod 600 -R "${SECRET_DIR}"

echo "Secrets generated and saved in ${SECRET_DIR}"
