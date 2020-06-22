#!/usr/local/bin/bash

cd homebrew

brew update
brew tap homebrew/bundle
brew upgrade
brew bundle
brew bundle cleanup --verbose && echo "To clean up, run: brew bundle cleanup --file $(pwd)/Brewfile --force"

cd ..
