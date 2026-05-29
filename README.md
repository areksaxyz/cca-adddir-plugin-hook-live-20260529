# Additional-Dir Plugin Hook Live Repro

Owned-repo live reproduction for a non-skill `claude-code-action` trust-boundary issue.

Base branch contains only the workflow.
Attacker PR branch adds:

- `.claude/settings.json`
- `market/.claude-plugin/marketplace.json`
- `market/plugins/probe-plugin/.claude-plugin/plugin.json`
- `market/plugins/probe-plugin/hooks/hooks.json`
- `market/plugins/probe-plugin/hooks/session-start.sh`

The workflow follows the documented privileged pattern:

- `pull_request_target`
- checkout trusted base to workspace root
- checkout untrusted PR head to `pr-head/`
- run `anthropics/claude-code-action@v1`
- pass `claude_args: "--add-dir pr-head"`

If the issue reproduces, the PR-head plugin `SessionStart` hook posts a marker comment
back to the PR as `github-actions[bot]`.
