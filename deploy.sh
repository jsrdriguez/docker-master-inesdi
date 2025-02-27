#!/usr/bin/env bash

# LOAD ENVIROMENT

if [ -f .env ]; then
  source .env
else 
  echo "Enviroment file not found"
  exit 1
fi

echo "[*] Container services up..."
if ! docker-compose up -d --force-recreate --build; then
    echo "Failed creation services $1"
    return 1
fi
