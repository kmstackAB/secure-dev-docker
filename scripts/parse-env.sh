#!/bin/bash
set -x

echo "[INFO] Extracting passwords and environment variables from dev.config.ini..."

# Ensure the /root/dev.config.ini file exists before attempting to extract variables
if [[ ! -f /root/dev.config.ini ]]; then
  echo "[ERROR] /root/dev.config.ini not found."
  exit 1
else
    echo "[INFO] Extracting variables..."
fi

# Extract values from the config file
export DATABASE=$(grep -oP '^SERVER_DB\s*=\s*\K.*' /root/dev.config.ini)
export SERVER_USER=$(grep -oP '^SERVER_USER\s*=\s*\K.*' /root/dev.config.ini)
export SERVER_PSW=$(grep -oP '^SERVER_PSW\s*=\s*\K.*' /root/dev.config.ini)
export ADMIN_ROLE_PASSWORD=$(grep -oP '^ADMIN_ROLE_PASSWORD\s*=\s*\K.*' /root/dev.config.ini)

# Check if any required variables are missing and exit if so
if [[ -z "$DATABASE" || -z "$SERVER_USER" || -z "$SERVER_PSW" || -z "$ADMIN_ROLE_PASSWORD" ]]; then
  echo "[ERROR] Missing environment variables. Check /root/dev.config.ini or parsing logic."
  exit 1
fi

echo "DATABASE=$DATABASE" > /generated-env/.env
echo "SERVER_USER=$SERVER_USER" >> /generated-env/.env
echo "ADMIN_ROLE_PASSWORD=$ADMIN_ROLE_PASSWORD" >> /generated-env/.env
echo "POSTGRES_PASSWORD=$SERVER_PSW" >> /generated-env/.env
echo "SCHEMA=auth" >> /generated-env/.env


# Output the parsed variables (for debugging)
echo "[INFO] Variables extracted successfully: "
echo "DATABASE=$DATABASE"
echo "SERVER_USER=$SERVER_USER"
echo "SERVER_PSW=$SERVER_PSW"
echo "ADMIN_ROLE_PASSWORD=$ADMIN_ROLE_PASSWORD"
