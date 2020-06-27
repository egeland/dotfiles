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
