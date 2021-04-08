# Use starship for prompt magic
starship init fish | source

# Activate python virtual env
source ~/py3/bin/activate.fish

# Ensure we use LTS nodejs
nvm use --silent default

# Ensure Homebrew-installed stuff is happy
# set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# Add ~/bin to path
set -g -a fish_user_paths ~/bin

# Set up AWS defaults
# set -x AWS_REGION "ap-southeast-2"
# set -x AWS_PROFILE "saml"
# set -x AWS_DEFAULT_PROFILE "saml"

# Set up fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Set up various completions
zoxide init fish --cmd c | source
k3d completion fish | source

# Set GPG TTY - needed for agent to do the right thing
set -g -x GPG_TTY (tty)
set -g -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
gpg-connect-agent updatestartuptty /bye >/dev/null

