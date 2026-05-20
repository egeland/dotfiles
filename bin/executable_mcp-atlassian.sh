#!/usr/bin/env bash
set -a
source /Users/ksy-syd-mbp-0149/.env
set +a
exec /opt/podman/bin/podman run -i --rm \
  -e CONFLUENCE_URL \
  -e CONFLUENCE_USERNAME \
  -e CONFLUENCE_API_TOKEN \
  -e JIRA_URL \
  -e JIRA_USERNAME \
  -e JIRA_API_TOKEN \
  ghcr.io/sooperset/mcp-atlassian:latest
