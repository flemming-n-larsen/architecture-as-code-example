# Keep Your Architecture Diagrams in Code, Not in Tools

## The Problem
Architecture diagrams in diagrams.net (draw.io), Lucidchart, or Visio get outdated fast. They live outside your repo, never get updated, and are invisible to AI tools.

## The Solution
Store diagrams as Markdown + Mermaid in your code repository.

## Why It Works

- **Versioned with code** - See architecture at any commit, review in PRs
- **No context switching** - Edit diagrams where you code
- **AI can read it** - Plain text is LLM-friendly
- **Free and portable** - Export to PNG/Confluence when needed

## Example in GitHub repository:
https://github.com/flemming-n-larsen/architecture-as-code-example
