
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NVM_DIR="/Users/fegeland/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

source ~/.bash_aliases
export AWS_REGION=ap-southeast-2

export HISTCONTROL=ignoreboth:erasedups


# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/fegeland/.config/yarn/global/node_modules/tabtab/.completions/serverless.bash ] && . /Users/fegeland/.config/yarn/global/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/fegeland/.config/yarn/global/node_modules/tabtab/.completions/sls.bash ] && . /Users/fegeland/.config/yarn/global/node_modules/tabtab/.completions/sls.bash

complete -C /usr/local/bin/terraform terraform
