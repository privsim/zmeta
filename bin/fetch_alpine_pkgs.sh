#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# CONFIGURATION
# ---------------------------------------------------------------------------

# 1) Alpine version used on the Pi:
ALPINE_VERSION="3.21.3"

# 2) Alpine architecture (64-bit on RPi 3/4/5 is typically 'aarch64'):
ALPINE_ARCH="aarch64"

# 3) Docker platform string (64-bit ARM is usually 'linux/arm64'):
DOCKER_PLATFORM="linux/arm64"

# 4) List of packages you need, plus dependencies. Add/remove as necessary.
PACKAGES=(
  # Dev tools
  build-base
  git
  openssh
  curl
  wget

  # Go & Rust
  go
  rust
  cargo

  # GPG & encryption
  gnupg
  cryptsetup
  e2fsprogs
  parted

  # YubiKey tools
  pcsc-lite
  pcsc-lite-dev
  pcsc-lite-libs
  ccid
  ykpers
  yubico-piv-tool
  opensc

  # Python and pip (for possibly installing 'ykman' or other Python utilities)
  py3-pip
)

# 5) Local output directory on your Mac for storing fetched .apk files.
OUTPUT_DIR="$PWD/alpine_offline_packages"
# ---------------------------------------------------------------------------

echo "==> Creating output directory: $OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

echo "==> Pulling Alpine:$ALPINE_VERSION (platform: $DOCKER_PLATFORM) and fetching packages"
docker run --rm -it \
  --platform="$DOCKER_PLATFORM" \
  -v "$OUTPUT_DIR":/packages \
  alpine:"$ALPINE_VERSION" \
  sh -c "
    echo 'https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION%.*}/main' >> /etc/apk/repositories
    echo 'https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION%.*}/community' >> /etc/apk/repositories
    
    # If your Pi image is a 'rolling/edge' or something else, adjust above lines accordingly.
    # For example, if you actually need 'edge' repos:
    # echo 'https://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories
    # echo 'https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories
    # echo 'https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

    apk update
    # Install apk-tools-static so we can reliably fetch .apk files
    apk add apk-tools-static

    # Download .apk files (including dependencies) into /packages
    apk fetch --output /packages ${PACKAGES[*]}
  "

echo "==> Fetched .apk packages are now in: $OUTPUT_DIR"
echo "==> Copy that folder to a USB drive for offline install on the Pi."
