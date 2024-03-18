args=(
  --credentials "$SRCROOT/Extras/client_secret.json" \
  --platform "ios" \
  --spreadsheet "1krgwQDoMYx2tS4G9K-1QyMd5ogKlqh4kcWQXBnPOcDI" \
  --formats-tab "formats" \
  --tab "ios_ipad_localization" \
  --key-column "_key" \
  --resources "$SRCROOT/Localization" \
  --default-localization "en" \
  --default-localization-file-path "$SRCROOT/Localization/en.lproj/Localizable.strings" \
  --empty-localization-match "(^$|^[xX]$)"
)
if [ "${CONFIGURATION}" = "Release" ]; then
    args+=(--stop-on-missing)
fi

"$SRCROOT/Extras/goloc-amd64" "${args[@]}"
