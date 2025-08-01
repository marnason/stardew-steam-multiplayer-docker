#!/usr/bin/env bash
# Prompt for Steam Guard, then build & run with override

read -p "Steam Guard code: " STEAM_GUARD
export STEAM_GUARD

docker compose \
  -f docker-compose-steam.yml \
  -f docker-compose-steam.override.yml \
  up --build -d

unset STEAM_GUARD