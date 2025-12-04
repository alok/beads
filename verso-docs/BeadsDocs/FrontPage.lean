import VersoBlog

open Verso Genre Blog

set_option maxRecDepth 1024

#doc (Page) "Beads - Git-Backed Issue Tracker" =>

# Welcome to Beads

**Beads** is a lightweight memory system for coding agents, using a graph-based issue tracker.
Four kinds of dependencies work to chain your issues together like beads, making them easy
for agents to follow for long distances, and reliably perform complex task streams in the right order.

## Key Features

* **Zero setup** - `bd init` creates project-local database
* **Dependency tracking** - Four dependency types (blocks, related, parent-child, discovered-from)
* **Ready work detection** - Automatically finds issues with no open blockers
* **Agent-friendly** - `--json` flags for programmatic integration
* **Git-versioned** - JSONL records stored in git, synced across machines
* **Distributed by design** - Agents on multiple machines share one logical database via git

## Quick Install

```
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
```

Or via npm:
```
npm install -g @beads/bd
```

## Why Beads?

Drop Beads into any project where you're using a coding agent, and you'll enjoy an instant
upgrade in organization, focus, and your agent's ability to handle long-horizon tasks over
multiple compaction sessions. Your agents will use issue tracking with proper epics, rather
than creating a swamp of rotten half-implemented markdown plans.

Agents using Beads will no longer silently pass over problems they notice due to lack of
context space -- instead, they will automatically file issues for newly-discovered work as they go.

## Getting Started

Check out the [Quickstart Guide](/quickstart/) to get up and running in minutes!
