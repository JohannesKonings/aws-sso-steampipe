#!/bin/bash

#https://gist.github.com/lukeplausin/3cfedc29755e184ef526b504c77ffe70

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

rm -rf ~/.aws/config_append
at_filename=$(ls ~/.aws/sso/cache/*.json | grep -v botocore | head -n 1)
at=$(cat $at_filename | jq -r '.accessToken')
start_url=$(cat $at_filename | jq -r '.startUrl')
region=$(cat $at_filename | jq -r '.region')

# Iterate account list
available_accounts=$(aws sso list-accounts --region "$region" --access-token "$at")
n_accounts=$(echo $available_accounts | jq '.accountList | length')
echo "Accounts found: $n_accounts"

account_list=$(echo $available_accounts | jq -r '.accountList | .[] | .accountId')

while IFS= read account_id ; do
    echo "account: $account_id"
    account_data=$( echo $available_accounts | jq -r ".accountList | .[] | select( .accountId == \"$account_id\" )" )
    account_name=$(echo $account_data | jq -r '.accountName // .accountId' | xargs | tr -d "[:space:]")
    account_roles=$(aws sso list-account-roles --region "$region" --access-token "$at" --account-id $account_id)
    role_names=$(echo $account_roles | jq -r '.roleList | .[] | .roleName')
    while read role_name ; do
        echo "  role: $role_name"
        config_profile_name="$account_name-$role_name"
        hit=$(cat ~/.aws/config | grep $config_profile_name || echo "")
        if [ -z "$hit" ] ; then
            echo "    profile: $config_profile_name not found, adding to config..."
            cat << EOF >> ~/.aws/config_append
[profile $config_profile_name]
sso_session = $SSO_SESSION_NAME
sso_account_id = $account_id
sso_role_name = $role_name
region = $region
EOF
        else
            echo "    profile: $config_profile_name found, doing nothing..."
        fi
    done < <(printf '%s\n' "$role_names")
done < <(printf '%s\n' "$account_list")

echo ""
echo ""
echo "The following config will be appended to your ~/.aws/config file:"
cat ~/.aws/config_append
echo ""
read -p "Do want to proceed? [y/n] " yn
case $yn in
    [Yy]* ) cat ~/.aws/config_append >> ~/.aws/config; echo "committed!"; ;;
    * ) echo "cancelled!";;
esac
echo "cleaning up..."
rm ~/.aws/config_append
echo "Done!"