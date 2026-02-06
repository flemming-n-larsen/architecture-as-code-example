# GitHub Copilot Structurizr Skill

Convert C4 DSL workspace blocks to SVG diagrams automatically.

## 🤖 For AI Agents

**IMPORTANT**: This skill uses tools **bundled at the project root** in the `.tools/` directory:
- **Structurizr CLI**: `.tools/structurizr-cli/structurizr.sh` (with all JARs in `lib/`)
- **PlantUML JAR**: `.tools/plantuml.jar`

**DO NOT attempt to download or install these tools** - they are already available and ready to use.

📖 **See [AI_INSTRUCTIONS.md](AI_INSTRUCTIONS.md) for detailed AI agent guidance.**

### How to Use from AI

1. Call the generation script: `bash .github/skills/structurizr/generate.sh '<workspace_dsl_content>'`
2. The script automatically uses the embedded tools in the `tools/` directory
3. SVG files are generated in `/architecture/images/`

The script performs pre-checks to verify Java availability and confirms the embedded tools are present before processing.

## 🚀 Usage

1. **Select C4 DSL text** containing a workspace block:
   ```
   workspace {
       name "IIP Baldur System"
       model {
           user = person "Data Manager" "Manages deduplication workflows"
           baldur = softwareSystem "IIP Baldur" "Deduplication system for EDM/MICA-2024"
           user -> baldur "manages workflows"
       }
   }
   ```

2. **Ask GitHub Copilot**: *"Use the Structurizr skill to generate diagrams"*

3. **Get SVG files** in `/architecture/images/` with simplified, predictable names:
   - `system-context.svg` - System context diagram
   - `container.svg` - Container diagram
   - `component-<name>.svg` - Component diagrams (e.g., `component-DataFetcher.svg`)
   - `deployment.svg` - Deployment diagram
   - `system-landscape.svg` - System landscape diagram

## ⚡ Features

- ✅ **Zero installation** - All tools bundled (only requires Java 11+)
- ✅ **Multiple views** - SystemContext, SystemLandscape, Container, Component, Deployment
- ✅ **Version control friendly** - Predictable file names without hash-based uniqueness
- ✅ **Clean naming** - Simple names like `system-context.svg`, `container.svg`, `component-<name>.svg`
- ✅ **Clean output** - SVG files only, no intermediate files
- ✅ **User customizable** - Simple names allow users to rename files as needed

## 🎯 Requirements

| Tool | Status | Location |
|------|--------|----------|
| **Java 11+** | Required | System installation |
| **Structurizr CLI** | ✅ Bundled | `tools/structurizr-cli/` |
| **PlantUML** | ✅ Bundled | `tools/plantuml.jar` |

## 🎨 Supported C4 Elements

- `person` - People/actors
- `softwareSystem` - Software systems
- `container` - Containers within systems
- `component` - Components within containers
- Relationships with `->` notation
- Automatic styling and layouts

## 📝 Example Test

Test the skill by selecting this workspace block and invoking the skill:

```
workspace {
    name "Test System"
    model {
        user = person "User" "System user"
        system = softwareSystem "Test System" "A test system"
        user -> system "uses"
    }
}
```

**Result**: Clean SVG files ready for documentation! 🎉
