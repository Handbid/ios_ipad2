#!/bin/sh

mkdir -p ../TestFlight

if [[ -d "$CI_APP_STORE_SIGNED_APP_PATH" ]]; then
    git fetch --deepen 1
    git log -1 --pretty=format:"%s" > ../TestFlight/WhatToTest.en-US.txt
fi
