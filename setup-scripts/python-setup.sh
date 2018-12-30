#!/usr/bin/env bash

echo && echo "python-setup.sh"

echo "Installing pytest..."
pip3 install -U pytest

echo "Installing pylint..."
pip3 install -U pylint

echo "Installing yapf..."
pip3 install -U yapf

echo "end python-setup.sh"
