# Defined in - @ line 1
function ip --wraps='dig +short myip.opendns.com @resolver1.opendns.com' --description 'alias ip dig +short myip.opendns.com @resolver1.opendns.com'
  dig +short myip.opendns.com @resolver1.opendns.com $argv;
end
