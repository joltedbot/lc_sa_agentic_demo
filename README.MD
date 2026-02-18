# LC SA Agentic AI Demo

As part of the demo the contents of this repo will provide Claude Code the ability to act as your agent for accessing information about and working with your Elastic Cloud cluster.

It provides developers of Elastic based projects the ability to interact "where they work" with their cluster to assist in building out their applications.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed and authenticated
- An Elastic Cloud deployment with Kibana
- An Elastic API Key with appropriate permissions

## Setup

Run the setup script once to register the Elastic MCP server with Claude Code:

```bash
./setup/setup.sh
```

The script will prompt you for two pieces of information:

1. **Base Kibana URL** — the root URL of your Kibana instance, without any path.

   Example: `https://my-deployment.kb.us-east-1.aws.found.io`

   The script automatically appends the required MCP API path (`/api/agent_builder/mcp`).

2. **Elastic API Key** — your API key for authenticating with the Elastic cluster. The key is masked as you type.

After confirming, the script registers the `elastic` MCP server at user scope (`~/.claude.json`). Re-running the script is safe — it skips registration if the server is already present.

### Creating an Elastic API Key

In Kibana, navigate to **Stack Management → API Keys** and create a new key. Grant it the permissions needed for the indices and features you want to query through Claude Code.

## Usage

Once setup is complete, open Claude Code in this directory. Claude will automatically have access to the `elastic-cluster-interface` subagent. Simply describe what you want to explore or query in natural language and Claude will use the appropriate Elastic tools.


### Platform & Core

| Capability | Description |
|---|---|
| Search | Full-text and structured search across any index |
| Document retrieval | Fetch specific documents by ID |
| ES\|QL | Generate and execute ES\|QL queries from natural language |
| Index exploration | List indices, data streams, and aliases; inspect mappings |
| Product documentation | Search Elastic product docs (Elasticsearch, Kibana, Observability, Security) |
| Fleet integrations | Query knowledge about installed Fleet integrations and their configuration |
| Cases | Retrieve and search cases from Security, Observability, or Stack Management |
| Workflow status | Check the execution status of running workflows |

### Observability

| Capability | Description |
|---|---|
| Services (APM) | Overview of service health, latency, error rate, and throughput |
| Hosts | Infrastructure metrics — CPU, memory, disk, and network across hosts |
| Logs | Categorize log patterns, find correlated log sequences, detect rate changes |
| Traces | Drill into transaction metrics and trace performance across services |
| Anomaly detection | Retrieve ML anomaly detection job results |
| Alerts | Query active and recovered Observability alerts |
| Change point detection | Identify statistically significant changes in log or metric patterns |
| Index field discovery | Explore available fields and values in observability indices |

### Security

| Capability | Description |
|---|---|
| Security alerts | Search, count, and aggregate Elastic Security alerts |
| Security Labs | Search Elastic Security Labs articles on malware, attack techniques, and MITRE ATT&CK |

### Hybrid Search

| Capability | Description |
|---|---|
| Hybrid search | Demonstrate combined keyword + semantic vector search |
