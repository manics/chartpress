#!/bin/sh
# GitHub Action:
# - Set git author
# - Uses different home, need to reinitialise helm
set -eu

if [ -n "$GITHUB_ACTOR" ]; then
    git config --global user.name "$GITHUB_ACTOR"
    git config --global user.email "$GITHUB_ACTOR@users.noreply.github.com"
fi

helm init --client-only
exec chartpress.py "$@"
