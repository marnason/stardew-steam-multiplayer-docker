#!/usr/bin/env bash
# Build and run Stardew Valley multiplayer server

echo "=== Stardew Valley Multiplayer Server Setup ==="
echo ""

# Check if override file exists
if [ ! -f "docker-compose-steam.override.yml" ]; then
    echo "ERROR: docker-compose-steam.override.yml not found!"
    echo ""
    echo "Please create this file with your Steam credentials:"
    echo "1. Copy docker-compose-steam.override.yml.example (if it exists)"
    echo "2. Or run ./get-steam-login-key.sh to generate a login key"
    echo "3. Fill in your STEAM_USER and STEAM_LOGIN_KEY in the override file"
    exit 1
fi

# Check if the override file has placeholder values
if grep -q "username" docker-compose-steam.override.yml && grep -q "qwerty123456" docker-compose-steam.override.yml; then
    echo "WARNING: It looks like you're using placeholder values in docker-compose-steam.override.yml"
    echo ""
    echo "Please update the file with your actual Steam credentials:"
    echo "- STEAM_USER: your Steam username"
    echo "- STEAM_LOGIN_KEY: your Steam login key"
    echo ""
    echo "To generate a login key, run: ./get-steam-login-key.sh"
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "Starting Stardew Valley server..."
docker compose \
  -f docker-compose-steam.yml \
  -f docker-compose-steam.override.yml \
  up --build -d

echo ""
echo "Server is starting up!"
echo "- VNC: localhost:5902 (password: insecure)"
echo "- Web UI: http://localhost:5801"
echo "- Game port: 24642/udp"