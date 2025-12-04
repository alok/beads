import VersoBlog

open Verso Genre Blog

set_option maxRecDepth 1024

#doc (Page) "Configuration" =>

# Configuration

Customize Beads behavior for your project.

## Config File

Create `.beads/config.yaml` in your project:

```
# Beads configuration
project:
  name: my-project

sync:
  auto: true
  branch: beads-sync
  interval: 30s

ids:
  prefix: bd
  length: 4  # 4-6 characters

labels:
  enabled: true
  custom:
    - name: urgent
      color: red
    - name: backend
      color: blue
```

## Environment Variables

Override config with environment variables:

* `BEADS_PROJECT_ROOT` - Override project root detection
* `BEADS_SYNC_BRANCH` - Override sync branch name
* `BEADS_AUTO_SYNC` - Enable/disable auto-sync

## Per-Project Isolation

Each project gets its own database in `.beads/`. Beads auto-discovers the project
root by looking for `.beads/` in parent directories.

## Protected Branches

For repos with protected main branches:

1. Configure a sync branch:
   ```
   sync:
     branch: beads-sync
   ```

2. Set up GitHub Actions to auto-merge:
   ```
   on:
     push:
       branches: [beads-sync]
   ```

## Git Hooks

Auto-sync on commit:

```
# .git/hooks/post-commit
#!/bin/bash
bd sync --no-pull
```

## Custom Tables

Extend the SQLite database with your own tables:

```
CREATE TABLE my_custom_data (
  issue_id TEXT REFERENCES issues(id),
  custom_field TEXT
);
```

Custom tables are preserved during sync operations.
