#!/bin/sh

tags=$(git ls-remote -t --refs https://github.com/nim-lang/nim v\* | cut -d'/' -f3 | grep -v 'v0\.')

while read -r line; do
  [ -z "$line" ] && continue
  podman build . -t playground-runner:"$line" --build-arg NIMTAG="$line"
done <<< $tags
