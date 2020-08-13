#!/bin/bash -x

if [[ -f ~/.gnupg/.import_done ]]; then
    echo "GNUPG Secret already imported"
    exit 0
fi

echo -n "Bitwarden login: "
bw login --check || bw login

until bw unlock --check
do
    echo "Enter Master Password: "
    export BW_SESSION=$(bw --raw unlock)
done

export GPG_FOLDER_ID=$(bw list folders --search GPG | jq -r '.[0].id')

unset GPG_FINALITEM

for row in $(bw list items --folderid "$GPG_FOLDER_ID" | jq -r -c 'sort_by(.name) |.[] | @base64')
do
    GPG_KEY_NAME="$(echo "${row}" | base64 --decode | jq -r '.name')"
    GPG_KEY_VALUE=$(echo "${row}" | base64 --decode | jq -r '.notes')
    echo "Adding ${GPG_KEY_NAME}"
    export GPG_FINALITEM="${GPG_FINALITEM}${GPG_KEY_VALUE}"
done

echo "Importing key"
echo "${GPG_FINALITEM}" | gpg --import && \
unset GPG_FINALITEM && \
touch ~/.gnupg/.import_done
