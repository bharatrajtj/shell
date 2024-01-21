#!/bin/bash

# GitHub Documentation for Listing issues
# https://api.github.com/repos/OWNER/REPO/issues

# Get the URL part from the Listing issues command
URL="https://api.github.com"

# Get GitHub username and token values from user
# In GitHub dashboard Settings--DeveloperSettings--PersonalAccessToken--Tokens(clasic)
# Export both username and token before executing the script
USERNAME="$username"
TOKEN="$token"

# Get the name of repo owner and repository that are endpoints of the URL from users
REPO_OWNER="$1"
REPO_NAME="$2"

function github_api_get {
    local endpoint="$1"
    local url="${URL}/${endpoint}"

    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

function list {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/issues"

    # Use jq to parse json output and get the login id for an object that satisfies the logic
    issues="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.admin == true) | .login')"

    if [[ -z "$issues" ]]; then
        echo "No users found with admin access."
    else
        echo "Users with admin access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$issues"
    fi
}

# Main script
echo "Listing users with admin access to ${REPO_OWNER}/${REPO_NAME}..."
list
