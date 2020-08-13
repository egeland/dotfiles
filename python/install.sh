#!/bin/bash

PY_VENV=~/py3
if [ ! -d "$PY_VENV" ]; then
    sudo apt install --yes python3-venv
    PYTHON3=$(which python3)
    $PYTHON3 -m venv "$PY_VENV"
else
    echo "Python 3 venv (${PY_VENV}) exists"
fi

source ${PY_VENV}/bin/activate
pip install --quiet --upgrade --progress-bar pretty pip ipython

