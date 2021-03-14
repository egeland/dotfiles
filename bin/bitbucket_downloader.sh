#!/bin/bash

USER=${1}
TEAM=${2}

read -sp "Enter App Password: " PASSWORD

REPOS_FILE=$(mktemp /tmp/bitbucket_downloader.XXXXXX)

USER="${USER}:${PASSWORD}"

mkdir -p "$TEAM" && cd $TEAM

NEXT_URL="https://api.bitbucket.org/2.0/repositories/${TEAM}?pagelen=100"

while [ ! -z $NEXT_URL ]
do
    curl -u "$USER" $NEXT_URL > repoinfo.json
    jq -r '.values[] | .links.clone[1].href' repoinfo.json >> "$REPOS_FILE"
    NEXT_URL=`jq -r '.next' repoinfo.json`
done

for repo in `cat "$REPOS_FILE"`
do
    if [[ -d "$(echo $repo | cut -d '/' -f 2 | cut -d '.' -f 1)" ]]; then
        echo "Skipping $repo as it exists already"
    else
        echo "Cloning" $repo
        if echo "$repo" | grep -q ".git"; then
            command="git"
        else
            command="hg"
        fi
        $command clone $repo
    fi
done

rm -f repoinfo.json
cd ..
rm -f "$REPOS_FILE"
