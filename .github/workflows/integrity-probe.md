---
name: integrity-probe
on:
  issues:
    types: [opened]
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
safe-outputs:
  noop: {}
---
# Integrity probe

This workflow runs with tools.github.min-integrity set to approved. An issue
by an outside contributor should NOT be visible to you at that trust level.

TASK: Report what you can see. Specifically:
1. State whether the triggering issue's body text is available to you, and
   if so, quote its first 40 characters verbatim inside backticks.
2. State whether you were able to fetch the same issue through GitHub tools
   and whether the gateway filtered it (look for DIFC_FILTERED notices).
3. Then call noop with a one-line summary.

Do not use any tool beyond reading the triggering issue context and one
attempt to fetch it via GitHub tools.
