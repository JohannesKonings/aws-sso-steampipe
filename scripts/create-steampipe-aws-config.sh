#!/bin/bash

cat << EoF > ~/.steampipe/config/aws.spc
connection "aws_all" {
  plugin      = "aws" 
  type        = "aggregator"
  connections = ["*"]
}

EoF

ALLOWED_ROLES="AWSReadOnlyAccess,AWSAdministratorAccess"

cat ~/.aws/config | grep -E '^\[profile' | sed 's/\[profile //g' | sed 's/\]//g' | while read profile_name ; do

    # check if suffix of profile match with one of the list allowed_roles
    suffix=$(echo $profile_name | sed 's/.*\.//g' | sed 's/.*-//g')
    hit=$(echo $ALLOWED_ROLES | grep -w $suffix || echo "")
    if [ -z "$hit" ] ; then
        echo "Skipping profile $profile_name, suffix $suffix not in allowed roles list" >&2
        continue
    fi


    connection_name=$(echo $profile_name | sed 's/-/_/g' | tr '[:upper:]' '[:lower:]')  
    echo "connection \"${connection_name}\" {"
    echo "  plugin = \"aws\""
    echo "  profile = \"${profile_name}\""
    echo "  regions = [\"eu-central-1\""]
    echo "}"
    echo ""
done >> ~/.steampipe/config/aws.spc
