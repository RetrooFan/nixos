#!/usr/bin/env bash

HASH1=$(sha256sum $1 | awk '{print $1}')
HASH2=$(sha256sum $2 | awk '{print $1}')

if [ "$HASH1" != "$HASH2" ]; then
  echo "----------------------------------------"
  echo "|             Pliki rozne!             |"
  echo "----------------------------------------"

  echo $1
  echo $2
  echo

  exit 2
fi
