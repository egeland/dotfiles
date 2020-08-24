# Defined in - @ line 1
function docker_ecr --wraps='ln -f -s config.json.ecr ~/.docker/config.json' --description 'alias docker_ecr ln -f -s config.json.ecr ~/.docker/config.json'
  ln -f -s config.json.ecr ~/.docker/config.json $argv;
end
