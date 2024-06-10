#!/bin/sh

defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution

if [[ -d "$CI_APP_STORE_SIGNED_APP_PATH" ]]; then
    git fetch --deepen 1 && git log -1 --pretty=format:"%s" | cat > ../TestFlight/WhatToTest.en-US.txt
fi
