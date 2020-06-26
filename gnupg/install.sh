#!/usr/local/bin/bash -x

echo -n "Bitwarden login: "
bw login --check || bw login

until bw unlock --check
do
    echo "Enter Master Password: "
    export BW_SESSION=$(bw --raw unlock)
done

# export GPG_FOLDER_ID=$(bw list folders --search GPG | jq -r '.[0].id')

export DECODE_PASSWORD=$(bw get item "87604617-5c5e-4af6-83aa-abe600907a16" | jq -r '.notes')

gpg --passphrase "${DECODE_PASSWORD}" --batch --no-use-agent --decrypt gnupg/secret_keys.enc | gpg --import
