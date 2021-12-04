# Defined in - @ line 1
function ip --wraps='curl -4 -s ifconfig.co' --description 'alias ip curl -4 -s ifconfig.co'
  curl -4 -s ifconfig.co $argv;
end
