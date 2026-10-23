function grok-ws
    set root (jj root)
    or return 1
    set dest ~/tmp/(basename $root)-(random)
    jj workspace add -r @- $dest
    or return 1
    pushd $dest
    grok --trust $argv
    set code $status
    popd
    jj workspace remove (basename $dest)
    return $code
end
