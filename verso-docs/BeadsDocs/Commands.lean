import VersoBlog

open Verso Genre Blog

set_option maxRecDepth 1024

#doc (Page) "Command Reference" =>

# Command Reference

Complete reference for all `bd` commands. All commands support `--json` for programmatic output.

## Issue Management

### `bd create`
Create a new issue.

```
bd create -t <type> -T <title> [-d <description>] [-p <priority>]
```

Options:
* `-t, --type` - Issue type: `task`, `bug`, `feature`, `epic`
* `-T, --title` - Issue title (required)
* `-d, --description` - Issue description
* `-p, --priority` - Priority 0-4 (0 is highest, default 2)

### `bd list`
List issues with optional filters.

```
bd list [--status <status>] [--type <type>] [--assignee <name>]
```

### `bd show`
Show details of a specific issue.

```
bd show <issue-id>
```

### `bd update`
Update an issue's fields.

```
bd update <issue-id> [--title <title>] [--description <desc>] [--status <status>]
```

### `bd close`
Close an issue.

```
bd close <issue-id> [--reason <reason>]
```

## Dependencies

### `bd dep-add`
Add a dependency between issues.

```
bd dep-add --from <issue> --to <issue> [--type <dep-type>]
```

Dependency types:
* `blocks` - Issue A blocks Issue B (default)
* `related` - Issues are related
* `parent-child` - Parent/child relationship
* `discovered-from` - Issue discovered while working on another

### `bd ready`
List issues ready to work on (no open blockers).

```
bd ready [--assignee <name>] [--unassigned]
```

### `bd blocked`
List issues that are blocked by other open issues.

```
bd blocked
```

## Assignment

### `bd assign`
Assign an issue to someone.

```
bd assign <issue-id> [--to <name>]
```

Omit `--to` to unassign.

## Statistics

### `bd stats`
Get issue statistics by status, type, and priority.

```
bd stats
```

## Sync

### `bd sync`
Sync issues with git remote.

```
bd sync [--no-push] [--no-pull] [--dry-run]
```

## Search

### `bd search`
Search issues by title text.

```
bd search <query> [--status <status>] [--limit <n>]
```
