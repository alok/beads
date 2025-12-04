import Lake
open Lake DSL

def leanVersion : String := s!"v{Lean.versionString}"

package «beads-docs» where
  -- Settings for documentation generation
  moreLinkArgs := #["-L./.lake/packages/verso/.lake/build/lib"]

require verso from git "https://github.com/leanprover/verso.git"@leanVersion

@[default_target]
lean_lib BeadsDocs where
  roots := #[`BeadsDocs]

lean_exe «generate-site» where
  root := `Main
  supportInterpreter := true
