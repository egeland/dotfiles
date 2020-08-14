#!/bin/bash

FONTDIR=~/.local/share/fonts

[[ -f "$FONTDIR/.installed" ]] && exit 0

mkdir -p "$FONTDIR"

cd "$FONTDIR"

wget 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf'

fc-cache -f -v

touch .installed

