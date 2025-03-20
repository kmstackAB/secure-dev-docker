#!/bin/bash

# Ensure the SSH directory exists
mkdir -p ~/.ssh

# Disable strict host checking for GitHub (to avoid issues with first-time connections)
echo "Host github.com" >> ~/.ssh/config
echo "  IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config
echo "  StrictHostKeyChecking no" >> ~/.ssh/config
echo "  UserKnownHostsFile=/dev/null" >> ~/.ssh/config

# Make sure Git uses SSH for cloning
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# Check if SSH key is properly set up by testing the connection
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com

# If repo already exists, remove it to force a fresh clone
if [[ -d /workspace/rbac-system/.git ]]; then
  echo "Removing existing cloned repository..."
  rm -rf /workspace/rbac-system
fi

# Clone the repository
echo "Cloning repository from git@github.com:kmstackAB/rbac-system.git..."
git clone git@github.com:kmstackAB/rbac-system.git /workspace/rbac-system || {
    echo "Failed to clone. Check token or permissions."
    exit 1
}

# Debug: List files in the cloned repository
echo "Listing files in the repository directory:"
ls -al /workspace/rbac-system

# Ensure that install_dependencies.sh exists before trying to execute it
if [[ -f /workspace/rbac-system/install_dependencies.sh ]]; then
  echo "Running install_dependencies.sh..."
  cd /workspace/rbac-system
  chmod +x ./install_dependencies.sh
  ./install_dependencies.sh || echo "Install script failed or not needed."
else
  echo "install_dependencies.sh not found, skipping."
fi

# Keep the container alive for VSCode, or run app
exec tail -f /dev/null


ENV PATH="/usr/local/bin:$PATH"


# docker exec -it postgres-db psql -U kmstack_dev_user