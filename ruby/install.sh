#!/usr/local/bin/bash

if [[ -f ~/.bundle/config ]]; then
    echo "Bundle config already imported"
    exit 0
fi

echo -n "Bitwarden login: "
bw login --check || bw login

until bw unlock --check
do
    echo "Enter Master Password: "
    export BW_SESSION=$(bw --raw unlock)
done
mkdir -p ~/.bundle
bw get item --raw 'bf5d91ca-36cc-4d74-970c-abe800869f97' | jq -r '.notes' > ~/.bundle/config
