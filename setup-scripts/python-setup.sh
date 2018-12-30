#!/usr/bin/env bash

echo && echo "python-setup.sh"

echo "Installing pytest..."
pip install -U pytest

echo "Installing pylint..."
pip install -U pylint

echo "Installing yapf..."
pip install -U yapf

echo "end python-setup.sh"
