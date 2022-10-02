#!/bin/bash

repo_url=$(git remote -v | grep -m1 "^origin" | sed -Ene's@.*(https://[^[:space:]]*).*@\1@p')
if [ -z "$repo_url" ]; then
    echo "ERROR: could not get repo url."
    echo "NOTE: maybe you are already using SSH"
    exit 1
fi

username=$(echo "$repo_url" | sed -Ene's@https://github.com/([^/]*)/(.*).git@\1@p')
if [ -z "$username" ]; then
    echo "ERROR: could not get username"
    exit 1
fi

repo=$(echo "$repo_url" | sed -Ene's@https://github.com/([^/]*)/(.*).git@\2@p')
if [ -z "$repo" ]; then
    echo "ERROR: could not get repo name"
    exit
fi

new_url="git@github.com:$username/$repo.git"

git remote set-url origin "$new_url"

echo -e "Changed repo url from\n $repo_url\n to\n $new_url"
