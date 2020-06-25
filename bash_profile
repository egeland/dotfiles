
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

[[ -s "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# https://github.com/cantino/mcfly
if [[ -f "$(brew --prefix)/opt/mcfly/mcfly.bash" ]]; then
  source "$(brew --prefix)/opt/mcfly/mcfly.bash"
fi

# rename iTerm2 sessions
function title {
    echo -ne "\033]0;"$*"\007"
}

source ~/py3/bin/activate

[ -f ~/py3/bin/aws_bash_completer ] && source aws_bash_completer
[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
[ -f /usr/local/bin/kubectl ] && source <(/usr/local/bin/kubectl completion bash)
[ -f /usr/local/etc/bash_completion.d/git-completion.bash ] && source /usr/local/etc/bash_completion.d/git-completion.bash

export AWS_REGION=ap-southeast-2
export FFXIAM_PROFILE=white-iam
export EDITOR=/usr/bin/vim

export PATH="$PATH:$HOME/bin:$HOME/go/bin:/usr/local/sbin" # Add my ~/bin and go/bin to PATH for scripting

function _update_ps1() {
    PS1="$(~/bin/powerline-shell.py --mode compatible $? 2> /dev/null)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

export HISTSIZE=20000
export HISTFILESIZE=25000
export HISTIGNORE='&:[ ]*'

export KOPS_STATE_STORE=s3://ffxblue-infrastructure-kubernetes-shared-v1
source <(kops completion ${SHELL##*/})

dadjoke
complete -C /usr/local/bin/kustomize kustomize
