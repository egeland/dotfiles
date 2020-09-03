#!/usr/bin/fish

if not test -e /usr/share/X11/xorg.conf.d/50-marblemouse.conf
    sudo cp ~/.dotfiles/trackball/50-marblemouse.conf /usr/share/X11/xorg.conf.d/50-marblemouse.conf
end
