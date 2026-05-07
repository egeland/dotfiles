if status is-interactive
    # Load credentials from .env for MCP servers
    if test -f ~/.env
        while read -l line
            if string match -qr '^[A-Z_]+=' $line
                set -l key (string split -m1 '=' $line)[1]
                set -l value (string split -m1 '=' $line)[2]
                set -x $key $value
            end
        end < ~/.env
    end

    # Commands to run in interactive sessions can go here
    zoxide init --cmd c fish | source
    alias ls='lsd'
    alias l='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lt='ls -lhtr'
    fish_vi_key_bindings
end
