import VersoBlog
import BeadsDocs
import BeadsDocs.LitApi

open Verso Genre Blog Site Syntax

-- Import literate Lean module with proper syntax highlighting and hover
literate_page apiDocs from BeadsDocs.LitApi in "." as "API Reference"

open Output Html Template Theme in
def theme : Theme := { Theme.default with
  primaryTemplate := do
    return {{
      <html lang="en">
        <head>
          <meta charset="UTF-8"/>
          <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
          <meta name="color-scheme" content="light dark"/>
          <title>{{ (← param (α := String) "title") }} " — Beads"</title>
          <link rel="stylesheet" href="https://unpkg.com/sakura.css/css/sakura.css" type="text/css"/>
          <link rel="stylesheet" href="/static/style.css" type="text/css"/>
          {{← builtinHeader }}
        </head>
        <body>
          <header>
            <h1><a href="/">"Beads"</a></h1>
            <p class="tagline">"Give your coding agent a memory upgrade"</p>
            <nav class="main-nav">
              <a href="/">"Home"</a>
              <a href="/quickstart/">"Quickstart"</a>
              <a href="/commands/">"Commands"</a>
              <a href="/architecture/">"Architecture"</a>
              <a href="/agents/">"Agents"</a>
              <a href="/api/">"API"</a>
            </nav>
          </header>
          <main>
            {{ (← param "content") }}
          </main>
          <footer>
            <p>"Beads Issue Tracker - "<a href="https://github.com/steveyegge/beads">"GitHub"</a></p>
          </footer>
        </body>
      </html>
    }}
  }

def beadsSite : Site := site BeadsDocs.FrontPage /
  static "static" ← "static"
  "quickstart" BeadsDocs.QuickStart
  "commands" BeadsDocs.Commands
  "architecture" BeadsDocs.Architecture
  "agents" BeadsDocs.Agents
  "configuration" BeadsDocs.Configuration
  "advanced" BeadsDocs.Advanced
  "api" apiDocs

def main := blogMain theme beadsSite
