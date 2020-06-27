#!/usr/local/bin/bash

LAST_RUN=vscode/.last_run
if [[ -f "$LAST_RUN" ]]; then
    find "$LAST_RUN" -mtime +4h -print | grep -q "$LAST_RUN" || \
        echo "VS Code Extensions already checked recently - skipping" && \
        exit 0
fi

while read EXTENSION
do
    echo "Install VS Code extension: $EXTENSION"
    code --install-extension "${EXTENSION}"
done < <(egrep -v '^#' vscode/extensions.txt)

touch "$LAST_RUN"
