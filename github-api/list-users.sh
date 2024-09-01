#!/bin/bash

#######################
# About: Script prints the names of members of a particular repository
# Date: 2nd Sept 2024
# Inputs: 
#     export username="PUT_YOUR_USERNAME_HERE"
#     export token="PUT_YOUR_GITHUB_TOKEN_HERE"
# Owner: Ayush
#######################

helper()

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

function helper {
 expected_cmd_args=2
 if [ $# -ne expected_cmd_args]; then
 echo "Please execute the script with required cmd args"
 echo "arg 1 : OWNER_NAME"
 echo "arg 2 : REPO_NAME"
 echo "Put these arguments like ./list-users.sh OWNER_NAME REPO_NAME"
 fi
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
