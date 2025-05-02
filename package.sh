#!/usr/bin/env bash
set -euo pipefail

case ${ARCH} in
  x86_64-unknown-linux-gnu)
  export DEB_ARCH=amd64;;
  arm-unknown-linux-gnueabihf)
  export DEB_ARCH=armhf;;
  aarch64-unknown-linux-gnu)
  export DEB_ARCH=aarch64;;
esac
chmod +x "${ARCH}/release/atuin"
bundle exec fpm -f \
-s dir \
-t deb \
--deb-priority optional \
--maintainer github@growse.com \
--vendor https://atuin.sh/ \
--license MIT \
-n "$DEB_NAME" \
--description "${APP_DESCRIPTION}" \
--url "${APP_URL}" \
--prefix / \
-a "${DEB_ARCH}" \
-v "${PACKAGE_VERSION}-$(printf "%04d" "$GITHUB_RUN_NUMBER")" \
"${ARCH}/release/atuin=/usr/bin/atuin"
