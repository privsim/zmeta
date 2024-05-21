#!/bin/bash

# Ensure the script is run with sudo, but not directly as root
if [ "$EUID" -eq 0 ] && [ "$SUDO_USER" != "" ]; then 
  echo "Script is running with sudo as user: $SUDO_USER"
  USER=$SUDO_USER
else
  echo "Please run this script with sudo, not as the root user."
  exit
fi

# Step 1: Install necessary packages
sudo apt install -y libpam-yubico yubikey-personalization yubikey-manager

# Function to check for Yubikey presence
check_yubikey() {
  while true; do
    if ykman list | grep -q 'YubiKey'; then
      echo "Yubikey detected."
      break
    else
      read -p "Please insert your Yubikey and press Enter to continue..."
    fi
  done
}

# Function to configure a Yubikey slot
configure_yubikey_slot() {
  check_yubikey
  read -p "Do you want to configure Yubikey slot 2 for challenge-response? This will overwrite any existing configuration. (y/n) " CONFIGURE
  if [ "$CONFIGURE" == "y" ]; then
    echo "Configuring Yubikey slot 2 for challenge-response."
    sudo ykman otp chalresp -g 2
  else
    echo "Skipping Yubikey configuration for slot 2."
  fi

  # Step 3: Set up challenge-response storage
  sudo mkdir -p /var/yubico
  sudo chown root:root /var/yubico
  sudo chmod 700 /var/yubico

  # Step 4: Move and secure the challenge-response file
  sudo -u $USER ykpamcfg -2 -v
  CHALLENGE=$(sudo -u $USER ykpamcfg -2 -v | grep -o 'challenge-[0-9]*')
  SERIAL=$(echo $CHALLENGE | grep -o '[0-9]*')
  sudo mv /home/$USER/.yubico/$CHALLENGE /var/yubico/${USER}-${SERIAL}
  sudo chown root:root /var/yubico/${USER}-${SERIAL}
  sudo chmod 600 /var/yubico/${USER}-${SERIAL}
}

# Step 2: Configure multiple Yubikeys
while true; do
  configure_yubikey_slot
  read -p "Do you want to configure another Yubikey? (y/n) " CONFIGURE_ANOTHER
  if [ "$CONFIGURE_ANOTHER" != "y" ]; then
    break
  fi
  read -p "Please switch to the next Yubikey and press Enter to continue..."
done

# Step 5: Configure PAM
sudo dpkg-reconfigure libpam-yubico

# Update /etc/pam.d/common-auth
sudo sed -i 's/^auth.*required.*pam_unix.so$/auth sufficient pam_yubico.so mode=challenge-response chalresp_path=\/var\/yubico\n&/' /etc/pam.d/common-auth

# Optional: Make Yubikey required
# Uncomment the following line to make Yubikey required
# sudo sed -i 's/auth sufficient pam_yubico.so/auth required pam_yubico.so/' /etc/pam.d/common-auth

echo "Yubikey setup complete. Please test your configuration."

