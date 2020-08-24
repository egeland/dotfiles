# Defined in - @ line 1
function docker_orig --wraps='ln -f -s config.json.orig ~/.docker/config.json' --description 'alias docker_orig ln -f -s config.json.orig ~/.docker/config.json'
  ln -f -s config.json.orig ~/.docker/config.json $argv;
end
