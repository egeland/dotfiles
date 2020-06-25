#!/usr/local/bin/bash

cd homebrew

brew update
brew tap homebrew/bundle
brew upgrade
brew bundle
brew bundle cleanup --verbose --force

cd ..
