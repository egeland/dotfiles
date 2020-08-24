# Defined in - @ line 1
function helm2 --wraps=/usr/local/opt/helm@2/bin/helm --description 'alias helm2 /usr/local/opt/helm@2/bin/helm'
  /usr/local/opt/helm@2/bin/helm  $argv;
end
