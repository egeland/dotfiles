# Use starship for prompt magic
starship init fish | source

# Activate python virtual env
source ~/py3/bin/activate.fish

# Ensure Homebrew-installed stuff is happy
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# Set up AWS defaults
set -x AWS_REGION "ap-southeast-2"
set -x AWS_PROFILE "saml"
set -x AWS_DEFAULT_PROFILE "saml"

# Set up fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end
