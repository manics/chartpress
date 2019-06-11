#!/bin/sh
# GitHub Action may use a different home, need to reinitialise helm
set -eu

helm init --client-only
exec chartpress.py "$@"
