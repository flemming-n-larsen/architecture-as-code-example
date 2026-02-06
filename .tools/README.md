# .tools Directory

This directory contains tools and dependencies used by the project's automation skills and CI/CD workflows. Tools are downloaded on-demand using the `download-tools.sh` script to keep the repository size small while ensuring consistent versions across environments.

## Quick Start

Run this script once to download all required tools:
```bash
.tools/download-tools.sh
```

This will download:
- **PlantUML** (~27 MB) - Diagram generation engine
- **Structurizr CLI** (~30 MB) - C4 architecture DSL parser and converter

**Note**: The JAR files are in `.gitignore` and are not committed to version control to keep the repository lightweight.

## Contents

### Structurizr CLI
**Location**: `structurizr-cli/`  
**Version**: 5.0.2  
**Purpose**: Command-line interface for the Structurizr DSL (Domain-Specific Language) for architecture as code

The Structurizr CLI is used to:
- Parse and validate C4 architecture model DSL files
- Convert DSL to various export formats (PlantUML, Mermaid, etc.)
- Generate diagrams from architecture definitions
- Validate workspace DSL syntax

**Key Components**:
- `structurizr-dsl-5.0.2.jar` - DSL parsing and conversion engine
- `structurizr-export-5.0.2.jar` - Multi-format export functionality
- `structurizr-core-5.0.2.jar` - Core Structurizr models and utilities
- `lib/` - Supporting libraries and dependencies

**Usage**:
```bash
# First time setup - download the tools
.tools/download-tools.sh

# Export DSL to PlantUML format
java -jar .tools/structurizr-dsl.jar export -w <workspace.dsl> -f plantuml -o <output_dir>

# Via wrapper script (Linux/macOS)
.tools/structurizr-cli/structurizr.sh export -w <workspace.dsl> -f plantuml -o <output_dir>

# Via batch file (Windows)
.tools/structurizr-cli/structurizr.bat export -w <workspace.dsl> -f plantuml -o <output_dir>
```

### PlantUML
**Location**: `plantuml.jar`  
**Version**: Latest (1.2026.x series)  
**Size**: ~27 MB  
**Purpose**: Diagram generation engine for converting PlantUML text format to SVG/PNG

PlantUML is used in the workflow to:
- Convert Structurizr's PlantUML output to SVG diagrams
- Support multiple diagram types (C4 components, deployment, etc.)
- Provide high-quality vector graphics for documentation

**Usage**:
```bash
# First time setup - download the tools
.tools/download-tools.sh

# Convert PlantUML to SVG
java -jar .tools/plantuml.jar -tsvg <input.puml> -o <output_dir>
```

## How It Works in the Skill Workflow

The Structurizr skill (`.github/skills/structurizr/`) uses these tools in a two-stage pipeline:

```
C4 DSL (.dsl)
    ↓
[Structurizr DSL JAR] → Validates & converts
    ↓
PlantUML (.puml)
    ↓
[PlantUML JAR] → Renders to vector graphics
    ↓
SVG Diagram (.svg)
```

### Example Workflow (from `generate.sh`)
```bash
# Stage 1: DSL → PlantUML
java -jar .tools/structurizr-dsl.jar export -w workspace.dsl -f plantuml -o output_dir

# Stage 2: PlantUML → SVG
java -jar .tools/plantuml.jar -tsvg output_dir/structurizr-*.puml -o output_dir
```

## Using in GitHub Actions

These tools can be referenced directly in workflow files without any external dependencies:

```yaml
name: Generate C4 Diagrams

on:
  push:
    paths:
      - 'architecture/c4-views/structurizr-dsl/**'

jobs:
  regenerate-diagrams:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          java-version: '17'
      
      - name: Download tools
        run: .tools/download-tools.sh
      
      - name: Regenerate diagrams from DSL
        run: |
          bash .github/skills/structurizr/generate.sh "$(cat architecture/c4-views/structurizr-dsl/system-context-view.dsl)"
      
      - name: Commit changes
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add architecture/c4-views/images/
          git commit -m "refactor: regenerate C4 diagrams from DSL" || true
          git push
```

## Why These Tools Are Downloaded (Not Bundled)

1. **Lightweight Repository**: Keeps Git repository size small (~57MB of tools not in version control)
2. **No Git LFS Required**: Everyone can clone and use the repo without Git LFS installed
3. **Version Control**: Tool versions are specified in `download-tools.sh`, ensuring consistency
4. **Simple Setup**: One-time `./download-tools.sh` execution downloads everything needed
5. **CI/CD Ready**: Works seamlessly in GitHub Actions and other CI/CD systems
6. **Cross-Platform**: Same script works on Linux, macOS, and Windows (with Git Bash/WSL)

## Requirements

- **Java 11+** is required to run these tools
  - Check with: `java --version`
  - Install: `apt install openjdk-17-jdk` (Ubuntu/Debian) or `brew install openjdk@17` (macOS)

## Updating Tools

To update any tool version, edit the version numbers in `download-tools.sh`:

### Updating Structurizr CLI
1. Find latest version at https://github.com/structurizr/cli/releases
2. Edit `STRUCTURIZR_VERSION` in `download-tools.sh`
3. Remove existing directory: `rm -rf .tools/structurizr-cli`
4. Re-run: `.tools/download-tools.sh`
5. Test with sample DSL files
6. Commit changes: `git add .tools/download-tools.sh && git commit -m "chore: update Structurizr CLI to vX.X.X"`

### Updating PlantUML
1. Find latest version at https://github.com/plantuml/plantuml/releases
2. Edit `PLANTUML_VERSION` in `download-tools.sh`
3. Remove existing JAR: `rm .tools/plantuml.jar`
4. Re-run: `.tools/download-tools.sh`
5. Test diagram generation
6. Commit changes: `git add .tools/download-tools.sh && git commit -m "chore: update PlantUML to vX.X.X"`

⚠️ **Important**: Always test updated tools with sample DSL files before committing to ensure compatibility with existing workflows.

## First Time Setup

After cloning the repository, run:
```bash
.tools/download-tools.sh
```

This downloads all required tools to the `.tools/` directory (these files are gitignored and not committed).

## Related Documentation

- **Structurizr DSL Guide**: https://docs.structurizr.com/dsl
- **Structurizr CLI Docs**: https://github.com/structurizr/cli/blob/main/docs/index.md
- **PlantUML User Guide**: https://plantuml.com/
- **Project Skill**: See `.github/skills/structurizr/README.md`
- **AI Instructions**: See `.github/skills/structurizr/AI_INSTRUCTIONS.md`

## Troubleshooting

### "Tools not found" - First time setup
```bash
# Run the download script first
.tools/download-tools.sh
```

### "Java not found"
```bash
java --version
# If not installed: apt install openjdk-17-jdk
```

### "JAR not found" or symlink broken
```bash
# Re-run the download script
.tools/download-tools.sh
```

### "PlantUML conversion failed"
- Ensure PlantUML JAR is present: `ls -lh .tools/plantuml.jar`
- If missing, run: `.tools/download-tools.sh`
- Check file is not corrupted: `file .tools/plantuml.jar`
- Java version may be too old: `java --version` (Java 11+ required)

### Download failures
- Check internet connection
- Verify GitHub releases are accessible
- Try manually downloading from URLs shown in error messages

## License

These tools are provided by their respective maintainers:
- **Structurizr CLI**: https://github.com/structurizr/cli (Commercial/Enterprise)
- **PlantUML**: https://plantuml.com/ (GPL v3)

Verify licenses comply with your project's licensing requirements.


