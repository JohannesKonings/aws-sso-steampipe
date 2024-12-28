FROM ghcr.io/turbot/steampipe

# Setup prerequisites (as root)
USER root:0
RUN apt-get update -y \
 && apt-get install -y git curl unzip jq python3-pip python3-venv

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
 && unzip awscliv2.zip \
 && ./aws/install \
 && rm -rf awscliv2.zip ./aws

# Install pipx
RUN pip3 install pipx

# Update steampipe to current version
RUN /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)"

# Install the aws and steampipe plugins for Steampipe (as steampipe user).
USER steampipe:0
RUN steampipe plugin install steampipe aws

# Install aws-sso-util for steampipe user
RUN pipx install aws-sso-util && pipx ensurepath
