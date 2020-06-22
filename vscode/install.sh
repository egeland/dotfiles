#!/usr/local/bin/bash

while read EXTENSION
do
    echo "Install VS Code extension: $EXTENSION"
    code --install-extension "${EXTENSION}"
done < <(egrep -v '^#' vscode/extensions.txt)