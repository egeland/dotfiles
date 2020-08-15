# Defined in - @ line 1
function publicip --wraps='dig +short myip.opendns.com @resolver1.opendns.com' --description 'alias publicip dig +short myip.opendns.com @resolver1.opendns.com'
  dig +short myip.opendns.com @resolver1.opendns.com $argv;
end
