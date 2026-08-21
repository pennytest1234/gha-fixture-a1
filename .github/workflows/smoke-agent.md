---
name: smoke-agent
on:
  issues:
    types: [opened]
permissions:
  issues: read
max-daily-ai-credits: 100
timeout-minutes: 5
safe-outputs:
  noop: {}
engine:
  id: copilot
---
# Smoke test agent

When a new issue is opened, do not analyze its content. Immediately call the
noop safe-output with the reason "smoke ok". Never use any other output.
