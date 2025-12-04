import VersoBlog

open Verso Genre Blog

set_option maxRecDepth 1024

#doc (Page) "Advanced Usage" =>

# Advanced Usage

Advanced features for power users.

## Batch Operations

Import many issues at once:

```
cat issues.json | bd import --batch
```

Performance: ~1000 issues in ~950ms.

## Export Formats

Export issues in various formats:

```
bd export --format json > issues.json
bd export --format csv > issues.csv
bd export --format markdown > issues.md
```

## Audit Trail

Every change is logged. View history:

```
bd history <issue-id>
bd history --all --since "2024-01-01"
```

## Migration

Migrate from other issue trackers:

### From GitHub Issues

```
bd import-github --repo owner/repo --token $GITHUB_TOKEN
```

### From Jira

```
bd import-jira --url https://company.atlassian.net --project PROJ
```

### From Linear

```
bd import-linear --team TEAM
```

## Memory Decay (Compaction)

Configure automatic compaction of old issues:

```
compaction:
  enabled: true
  age: 90d           # Compact issues older than 90 days
  keep_dependencies: true
  preserve_audit: true
```

Manual compaction:

```
bd compact --dry-run  # Preview
bd compact            # Execute
```

## RPC Mode

Run Beads as a daemon for faster operations:

```
bd daemon start
bd --rpc list        # Uses daemon
bd daemon stop
```

## Multi-Worker Scenarios

Hash-based IDs enable safe concurrent work:

* Multiple clones of the same repo
* Multiple branches creating issues
* Multiple agents working simultaneously

No coordination required - merge conflicts are eliminated.

## Debugging

Enable verbose logging:

```
bd --verbose list
bd --debug sync
```

View internal state:

```
bd debug-state
bd debug-deps <issue-id>
```
