if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init --cmd c fish | source
    alias ls='lsd'
    alias l='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lt='ls -lhtr'
end
