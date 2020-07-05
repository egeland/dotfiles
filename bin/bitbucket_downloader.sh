#!/bin/bash

USER=${1}
TEAM=${2}

rm -rf "$TEAM" && mkdir "$TEAM" && cd $TEAM

NEXT_URL="https://api.bitbucket.org/2.0/repositories/${TEAM}?pagelen=100"

while [ ! -z $NEXT_URL ]
do
    curl -u $USER $NEXT_URL > repoinfo.json
    jq -r '.values[] | .links.clone[1].href' repoinfo.json > ../repos.txt
    NEXT_URL=`jq -r '.next' repoinfo.json`

    for repo in `cat ../repos.txt`
    do
        echo "Cloning" $repo
        if echo "$repo" | grep -q ".git"; then
            command="git"
        else
            command="hg"
        fi
        $command clone $repo
    done
done

cd ..
