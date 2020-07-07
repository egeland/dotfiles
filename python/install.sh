#!/usr/local/bin/bash

PY_VENV=~/py3
if [ ! -d "$PY_VENV" ]; then
    HB_PYTHON_DIR=$(ls -d /usr/local/Cellar/python* | sort | tail -n 1)
    PYTHON3=$(find $HB_PYTHON_DIR -name python)
    $PYTHON3 -m venv "$PY_VENV"
    source ${PY_VENV}/bin/activate
    pip install --upgrade --progress-bar pretty pip
else
    echo "Python 3 venv (${PY_VENV}) exists"
fi
