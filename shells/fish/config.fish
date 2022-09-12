# Use starship for prompt magic
starship init fish | source

# Activate python virtual env
source ~/py3/bin/activate.fish

# Ensure Homebrew-installed stuff is happy
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# Add ~/bin to path
set -g -a fish_user_paths ~/bin
set -g -a fish_user_paths ~/git/github/tfenv/bin

# Set up AWS defaults
#set -x AWS_REGION "ap-southeast-2"
set -x AWS_PROFILE "default"
set -x AWS_DEFAULT_PROFILE "default"

# Set up fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Set up various completions
#/usr/local/bin/kind completion fish | source
zoxide init fish --cmd c | source

# Set GPG TTY - needed for agent to do the right thing
set -g -x GPG_TTY (tty)
set -g -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
