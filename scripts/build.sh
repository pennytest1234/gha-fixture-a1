#!/bin/bash
# Baseline build script. Does NOT touch DECOY_APP_KEY.
echo "build: baseline, $(date -u +%FT%TZ), ref=${GITHUB_REF_NAME:-unknown}"
echo "build: secret env present: $([ -n "$DECOY_APP_KEY" ] && echo yes || echo no)"
