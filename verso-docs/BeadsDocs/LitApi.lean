/-
Literate Lean documentation for Beads API.

This file uses Verso's literate programming features for real syntax highlighting with hover.
-/

set_option doc.verso true

/-!
# Beads Core Types

The fundamental data structures for the Beads issue tracker.
-/

/-- Hash-based identifier for collision-resistant multi-worker support. -/
structure IssueId where
  /-- The prefix, typically "bd" -/
  idPrefix : String := "bd"
  /-- The hash portion of the ID -/
  hash : String
deriving Repr, BEq, Hashable, DecidableEq

instance : ToString IssueId where
  toString id := s!"{id.idPrefix}-{id.hash}"

/-!
## Issue Types

Issues can be categorized into different types for organization.
-/

/-- The type of work an issue represents. -/
inductive IssueType where
  | task     : IssueType
  | bug      : IssueType
  | feature  : IssueType
  | epic     : IssueType
deriving Repr, BEq, Hashable, DecidableEq

instance : ToString IssueType where
  toString
    | .task => "task"
    | .bug => "bug"
    | .feature => "feature"
    | .epic => "epic"

/-!
## Status

The current state of an issue in the workflow.
-/

/-- The workflow state of an issue. -/
inductive Status where
  | open       : Status
  | inProgress : Status
  | closed     : Status
deriving Repr, BEq, Hashable, DecidableEq

instance : ToString Status where
  toString
    | .open => "open"
    | .inProgress => "in_progress"
    | .closed => "closed"

/-!
## Priority

Priority levels from 0 (highest) to 4 (lowest).
-/

/-- Issue priority, where lower values are higher priority. -/
structure Priority where
  /-- Priority value 0-4 -/
  value : Fin 5
deriving Repr, BEq, DecidableEq

namespace Priority

/-- Highest priority (0). -/
def highest : Priority := ⟨0, by decide⟩

/-- High priority (1). -/
def high : Priority := ⟨1, by decide⟩

/-- Normal/default priority (2). -/
def normal : Priority := ⟨2, by decide⟩

/-- Low priority (3). -/
def low : Priority := ⟨3, by decide⟩

/-- Lowest priority (4). -/
def lowest : Priority := ⟨4, by decide⟩

end Priority

/-!
## Timestamps

Time representation for tracking issue creation and updates.
-/

/-- Unix timestamp in milliseconds. -/
structure Timestamp where
  millis : Int
deriving Repr, BEq, DecidableEq

namespace Timestamp

/-- Get current time (placeholder - requires IO). -/
def now : IO Timestamp := do
  -- In real implementation, would call system time
  pure ⟨0⟩

end Timestamp

/-!
# Issue Structure

The main Issue type combining all fields.
-/

/-- A tracked issue in the Beads system. -/
structure Issue where
  /-- Unique identifier -/
  id : IssueId
  /-- Type of issue -/
  type : IssueType
  /-- Short title -/
  title : String
  /-- Optional longer description -/
  description : Option String
  /-- Current status -/
  status : Status
  /-- Priority level -/
  priority : Priority
  /-- Optional assignee name -/
  assignee : Option String
  /-- When the issue was created -/
  createdAt : Timestamp
  /-- When the issue was last updated -/
  updatedAt : Timestamp
deriving Repr

/-!
# Dependencies

Beads supports four types of dependencies between issues.
-/

/-- The type of relationship between two issues. -/
inductive DependencyType where
  /-- `source` must complete before `target` can start -/
  | blocks : DependencyType
  /-- Issues are conceptually related -/
  | related : DependencyType
  /-- Hierarchical parent/child relationship -/
  | parentChild : DependencyType
  /-- `target` was discovered while working on `source` -/
  | discoveredFrom : DependencyType
deriving Repr, BEq, Hashable, DecidableEq

/-- A dependency relationship between two issues. -/
structure Dependency where
  /-- The source issue -/
  source : IssueId
  /-- The target issue -/
  target : IssueId
  /-- The type of dependency -/
  depType : DependencyType
deriving Repr, BEq

/-!
# Query Filters

Filtering options for listing and searching issues.
-/

/-- Filter criteria for issue queries. -/
structure IssueFilter where
  /-- Filter by status -/
  status : Option Status := none
  /-- Filter by type -/
  type : Option IssueType := none
  /-- Filter by assignee -/
  assignee : Option String := none
  /-- Maximum number of results -/
  limit : Option Nat := none
deriving Repr

/-!
# Ready Work Detection

The core algorithm for finding actionable issues.
-/

/-- Check if an issue has any open blocking dependencies. -/
def isBlocked (issue : Issue) (deps : List Dependency) (issues : List Issue) : Bool :=
  deps.any fun dep =>
    dep.target == issue.id &&
    dep.depType == .blocks &&
    issues.any fun blocker =>
      blocker.id == dep.source && blocker.status != .closed

/-- Get all issues that are ready to work on (not blocked). -/
def getReadyWork (issues : List Issue) (deps : List Dependency) : List Issue :=
  issues.filter fun issue =>
    (issue.status == .open || issue.status == .inProgress) &&
    !isBlocked issue deps issues

/-!
# Cycle Detection

Preventing circular dependencies in the issue graph.
-/

/-- Error when adding a dependency would create a cycle. -/
inductive CycleError where
  | wouldCreateCycle (path : List IssueId) : CycleError
deriving Repr

/-- Check if adding a dependency would create a cycle (DFS-based). -/
partial def wouldCreateCycle (source target : IssueId) (deps : List Dependency) : Bool :=
  let rec visit (current : IssueId) (visited : List IssueId) : Bool :=
    if visited.contains current then true
    else if current == source then true
    else
      let outgoing := deps.filter (·.source == current)
      outgoing.any fun d => visit d.target (current :: visited)
  visit target []

/-!
# Example Usage

Creating and manipulating issues.
-/

/-- Example: Create a new task. -/
def exampleTask : Issue := {
  id := { idPrefix := "bd", hash := "a1b2" }
  type := .task
  title := "Implement user authentication"
  description := some "Add login/logout functionality"
  status := .open
  priority := Priority.normal
  assignee := none
  createdAt := ⟨0⟩
  updatedAt := ⟨0⟩
}

/-- Example: Create a bug report. -/
def exampleBug : Issue := {
  id := { idPrefix := "bd", hash := "c3d4" }
  type := .bug
  title := "Fix login timeout"
  description := some "Session expires too quickly"
  status := .inProgress
  priority := Priority.high
  assignee := some "alice"
  createdAt := ⟨0⟩
  updatedAt := ⟨0⟩
}

/-- Example: The bug blocks the task. -/
def exampleDep : Dependency := {
  source := exampleBug.id
  target := exampleTask.id
  depType := .blocks
}

#check exampleTask
#check exampleBug
#check exampleDep
