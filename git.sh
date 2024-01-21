#!/bin/bash

#GitHubDocumentationforListingissues
#https://api.github.com/repos/OWNER/REPO/issues

#get the URL part from the Listing issues command
URL="https://api.github.com"  

#Get Github username and token values from user
#In GitHub dashboard Settings--DeveloperSettings--PersonalAccessToken--Tokens(clasic)
#Export both username and token before executing the script
USERNAME="$username"
TOKEN="$token"

#get the name of repo owner and repository that are endpoint of the URL from users
REPO_OWNER=$1
REPO_NAME=$2


function api_get {
     local endpoint="$1"  #gets the placholder replaced by the value of endpoint
     local url="${URL}/${endpoint}"  #calls the value of URL and endpoint to form the listing issues command
     
      curl -s -u "${USERNAME}:${TOKEN}" "$url"   #-u gets the username and token

}

function list {
      local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/issues  #copy endpoint part of the command wit repo owner and repo name as placeholders

#use jq to parse json output and get the login id for object that satisfies the logic
      issues="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.admin == true ) | .login' )"

      if [[ -z "$issues" ]]; then
         echo " no users found"
      else
          echo "users with read access to ${REPO_OWNER}/${REPO_NAME}:"
          echo "$issues"
      fi       
  }

# Main script
echo "Listing users with admin access to ${REPO_OWNER}/${REPO_NAME}..."
list
