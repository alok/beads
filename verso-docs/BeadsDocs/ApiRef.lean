import VersoBlog

open Verso Genre Blog

set_option maxRecDepth 1024

#doc (Page) "API Reference" =>

# API Reference

Core types and functions for the Beads Lean 4 library.

## Core Types

### Issue

The fundamental unit of work tracking.

```
structure Issue where
  id : IssueId
  type : IssueType
  title : String
  description : Option String
  status : Status
  priority : Priority
  assignee : Option String
  createdAt : Timestamp
  updatedAt : Timestamp
  deriving Repr, BEq, Hashable, ToJson, FromJson
```

### IssueId

Hash-based identifier for collision-resistant multi-worker support.

```
structure IssueId where
  prefix : String := "bd"
  hash : String
  deriving Repr, BEq, Hashable, Ord, ToJson, FromJson

namespace IssueId
  def generate (seed : ByteArray) : IO IssueId
  def toString (id : IssueId) : String
  def fromString? (s : String) : Option IssueId
end IssueId
```

### IssueType

```
inductive IssueType where
  | task
  | bug
  | feature
  | epic
  deriving Repr, BEq, Hashable, ToJson, FromJson
```

### Status

```
inductive Status where
  | open
  | inProgress
  | closed
  deriving Repr, BEq, Hashable, ToJson, FromJson
```

### Priority

Priority levels from 0 (highest) to 4 (lowest).

```
structure Priority where
  value : Fin 5
  deriving Repr, BEq, Ord, ToJson, FromJson

namespace Priority
  def highest : Priority := ⟨0, by decide⟩
  def high : Priority := ⟨1, by decide⟩
  def normal : Priority := ⟨2, by decide⟩
  def low : Priority := ⟨3, by decide⟩
  def lowest : Priority := ⟨4, by decide⟩
end Priority
```

## Dependencies

### Dependency

Represents a relationship between two issues.

```
structure Dependency where
  from : IssueId
  to : IssueId
  type : DependencyType
  deriving Repr, BEq, ToJson, FromJson
```

### DependencyType

```
inductive DependencyType where
  | blocks        -- from must complete before to
  | related       -- issues are conceptually related
  | parentChild   -- hierarchical relationship
  | discoveredFrom -- to was discovered while working on from
  deriving Repr, BEq, Hashable, ToJson, FromJson
```

## Database Operations

### BeadsDb

The main database handle.

```
structure BeadsDb where
  private mk ::
  path : System.FilePath
  conn : SQLite.Connection

namespace BeadsDb
  def open (path : System.FilePath) : IO BeadsDb
  def close (db : BeadsDb) : IO Unit
  def init (path : System.FilePath) : IO BeadsDb
end BeadsDb
```

### Issue CRUD

```
namespace BeadsDb
  def createIssue (db : BeadsDb) (issue : Issue) : IO IssueId
  def getIssue (db : BeadsDb) (id : IssueId) : IO (Option Issue)
  def updateIssue (db : BeadsDb) (id : IssueId) (f : Issue → Issue) : IO Unit
  def closeIssue (db : BeadsDb) (id : IssueId) (reason : Option String) : IO Unit
  def deleteIssue (db : BeadsDb) (id : IssueId) : IO Unit
end BeadsDb
```

### Querying

```
namespace BeadsDb
  def listIssues (db : BeadsDb) (filter : IssueFilter) : IO (Array Issue)
  def searchIssues (db : BeadsDb) (query : String) : IO (Array Issue)
  def getReadyWork (db : BeadsDb) : IO (Array Issue)
  def getBlockedIssues (db : BeadsDb) : IO (Array Issue)
end BeadsDb

structure IssueFilter where
  status : Option Status := none
  type : Option IssueType := none
  assignee : Option String := none
  limit : Option Nat := none
```

## Dependency Graph

### Adding Dependencies

```
namespace BeadsDb
  def addDependency (db : BeadsDb) (dep : Dependency) : IO (Except CycleError Unit)
  def removeDependency (db : BeadsDb) (from to : IssueId) : IO Unit
  def getDependencies (db : BeadsDb) (id : IssueId) : IO (Array Dependency)
end BeadsDb
```

### Cycle Detection

```
inductive CycleError where
  | wouldCreateCycle (path : List IssueId)
  deriving Repr

def detectCycle (db : BeadsDb) (from to : IssueId) : IO Bool
```

## Sync Operations

### JSONL Export/Import

```
namespace Sync
  def exportToJsonl (db : BeadsDb) (path : System.FilePath) : IO Unit
  def importFromJsonl (db : BeadsDb) (path : System.FilePath) : IO Unit
  def sync (db : BeadsDb) : IO SyncResult
end Sync

structure SyncResult where
  pushed : Nat
  pulled : Nat
  conflicts : Array IssueId
```

## Monadic Interface

For use in custom scripts and automation.

```
abbrev BeadsM := ReaderT BeadsDb IO

def runBeads (path : System.FilePath) (action : BeadsM α) : IO α := do
  let db ← BeadsDb.open path
  try action.run db
  finally db.close

-- Example usage:
def example : IO Unit := runBeads ".beads" do
  let db ← read
  let ready ← db.getReadyWork
  for issue in ready do
    IO.println s!"Ready: {issue.id} - {issue.title}"
```

## JSON Serialization

All core types derive `ToJson` and `FromJson` for CLI integration.

```
-- Produces: {"id":"bd-a1b2","type":"task","title":"..."}
#eval ToJson.toJson issue

-- Parse from JSON string
def parseIssue (json : String) : Except String Issue :=
  match Json.parse json with
  | .ok j => FromJson.fromJson? j
  | .error e => .error e
```
