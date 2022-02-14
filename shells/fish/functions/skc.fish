function skc --wraps='skopeo --override-os linux --override-arch amd64 copy' --description 'alias skc skopeo --override-os linux --override-arch amd64 copy'
  skopeo --override-os linux --override-arch amd64 copy $argv; 
end
