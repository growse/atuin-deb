#!/usr/bin/env bash
set -euo pipefail

echo "$APT_CREDENTIALS" > aptly-auth
find . -type f -name "*.deb" -exec curl -f --netrc-file aptly-auth -XPOST -F file=@{} https://apttoo.growse.com/api/files/atuin \;
export result; result=$(curl -f --netrc-file aptly-auth -X POST https://apttoo.growse.com/api/repos/defaultrepo/file/atuin)
export failed; failed=$(echo "$result" | jq '.FailedFiles | length')
if [[ "$failed" != "0" ]]; then exit 1; fi
curl -f --netrc-file aptly-auth -X PUT -H"Content-type: application/json" --data '{"ForceOverwrite":true,"Signing":{"Passphrase":"'"$APT_KEY_PASSPHRASE"'","Batch":true}}' https://apttoo.growse.com/api/publish/:./stablish
