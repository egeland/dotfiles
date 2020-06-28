#!/usr/local/bin/bash -x

cd homebrew

LAST_RUN=".last_run"
if [[ -f "$LAST_RUN" ]]; then
    find "$LAST_RUN" -mtime +4h -print | grep -q "$LAST_RUN" || \
        echo "Homebrew checked recently - skipping" && \
        cd .. && \
        exit 0
fi

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
brew cleanup
brew doctor

touch $LAST_RUN

cd ..
