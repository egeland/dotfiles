#!/bin/bash

FONTDIR=~/.local/share/fonts

[[ -f "$FONTDIR/jetbrains_mono_nerd.ttf" ]] && exit 0

mkdir -p "$FONTDIR"

curl -fsSL -o "$FONTDIR/jetbrains_mono_nerd.ttf" 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf' 

fc-cache -fv

