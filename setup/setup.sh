#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# setup.sh — Configure Claude MCP for Elastic
# ─────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

err()  { echo -e "${RED}Error: $*${NC}" >&2; }
warn() { echo -e "${YELLOW}Warning: $*${NC}" >&2; }
ok()   { echo -e "${GREEN}$*${NC}"; }

# ── Dependency check ─────────────────────────
if ! command -v claude &>/dev/null; then
  err "'claude' CLI not found. Install Claude Code before running this script."
  exit 1
fi
if ! command -v curl &>/dev/null; then
  err "'curl' not found. Install curl before running this script."
  exit 1
fi

# ── Prompt helpers ───────────────────────────
prompt_url() {
  local url
  while true; do
    echo >&2 "Base Kibana URL (e.g. https://my-deployment.kb.us-east-1.aws.found.io)"
    read -r -p "  URL: " url
    url="${url%/}"  # strip trailing slash

    if [[ -z "$url" ]]; then
      err "URL cannot be empty."
      continue
    fi

    # Must start with https:// or http://
    if [[ ! "$url" =~ ^https?:// ]]; then
      err "URL must begin with http:// or https://"
      continue
    fi

    # Must not contain whitespace
    if [[ "$url" =~ [[:space:]] ]]; then
      err "URL must not contain spaces."
      continue
    fi

    echo "$url"
    return 0
  done
}

prompt_api_key() {
  local key
  while true; do
    # Read without echoing the key to the terminal
    read -r -s -p "Elastic API Key: " key
    echo >&2  # newline after silent input

    if [[ -z "$key" ]]; then
      err "API Key cannot be empty."
      continue
    fi

    if [[ "${#key}" -lt 10 ]]; then
      err "API Key looks too short (minimum 10 characters)."
      continue
    fi

    # Must not contain whitespace
    if [[ "$key" =~ [[:space:]] ]]; then
      err "API Key must not contain spaces."
      continue
    fi

    echo "$key"
    return 0
  done
}

# ── Main ─────────────────────────────────────
echo ""
echo "════════════════════════════════════════════"
echo "  Claude MCP — Elastic Cloud Setup"
echo "════════════════════════════════════════════"
echo ""

KIBANA_BASE_URL="$(prompt_url)"
ELASTIC_MCP_URL="${KIBANA_BASE_URL}/api/agent_builder/mcp"
ELASTIC_API_KEY="$(prompt_api_key)"

echo ""
echo "────────────────────────────────────────────"
echo "  Configuration Summary"
echo "────────────────────────────────────────────"
echo "  Kibana  : ${KIBANA_BASE_URL}"
echo "  MCP URL : ${ELASTIC_MCP_URL}"
echo "  API Key : ${ELASTIC_API_KEY:0:4}****${ELASTIC_API_KEY: -4}"
echo "────────────────────────────────────────────"
echo ""

read -r -p "Proceed with MCP registration? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  warn "Aborted by user."
  exit 0
fi

echo ""
if claude mcp list 2>/dev/null | grep -q "^elastic"; then
  warn "MCP server 'elastic' already registered — skipping."
else
  echo "Running: claude mcp add elastic ..."
  claude mcp add elastic \
    --transport http \
    -s user \
    --header "Authorization: ApiKey ${ELASTIC_API_KEY}" \
    -- "${ELASTIC_MCP_URL}"
  ok "MCP server 'elastic' registered successfully."
fi

echo ""
echo "────────────────────────────────────────────"
echo "  Registered MCP Servers (claude mcp list)"
echo "────────────────────────────────────────────"
claude mcp list
