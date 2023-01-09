#!/bin/bash

set -ex

cd $(dirname $0)

for dir in patches/* ; do
  repo=$(basename $dir)
  pushd $repo
  for patch in ../patches/$repo/*.patch ; do
    git apply --3way --ignore-space-change $patch
    git commit -m "Apply $(basename $patch)"
  done
  popd
done
