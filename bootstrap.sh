#!/bin/bash
set -euo pipefail

# Trap cleanup on interrupt or error
trap 'echo "[ERROR] Script terminated unexpectedly"; exit 1' INT TERM ERR
trap 'echo "[INFO] Script completed successfully."' EXIT

echo "[INFO] Cleaning up old containers and volumes..."
rm -rf generated-env
mkdir generated-env
touch generated-env/.env
docker builder prune -f
docker-compose down --volumes --remove-orphans || echo "[WARN] docker-compose down failed — continuing."
docker system prune -a --volumes -f
rm -rf generated-env

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
