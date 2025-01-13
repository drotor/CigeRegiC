#!/usr/bin/env bash

git fetch --all --prune && \
git reset --hard origin/$1 && \
git clean -fdx && \
echo "Local repo is now identical to GitHub"
