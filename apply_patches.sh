#!/bin/bash

set -ex

cd $(dirname $0)

for dir in patches/* ; do
  repo=$(basename $dir)
  pushd $repo
  git config user.email || git config user.email "nobody@example.org"
  git config user.name || git config user.name "Nobody"
  for patch in ../patches/$repo/*.patch ; do
    git apply --3way --ignore-space-change $patch
    git commit -m "Apply $(basename $patch)"
  done
  popd
done
