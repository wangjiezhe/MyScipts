#!/usr/bin/env bash

cat << EOF | tee ~/.zshrc

PIP_UPGRADE="$(pwd)/pip_upgrade.py"
alias pip-upgrade="sudo python \${PIP_UPGRADE}"
alias pip3-upgrade="sudo python3 \${PIP_UPGRADE}"
EOF
