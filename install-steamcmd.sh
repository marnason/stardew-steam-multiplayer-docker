#!/usr/bin/env bash
set -euo pipefail

# 1. Enable i386 multi-arch so we can install 32-bit libs
dpkg --add-architecture i386
apt-get update

# 2. Install dependencies (including the 32-bit loader and netcat-openbsd)
apt-get install -y \
    wget \
    unzip \
    tar \
    strace \
    mono-complete \
    xterm \
    gettext-base \
    jq \
    procps \
    locales \
    lib32gcc-s1 \
    libc6:i386 \
    libstdc++6:i386 \
    netcat-openbsd \
 && apt-get clean

# 3. Create SteamCMD install directory
STEAMCMD_DIR="/data/steamcmd"
mkdir -p "${STEAMCMD_DIR}"

# 4. Download and extract SteamCMD
TMPDIR="$(mktemp -d)"
(
  cd "${TMPDIR}"
  wget -qO steamcmd_linux.tar.gz \
    https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
  tar -xzf steamcmd_linux.tar.gz -C "${STEAMCMD_DIR}"
)
rm -rf "${TMPDIR}"

# 5. Generate en_US.UTF-8 locale (required by Steam)
sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales

# 6. Run SteamCMD once to update and quit
"${STEAMCMD_DIR}/steamcmd.sh" +quit

# 7. Install a global 'steamcmd' wrapper
cat << 'EOF' > /usr/local/bin/steamcmd
#!/usr/bin/env bash
exec /data/steamcmd/steamcmd.sh "$@"
EOF
chmod +x /usr/local/bin/steamcmd

echo "SteamCMD installed in ${STEAMCMD_DIR}"
echo "'steamcmd' wrapper created in /usr/local/bin"