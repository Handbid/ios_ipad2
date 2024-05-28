#!/bin/sh

defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution

