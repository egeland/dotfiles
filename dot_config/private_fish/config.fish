if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init --cmd c fish | source
    alias ls='lsd'
    alias l='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lt='ls -lhtr'
    alias pie='LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 pi'
    fish_vi_key_bindings
end

# Added by LM Studio CLI tool (lms)
set -gx PATH $PATH /Users/frode/.lmstudio/bin
set -gx PATH $PATH /Users/frode/.local/bin
