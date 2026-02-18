# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository is a demo of Claude Code acting as an AI agent that connects to an Elastic Cloud cluster via the Elastic MCP server. It contains setup tooling — there is no application code to build or test.

## Setup

```bash
# Register the Elastic MCP server with Claude Code (run once)
./setup/setup.sh
```

`setup.sh` prompts for a Kibana URL and API Key, then registers the `elastic` MCP server at user scope (`~/.claude.json`). It is idempotent — re-running skips already-registered servers.

## Architecture

```
.
├── setup/setup.sh          # MCP server registration script
└── .claude/
    ├── settings.json       # Auto-allows all mcp__elastic__* tool calls
    └── agents/
        └── elastic-cluster-interface.md   # Subagent definition for Elastic cluster operations
```

### MCP Integration

The `elastic` MCP server is registered at `~/.claude.json` (user scope) and provides the `mcp__elastic__*` tools used by the `elastic-cluster-interface` subagent. The MCP endpoint is `/api/agent_builder/mcp` on the Kibana host.

### elastic-cluster-interface Subagent

Defined in `.claude/agents/elastic-cluster-interface.md`. Use this subagent for any task that queries or interacts with the Elastic cluster — searching indices, running ES|QL, inspecting mappings, checking cluster health, etc. It has access to all `mcp__elastic__*` tools and builds up institutional knowledge about the cluster across conversations via agent memory.

## Key Notes

- MCP registration is stored in `~/.claude.json` under `.mcpServers`
- `claude mcp list` and other `claude` CLI commands cannot be run from within a Claude Code session
