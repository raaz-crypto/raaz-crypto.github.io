#!/bin/bash

# Temporarily store uncommited changes
git stash

# Verify correct branch
git checkout develop

# Build new files
cabal new-build
cabal new-exec site build

# Build html documentations for verse
git submodule update --init
cd verse-coq
eval $(opam config env)
./configure.sh
cd ..
if make -C verse-coq html
then
    rm _site/doc/verse -rf
    mkdir -p _site/doc/
    mv verse-coq/html _site/doc/verse
fi

# Get previous files
git fetch --all
git branch -D master
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
