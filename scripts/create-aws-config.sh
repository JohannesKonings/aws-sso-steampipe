#!/bin/bash

if [ ! -f .env ] ; then
    echo "ERROR: .env file not found!"
    exit 1
else
    source .env
fi
if [ -z "$SSO_START_URL" ] ; then
    echo "ERROR: SSO_START_URL not set in .env file!"
    exit 1
fi
if [ -z "$SSO_SESSION_NAME" ] ; then
    echo "ERROR: SSO_SESSION_NAME not set in .env file!"
    exit 1
fi
if [ -z "$SSO_REGION" ] ; then
    echo "ERROR: REGION not set in .env file!"
    exit 1
fi

mkdir -p ~/.aws
touch ~/.aws/config
cat << EOF > ~/.aws/config
[sso-session $SSO_SESSION_NAME]
sso_start_url = $SSO_START_URL
sso_region = $SSO_REGION
sso_registration_scopes = sso:account:access
EOF
