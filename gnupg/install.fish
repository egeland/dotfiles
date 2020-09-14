#!/usr/bin/fish

if test -e ~/.gnupg/.import_done
    echo "GPG Secret Keys already imported"
    exit 0
end

read -P 'BitWarden Master Password: ' --silent bw_pass

bw login --check || bw login egeland@gmail.com $bw_pass
bw unlock --check || set BW_SESSION (bw --raw unlock $bw_pass)

set gpg_decrypt_pw (bw list items --search gpg_github-stored_keys | jq -r '.[].login.password')

gpg --pinentry-mode loopback --batch --passphrase $gpg_decrypt_pw --decrypt ~/.dotfiles/gnupg/secret_gpg_keys.gpg | gpg --batch --import

touch ~/.gnupg/.import_done
