#!/bin/bash
# Helper script for GitHub Copilot Structurizr skill
# This script processes C4 DSL workspace blocks and generates SVG diagrams

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
ARCHITECTURE_DIR="$PROJECT_ROOT/architecture"
C4_VIEWS_DIR="$ARCHITECTURE_DIR/c4-views"
IMAGES_DIR="${IMAGES_DIR:-$C4_VIEWS_DIR/images}"
SKILL_DIR="$(dirname "${BASH_SOURCE[0]}")"
TOOLS_DIR="$PROJECT_ROOT/.tools"
STRUCTURIZR_CLI="$TOOLS_DIR/structurizr-cli/structurizr.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ensure images directory exists
mkdir -p "$IMAGES_DIR"

# Function to detect operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            if [[ "$ID" == "ubuntu" ]] || [[ "$ID_LIKE" == *"ubuntu"* ]] || [[ "$ID_LIKE" == *"debian"* ]]; then
                echo "ubuntu"
            else
                echo "linux"
            fi
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if tools are already downloaded
tools_exist() {
    local plantuml_jar="$TOOLS_DIR/plantuml.jar"
    local structurizr_jar="$TOOLS_DIR/structurizr-dsl.jar"
    local structurizr_lib="$TOOLS_DIR/structurizr-cli/lib"

    # Check if all required files/folders exist and are non-empty
    if [ -f "$plantuml_jar" ] && [ -f "$structurizr_jar" ] && [ -d "$structurizr_lib" ] && [ "$(ls -A "$structurizr_lib" 2>/dev/null | wc -l)" -gt 0 ]; then
        return 0  # Tools exist
    else
        return 1  # Tools missing or incomplete
    fi
}

# Function to perform pre-checks
perform_prechecks() {
    echo -e "${BLUE}🔍 Performing pre-checks...${NC}"
    local issues_found=false
    local os=$(detect_os)
    
    echo "Detected OS: $os"
    echo ""
    
    # Check Java (required for both tools)
    if command_exists java; then
        local java_version=$(java --version 2>/dev/null | head -1 || java -version 2>&1 | head -1)
        echo -e "${GREEN}✅ Java: $java_version${NC}"
    else
        echo -e "${RED}❌ Java: NOT FOUND${NC}"
        echo -e "${YELLOW}   Java is required for both Structurizr CLI and PlantUML${NC}"
        case $os in
            "ubuntu")
                echo "   Install with: sudo apt install openjdk-17-jdk"
                ;;
            "macos")
                echo "   Install with: brew install openjdk@17"
                ;;
            *)
                echo "   Please install Java 11+ from: https://adoptium.net/"
                ;;
        esac
        issues_found=true
    fi
    
    # Check if tools are already downloaded
    local download_script="$TOOLS_DIR/download-tools.sh"

    if tools_exist; then
        # Tools are complete, just verify they work
        local plantuml_jar="$TOOLS_DIR/plantuml.jar"
        local structurizr_jar="$TOOLS_DIR/structurizr-dsl.jar"

        local plantuml_version=$(java -jar "$plantuml_jar" -version 2>/dev/null | head -1 || echo "version unknown")
        echo -e "${GREEN}✅ PlantUML: $plantuml_version${NC}"
        echo -e "${GREEN}✅ Structurizr CLI: Available at $structurizr_jar${NC}"
    else
        # Tools are missing or incomplete, download them
        echo -e "${YELLOW}⚠️  Tools not found or incomplete${NC}"
        if [ -f "$download_script" ]; then
            echo -e "${BLUE}   Running $download_script...${NC}"
            if bash "$download_script"; then
                echo -e "${GREEN}✅ Tools downloaded successfully${NC}"
            else
                echo -e "${RED}❌ Failed to download tools${NC}"
                echo -e "${YELLOW}   Please run manually: $download_script${NC}"
                issues_found=true
            fi
        else
            echo -e "${RED}❌ Download script not found at: $download_script${NC}"
            echo -e "${YELLOW}   Please ensure .tools/download-tools.sh exists${NC}"
            issues_found=true
        fi
    fi
    
    echo ""
    
    if [ "$issues_found" = true ]; then
        echo -e "${RED}❌ Pre-checks failed. Please resolve the issues above before continuing.${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ All pre-checks passed!${NC}"
        echo ""
    fi
}

