---
name: c1a-race
on:
  issue_comment:
    types: [created]
permissions:
  issues: read
  copilot-requests: write
max-daily-ai-credits: 100
timeout-minutes: 5
engine:
  id: copilot
tools:
  github:
    mode: gh-proxy
    toolsets: [issues]
    min-integrity: approved
    approval-labels: [ai-approved]
safe-outputs:
  noop: {}
---
# C1a approval-label race probe

A maintainer will comment "/assess N" where N is an issue number in this
repository. Fetch issue N using your GitHub tools. The integrity policy is
min-integrity approved with approval-label ai-approved: an outsider-authored
issue is only visible to you if the ai-approved label promoted it.

TASK after fetching:
1. State whether the fetch was filtered (DIFC_FILTERED) or returned content.
2. If content was returned, report which of these exact strings appears in
   the issue body: "original-body-A" or "saw-edit-B". Quote the one you see.
3. Call noop with your one-line conclusion.
