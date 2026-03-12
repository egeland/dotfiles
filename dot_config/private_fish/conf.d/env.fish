fish_add_path /opt/homebrew/share/google-cloud-sdk/bin

# Load ~/.env
if test -f ~/.env
    while read -l line
        if string match -qr '^[^#[:space:]]' -- $line
            set -l parts (string split -m 1 '=' -- $line)
            set -gx $parts[1] $parts[2]
        end
    end < ~/.env
end
