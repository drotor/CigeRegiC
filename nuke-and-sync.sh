#!/usr/bin/env bash

branch=`git branch | awk '{print $2}'`
git fetch -v --all --prune && \
git reset --hard origin/$branch && \
git clean -fdx && \
echo "Local repo is now identical to GitHub"
