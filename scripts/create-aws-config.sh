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
if [ -z "$SSO_REGION" ] ; then
    echo "ERROR: REGION not set in .env file!"
    exit 1
fi

aws-sso-util configure populate \
--sso-start-url $SSO_START_URL \
--sso-region $SSO_REGION \
--region $SSO_REGION
