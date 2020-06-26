#!/usr/local/bin/bash -x

cd homebrew

brew tap homebrew/bundle
brew update
brew upgrade

if brew bundle check --verbose ; then
# skip
    echo '(skipping brew bundle)'
else
    brew bundle
fi
brew bundle cleanup --force
brew doctor

cd ..
