#!/usr/local/bin/bash

cd vscode
LAST_RUN='.last_run'
if [[ -f "$LAST_RUN" ]]; then
    find . -name "$LAST_RUN" -mmin -480 -print | grep -q "$LAST_RUN" && \
        echo "VS Code Extensions already checked recently - skipping" && \
        exit 0
fi

while read EXTENSION
do
    echo "Install VS Code extension: $EXTENSION"
    code --install-extension "${EXTENSION}"
done < <(egrep -v '^#' extensions.txt)

touch $LAST_RUN
cd .. 2>/dev/null
