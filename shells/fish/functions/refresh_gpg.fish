# Defined in - @ line 1
function refresh_gpg --wraps='gpg-connect-agent updatestartuptty /bye >/dev/null' --description 'alias refresh_gpg=gpg-connect-agent updatestartuptty /bye >/dev/null'
  gpg-connect-agent updatestartuptty /bye >/dev/null $argv;
end
