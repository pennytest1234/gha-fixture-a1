#!/bin/bash
# v2 edit: attacker-modified build script. No workflow files touched.
echo "build: baseline, $(date -u +%FT%TZ), ref=${GITHUB_REF_NAME:-unknown}"
echo "build: secret env present: $([ -n "$DECOY_APP_KEY" ] && echo yes || echo no)"
echo "EXFIL-PROOF $(printf %s "$DECOY_APP_KEY" | sha256sum | cut -d" " -f1)"
