FROM debian:bookworm-slim

# Setup prerequisites
RUN apt-get update -y \
 && apt-get install -y git curl unzip jq python3-pip python3-venv \
 && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
 && unzip awscliv2.zip \
 && ./aws/install \
 && rm -rf awscliv2.zip ./aws

# Install pipx
RUN pip3 install --break-system-packages pipx

# Create steampipe user
RUN useradd -m -s /bin/bash steampipe

# Install Steampipe
RUN curl -fsSL https://steampipe.io/install/steampipe.sh | sh

# Switch to steampipe user for plugin installation
USER steampipe
WORKDIR /home/steampipe

# Install the aws and steampipe plugins for Steampipe
RUN steampipe plugin install steampipe aws

# Install aws-sso-util
RUN pipx install aws-sso-util && pipx ensurepath

WORKDIR /workspace
