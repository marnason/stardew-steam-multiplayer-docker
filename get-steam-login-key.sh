#!/usr/bin/env bash
# Generate Steam login key for use with docker-compose

echo "=== Steam Login Key Generator ==="
echo ""
echo "This script will help you generate a Steam login key that can be used"
echo "for automated authentication without Steam Guard prompts."
echo ""

read -p "Steam username: " STEAM_USER
read -s -p "Steam password: " STEAM_PASS
echo
read -p "Steam Guard code: " STEAM_GUARD

echo ""
echo "Attempting to authenticate with Steam..."
echo "This will generate a login key that you can use in docker-compose-steam.override.yml"
echo ""

# Run steamcmd with provided credentials
steamcmd +set_steam_guard_code "$STEAM_GUARD" +login "$STEAM_USER" "$STEAM_PASS" +quit

echo ""
echo "=== IMPORTANT ==="
echo "If the login was successful, SteamCMD should have displayed a login key above."
echo "Look for a line that shows something like:"
echo "  'your_username' logged in OK, saved login key"
echo ""
echo "Copy that login key and add it to your docker-compose-steam.override.yml file:"
echo ""
echo "services:"
echo "  valley:"
echo "    build:"
echo "      args:"
echo "        STEAM_USER: \"$STEAM_USER\""
echo "        STEAM_LOGIN_KEY: \"YOUR_LOGIN_KEY_HERE\""
echo ""
echo "Then run: ./install-stardew.sh"
echo ""
