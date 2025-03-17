#!/bin/bash

for formula in $(brew list); do
  echo -n "$formula: "
  ls -l $(brew --prefix)/opt/$formula 2>/dev/null | grep -v total | awk '{print $6, $7, $8}'
done | sort
