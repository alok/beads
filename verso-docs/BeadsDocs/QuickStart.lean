import VersoBlog

open Verso Genre Blog

set_option maxRecDepth 1024

#doc (Page) "Quickstart Guide" =>

# Quickstart Guide

Get started with Beads in just a few minutes.

## Installation

### Quick Install (macOS / Linux)

```
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
```

### npm (Node.js environments)

```
npm install -g @beads/bd
```

### Homebrew

```
brew install steveyegge/tap/beads
```

## Initialize Your Project

Navigate to your project directory and run:

```
bd init
```

This creates a `.beads/` directory with the SQLite database and JSONL export file.

## Basic Usage

### Create an Issue

```
bd create -t task -T "Implement user authentication"
```

### List Issues

```
bd list
```

### Show Ready Work

Find issues with no blockers:

```
bd ready
```

### Add Dependencies

Make one issue block another:

```
bd dep-add --from bd-abc1 --to bd-def2
```

### Close an Issue

```
bd close bd-abc1 --reason "Completed implementation"
```

## Agent Integration

Tell your coding agent to start using `bd` by adding to your `AGENTS.md` or `CLAUDE.md`:

> Use the `bd` tool for tracking work and issues. Create issues for any problems you notice.
> Check `bd ready` to find work to do.

That's it! Your agent will now use Beads to track work across sessions.

## Next Steps

* [Command Reference](/commands/) - Full list of available commands
* [Architecture](/architecture/) - How Beads works under the hood
* [Agent Integration](/agents/) - Advanced agent configuration
