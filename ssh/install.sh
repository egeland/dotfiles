#!/usr/local/bin/bash

echo -n "Bitwarden login: "
bw login --check || bw login

until bw unlock --check
do
    echo "Enter Master Password: "
    export BW_SESSION=$(bw --raw unlock)
done

export SSH_FOLDER_ID=$(bw list folders --search SSH | jq -r '.[0].id')

if [[ ! -d ~/.ssh ]]; then
    mkdir ~/.ssh && chmod 700 ~/.ssh
fi

for row in $(bw list items --folderid "$SSH_FOLDER_ID" | jq -r -c '.[] | @base64')
do
    SSH_KEY_NAME="$(echo "${row}" | base64 --decode | jq -r '.name')"
    SSH_KEY_VALUE=$(echo "${row}" | base64 --decode | jq -r '.notes')
    echo "${SSH_KEY_NAME}:"
    if [[ -f ~/"${SSH_KEY_NAME}" ]]; then
        echo "EXISTS - skipping"
    else
        echo "Not found - adding now"
        echo "${SSH_KEY_VALUE}" > ~/"${SSH_KEY_NAME}"
        chmod 700 ~/"${SSH_KEY_NAME}"
    fi
done
