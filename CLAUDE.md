# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Table of Contents
1. [Critical Rules](#critical-rules)
2. [RPI Framework](#rpi-framework-research--plan--implement)
3. [General Guidelines](#general-guidelines)
4. [Code Style Guidelines](#code-style-guidelines)
5. [Communication Style](#communication-style)
6. [Project Overview](#project-overview)

## CRITICAL RULES

**Three-Strike Rule for Failed Changes:**
When changes result in compilation errors, runtime errors, test failures, or other blocking issues:
1. **First attempt**: Try a straightforward fix
2. **Second attempt**: If the first fix doesn't work, try one alternative approach
3. **Third attempt**: If the second fix doesn't work, try one more focused solution
4. **After three failed attempts**: STOP, revert your changes, reassess the approach, and ask the user how to proceed


# RPI Framework: Research → Plan → Implement

For non-trivial changes, follow this three-phase approach with explicit user approval at each phase boundary.

**Requires RPI:** Architecture changes, multi-file refactors, new features, complex bug fixes
**Skip RPI:** Typo fixes, single-line edits, formatting changes, simple corrections

## Documentation
Track each RPI project in a single `.md` file with three sections corresponding to the phases below.

**Performance Considerations:** For changes that may affect hot-path performance, assess impact at each phase and document risks/mitigations (see Performance-Critical Hot Paths section).

## Phase 1: Research (What should be done)
- Understand the request and analyze current codebase state
- Ask clarifying questions iteratively to define scope and desired outcomes
- Document key decisions, constraints, and critical context for later phases
- **STOP:** Present research findings and get user confirmation before proceeding to Plan

## Phase 2: Plan (How should it be done)
- Design implementation approach based on Research phase findings
- Break down work into discrete, validatable stages
- Collaborate with user to refine plan where helpful (always an option)
- Self-review the plan holistically—does it achieve the goal? Are there issues?
- Document the complete plan with stage-by-stage breakdown
- **STOP:** Get explicit user approval of the plan before proceeding to Implement

## Phase 3: Implement (Execute the plan)
- **STOP FIRST:** Get explicit user approval to START work (ensures good timing, final review)
- Follow all standing instructions including the three-strikes rule
- Execute plan in stages as documented in Plan phase
- Validate success after EACH stage completes—don't wait until the end
- Ask questions whenever needed; collaboration doesn't end here
- If major deviations from plan are needed:
  - STOP implementation immediately
  - Analyze impact on overall plan, not just current task
  - Revise the plan document
  - Review changes with user and get approval before continuing
- Perform final validation and testing after all stages complete
- Document what was implemented and any deviations from plan


## General Guidelines

- Simple solutions are preferred over complex ones
- Asking questions is encouraged when knowledge of intent will improve the accuracy or efficiency of the solution
- If a solution fails multiple times, stop and ask for input rather than continuing to try more changes
- Ask before adding new dependencies
- Where the existing architecture or code make a solution more complex and a change to the architecture would be more idiomatic and/or simpler, ask for input rather than writing more code to get around the issue
- When you find code that is not directly part of the task should be refactored, make the recommendation. Improving the code is always important but should be done in a separate step if it is not directly related to the task
- For non-RPI changes, confirm the approach with the user before writing code. Ask: "Should I proceed with the implementation?" and wait for explicit confirmation (e.g., "yes", "go ahead", "proceed") before writing any code. The user may want to implement changes themselves, review the code first, or need time before proceeding.

## Code Style Guidelines

- Always use the the most up to date idiomatic code style and guidelines for the programming langugage you are working with
- If a conflict arrises between the idiomatic style and the users request then present the idiomatic option to the user and ask for further guidance

## Communication Style

- **Prefer conciseness over exhaustiveness** - Start with a brief, clear answer; offer to elaborate if needed. Avoid walls of text when a paragraph will do.
- **For design questions**: Present 2-3 options with 1-2 sentences of pros/cons each, make a clear recommendation with brief reasoning, then ask if more detail is needed. Avoid full code examples unless specifically requested.
- **For implementation**: Provide step-by-step plans when requested. Focus on what to change and why, not showing complete code blocks unless asked.
- **Avoid redundancy**: Don't repeat information that's already been established in the conversation. Reference earlier points rather than restating them.
- **Scale detail to task scope**: Simple questions deserve simple answers; complex tasks deserve detailed plans. Match response depth to the complexity of the question asked.



## Project Overview

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
