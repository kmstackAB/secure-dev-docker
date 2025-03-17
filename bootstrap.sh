
# Copyright (c) 2025 Kmstack Ltd. All rights reserved.
# This software and associated documentation files (the "Software") are owned  
# by Kmstack Ltd and are protected by copyright law. Unauthorized copying,  
# modification, distribution, or use of this software, in whole or in part,  
# is strictly prohibited without prior written permission from Kmstack Ltd.

# Author: Kevin Mukuna  
# Company: Kmstack Ltd  
# Created: 2025  
# License: Proprietary  
# This script performs environment setup, container cleanup, and starts application services.
# Pass -c to clean up old containers and volumes before proceeding with the bootstrap process.


set -euo pipefail

# Trap cleanup on interrupt or error
trap 'echo "[ERROR] Script terminated unexpectedly"; exit 1' INT TERM ERR
trap 'echo "[INFO] Script completed successfully."' EXIT

CLEAN_BUILD=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -c)
            CLEAN_BUILD=true
    esac
    shift
done

if $CLEAN_BUILD; then
    echo "[INFO] Cleaning up old containers and volumes..."

    # Clean up process
    rm -rf generated-env
    mkdir generated-env
    touch generated-env/.env
    docker kill redis-client || true
    docker rm redis-client || true
    docker builder prune -f
    docker-compose down --volumes --remove-orphans || echo "[WARN] docker-compose down failed — continuing."
    docker system prune -a --volumes -f
    rm -rf generated-env
else
  echo "[INFO] Skipping cleanup. Pass -c to clean up."
fi

echo "[INFO] Extracting environment variables from image..."
if docker-compose -f docker-compose.extractor.yml up --build --abort-on-container-exit; then
    echo "[INFO] Environment variable extraction successful"
else
    echo "[ERROR] Failed to extract environment variables"
    exit 1
fi

echo "[INFO] Loading extracted environment variables"
set -a
source ./generated-env/.env
set +a

echo "[INFO] Generating init-final.sql from init.sql using envsubst..."
mkdir -p ./generated-env
envsubst < ./scripts/init.sql > ./generated-env/init-final.sql

if [ ! -f ./generated-env/init-final.sql ]; then
  echo "[ERROR] Missing init-final.sql. Make sure envsubst ran correctly."
  exit 1
fi

echo "[INFO] Starting main application services..."
docker-compose -f docker-compose.yml up -d --build --remove-orphans

echo "[INFO] Waiting for Postgres to be ready..."
until docker exec postgres-db pg_isready -U postgres; do
    echo "[INFO] Waiting for Postgres to be ready..."
    sleep 2
done

echo "[INFO] Postgres is ready."
echo "[INFO] Cleaning up generated-env directory..."
rm -rf generated-env

echo "[INFO] Bootstrap completed successfully ✅"
