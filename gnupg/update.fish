#!/usr/bin/env fish

read -x -P 'BitWarden Master Password: ' --silent bw_pass
read -x -P 'GPG Password: ' --silent gpg_pass

bw login --check || bw login egeland@gmail.com $bw_pass
bw unlock --check || set -x BW_SESSION (bw --raw unlock $bw_pass)

set gpg_encrypt_pass (bw list items --search gpg_github-stored_keys | jq -r '.[].login.password')

gpg --pinentry-mode loopback --batch --passphrase $gpg_pass --export-secret-keys --armor egeland@gmail.com | gpg --pinentry-mode loopback --batch --passphrase $gpg_encrypt_pass --symmetric - > ~/.dotfiles/gnupg/secret_gpg_keys.gpg