# Function to extract diagram name from workspace content
extract_diagram_name() {
    local workspace_content="$1"
    local name=""
    
    # Look for name, title, or description
    name=$(echo "$workspace_content" | grep -oiE '(name|title|description)[[:space:]]*"[^"]+' | head -1 | sed 's/.*"\([^"]*\)".*/\1/' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-\|-$//g')
    
    if [ -z "$name" ]; then
        # Generate name from content hash
        local hash=$(echo "$workspace_content" | md5sum | cut -c1-8)
        name="diagram-$hash"
    fi
    
    echo "$name"
}

# Function to add views to workspace if missing
add_views_if_missing() {
    local workspace_content="$1"
    
    if echo "$workspace_content" | grep -q "views[[:space:]]*{"; then
        echo "$workspace_content"
    else
        # Extract software system names for views
        local systems=$(echo "$workspace_content" | grep -oE '[a-zA-Z][a-zA-Z0-9]*[[:space:]]*=[[:space:]]*softwareSystem' | cut -d'=' -f1 | tr -d ' ')
        local first_system=$(echo "$systems" | head -1)
        
        # Remove last closing brace and add views
        local content_without_closing=$(echo "$workspace_content" | sed '$s/}$//')
        cat << EOF
$content_without_closing
    views {
        systemLandscape "SystemLandscape" {
            include *
            autoLayout
        }
EOF
        
        # Add systemContext for each software system
        if [ -n "$first_system" ]; then
            echo "        systemContext $first_system \"SystemContext\" {"
        else
            echo "        systemContext \"SystemContext\" {"
        fi
        
        cat << 'EOF'
            include *
            autoLayout
        }
        
        styles {
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
        }
    }
}
EOF
    fi
}

# Function to extract component name from workspace content for component diagrams
extract_component_name() {
    local workspace_content="$1"
    # Try to extract component container name from the DSL
    # Looks for patterns like: component <name> { inside container block
    # Or from workspace name like "AIS Dedup - Data Fetcher Components"
    local comp_name=$(echo "$workspace_content" | grep -oiE '"C4 Component diagram for [^"]*' | sed 's/.*for //; s/ Component.*//; s/Library//' | head -1)
    echo "$comp_name"
}

