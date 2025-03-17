# syntax=docker/dockerfile:1.4

# Use kmstack-bare-image as base
FROM ghcr.io/kmstackab/kmstack-bare-image:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools for secure-dev-docker
RUN apt-get update && apt-get install -y \
    git \
    curl \
    grep \
    libpq-dev \
    postgresql \
    redis-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create workspace directory
RUN mkdir -p /workspace

# Copy entrypoint script into the image
COPY ./scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set default work directory
WORKDIR /workspace

# Ensure the proper permissions for SSH keys (user_rsa in this case)
COPY user_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

ENTRYPOINT ["/entrypoint.sh"]
