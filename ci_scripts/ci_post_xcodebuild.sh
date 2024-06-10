#!/bin/sh

if [[ $CI_WORKFLOW == "TestFlight" ]]; then
  pushd ..
    mkdir TestFlight
    pushd TestFlight
      for locale in en-GB en-US; do
        git fetch --deepen 1 && git log -1 --pretty=format:"%s" > WhatToTest.$locale.txt
      done
    popd
  popd
fi