# Function to process workspace and generate diagrams
process_workspace() {
    local workspace_content="$1"
    local temp_dir=$(mktemp -d)
    local diagram_name=$(extract_diagram_name "$workspace_content")
    local dsl_file="$temp_dir/$diagram_name.dsl"
    local component_name=$(extract_component_name "$workspace_content")

    echo -e "${BLUE}📊 Processing workspace: $diagram_name${NC}"
    
    # Add views if missing
    local complete_dsl=$(add_views_if_missing "$workspace_content")
    
    # Write DSL file
    echo "$complete_dsl" > "$dsl_file"
    
    # Generate diagrams using Structurizr CLI
    echo -e "${BLUE}🔄 Running: $STRUCTURIZR_CLI export -w $dsl_file -f plantuml -o $temp_dir${NC}"
    if "$STRUCTURIZR_CLI" export -w "$dsl_file" -f plantuml -o "$temp_dir" 2>&1; then
        echo -e "${GREEN}✅ Generated PlantUML diagrams${NC}"
        
        # Convert PlantUML to SVG (PlantUML is required)
        local svg_count=0
        local puml_count=0
        for puml_file in "$temp_dir"/structurizr-*.puml; do
            if [ -f "$puml_file" ]; then
                local base_name=$(basename "$puml_file" .puml)

                # Skip key/legend diagrams
                if [[ "$base_name" == *"-key" ]]; then
                    continue
                fi

                # Extract diagram type from base_name (e.g., "structurizr-1-Component-DataFetcher")
                # and map to simplified output name
                local diagram_type=""
                if [[ "$base_name" =~ Component ]]; then
                    # Extract component name: structurizr-X-Component-ComponentName
                    local puml_component_name=$(echo "$base_name" | sed -E 's/structurizr-[0-9]+-Component-(.+)/\1/')
                    # Use extracted component name if available, otherwise use the one from DSL
                    if [ -z "$component_name" ]; then
                        component_name="$puml_component_name"
                    fi
                    diagram_type="component"
                    local output_name="${diagram_type}-${component_name}"
                elif [[ "$base_name" =~ SystemContext ]]; then
                    diagram_type="system-context"
                    local output_name="$diagram_type"
                elif [[ "$base_name" =~ Deployment ]]; then
                    diagram_type="deployment"
                    local output_name="$diagram_type"
                elif [[ "$base_name" =~ Container ]]; then
                    diagram_type="container"
                    local output_name="$diagram_type"
                elif [[ "$base_name" =~ SystemLandscape ]]; then
                    diagram_type="system-landscape"
                    local output_name="$diagram_type"
                else
                    # Fallback for unknown types
                    local output_name="${base_name#structurizr-}"
                fi
                puml_count=$((puml_count + 1))
                
                # Convert to SVG using bundled PlantUML JAR from .tools
                local plantuml_jar="$TOOLS_DIR/plantuml.jar"

                echo -e "${BLUE}   Converting $base_name.puml to SVG (using bundled JAR)...${NC}"
                
                if java -jar "$plantuml_jar" -tsvg "$puml_file" -o "$temp_dir" >/dev/null 2>&1; then
                    local svg_file="$temp_dir/$base_name.svg"
                    if [ -f "$svg_file" ]; then
                        cp "$svg_file" "$IMAGES_DIR/$output_name.svg"
                        echo -e "${GREEN}📸 Created SVG: $output_name.svg${NC}"
                        echo -e "${BLUE}📎 Reference: ![${output_name}](/architecture/c4-views/images/${output_name}.svg)${NC}"
                        svg_count=$((svg_count + 1))
                    else
                        echo -e "${RED}   ❌ SVG file not created: $svg_file${NC}"
                    fi
                else
                    echo -e "${RED}   ❌ PlantUML conversion failed for $base_name.puml${NC}"
                fi
            fi
        done
        
        echo ""
        echo -e "${GREEN}📊 Summary:${NC}"
        echo -e "${GREEN}   • Processed $puml_count PlantUML diagram(s)${NC}"
        echo -e "${GREEN}   • Generated $svg_count SVG file(s)${NC}"
        
        if [ $svg_count -eq 0 ]; then
            echo -e "${RED}   • No SVG files were generated${NC}"
        fi
    else
        echo -e "${RED}❌ Failed to process DSL with Structurizr CLI${NC}"
        echo -e "${YELLOW}DSL content:${NC}"
        cat "$dsl_file"
    fi
    
    # Cleanup
    rm -rf "$temp_dir"
    echo ""
}

# Main execution
if [ $# -eq 0 ]; then
    echo -e "${BLUE}🚀 Structurizr C4 DSL to SVG Generator${NC}"
    echo -e "${BLUE}Usage: $0 '<workspace_dsl_content>'${NC}"
    echo ""
    echo "Requirements: Java 11+ (all tools bundled)"
    echo "Output: SVG files saved to /architecture/c4-views/images/"
    echo ""
    echo "Example:"
    echo "$0 'workspace { model { user = person \"User\" } }'"
    exit 1
fi

echo -e "${BLUE}🚀 Structurizr C4 DSL to SVG Generator${NC}"
echo -e "${BLUE}📂 Output directory: $IMAGES_DIR${NC}"
echo ""

# Perform pre-checks before processing
perform_prechecks

# Process the provided workspace content
process_workspace "$1"

echo -e "${GREEN}✨ Processing complete!${NC}"
