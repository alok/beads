import VersoBlog

open Verso Genre Blog

set_option maxRecDepth 1024

#doc (Page) "Architecture" =>

# Architecture

How Beads works under the hood.

## Storage Model

Beads uses a dual-storage approach:

1. **SQLite Database** (`.beads/beads.db`) - Fast local queries
2. **JSONL Export** (`.beads/issues.jsonl`) - Git-versioned, merge-friendly

Changes are written to SQLite first, then exported to JSONL for git sync.

## Hash-Based IDs

Issue IDs use hash-based identifiers (e.g., `bd-a1b2`, `bd-f14c`) instead of sequential numbers.
This eliminates merge conflicts when multiple agents or branches create issues concurrently.

Features:
* **Collision-resistant** - Birthday paradox math ensures extremely rare collisions
* **Merge-friendly** - No conflicts from concurrent issue creation
* **Human-readable** - Short 4-6 character hashes
* **Progressive scaling** - Length increases as needed (4 → 5 → 6 chars)

## Dependency Graph

Beads maintains a directed acyclic graph (DAG) of dependencies between issues.

### Dependency Types

1. **blocks** - Issue A must be completed before Issue B
2. **related** - Issues are conceptually related
3. **parent-child** - Hierarchical relationship (epics and subtasks)
4. **discovered-from** - Issue B was discovered while working on Issue A

### Cycle Detection

Runtime cycle detection prevents circular dependencies. If adding a dependency would
create a cycle, the operation fails with a clear error message.

## Git Integration

### JSONL Format

Issues are stored as newline-delimited JSON for easy merging:

```
{"id":"bd-a1b2","type":"task","title":"...","status":"open",...}
{"id":"bd-c3d4","type":"bug","title":"...","status":"closed",...}
```

### Custom Merge Driver

Beads provides a git merge driver that handles concurrent edits to the same issue
by taking the most recent change based on timestamps.

### Sync Branch

For protected branches, Beads can sync through a dedicated `beads-sync` branch
that gets auto-merged via GitHub Actions.

## Ready Work Algorithm

The `bd ready` command finds issues that:
1. Have status `open` or `in_progress`
2. Have no open blocking dependencies
3. Optionally filtered by assignee

This allows agents to quickly identify actionable work.

## Memory Decay

Old closed issues undergo "semantic compaction" to reduce storage while preserving
essential information for audit trails.
