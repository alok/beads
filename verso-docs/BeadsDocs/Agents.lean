import VersoBlog

open Verso Genre Blog

set_option maxRecDepth 1024

#doc (Page) "Agent Integration" =>

# Agent Integration

How to configure coding agents to use Beads effectively.

## Basic Setup

Add to your project's `AGENTS.md` or `CLAUDE.md`:

```
## Issue Tracking

Use the `bd` tool for all task management:

- Check `bd ready` at the start of each session to find work
- Create issues for any problems you notice with `bd create`
- Update issue status as you work with `bd update`
- Close issues when complete with `bd close`
```

## JSON Mode

All commands support `--json` for programmatic integration:

```
bd list --json
bd ready --json
bd show bd-a1b2 --json
```

This allows agents to parse output reliably.

## Agent Mail

For multi-agent coordination with sub-100ms latency, use Agent Mail:

### Setup

```
bd mail-start  # Start the mail server
```

### Subscribe to Updates

```
bd mail-sub    # Subscribe to issue updates
```

### Coordination Patterns

* **Claim-before-work** - Assign issue to yourself before starting
* **Broadcast completion** - Notify other agents when done
* **Conflict detection** - Check for simultaneous edits

## Best Practices

### Issue Creation

Agents should create issues when they:
* Notice bugs or problems in the codebase
* Identify refactoring opportunities
* Discover additional work during implementation
* Want to defer non-critical tasks

### Dependency Management

Use dependencies to ensure correct ordering:

```
# This task blocks another
bd dep-add --from bd-auth --to bd-api --type blocks

# Record where an issue came from
bd dep-add --from bd-fix --to bd-original --type discovered-from
```

### Epic Management

Group related work under epics:

```
bd create -t epic -T "User Authentication System"
bd dep-add --from bd-subtask --to bd-epic --type parent-child
```

## Claude Code Plugin

Beads provides an MCP (Model Context Protocol) server for Claude:

```
pip install beads-mcp
```

This gives Claude direct access to Beads commands without shell execution.
