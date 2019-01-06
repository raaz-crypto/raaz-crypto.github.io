#!/bin/bash

# Temporarily store uncommited changes
git stash

# Verify correct branch
git checkout develop

# Build new files
cabal new-build
cabal new-exec site build

# Build html documentations for verse
make -C verse-coq html
mkdir -p _site/doc/verse
mv verse-coq/html _site/doc/verse

# Get previous files
git fetch --all
git checkout -b master --track github/master

# Overwrite existing files with new files
rsync -a --ignore-times --filter='P _site/' --filter='P .travis.yml' --filter='P _cache/' --filter='P .git/' --filter='P .stack-work' --filter='P .gitignore' --delete-excluded _site/  .

# Commit
git add -A
git commit --no-verify -m "Publish."

# Push
git push github master:master

# Restoration
git checkout develop
git branch -D master
git stash pop
