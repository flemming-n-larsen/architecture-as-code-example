#!/usr/bin/env pwsh
# Helper script for GitHub Copilot Structurizr skill
# This script processes C4 DSL workspace blocks and generates SVG diagrams
# PowerShell version - 1:1 mapping from generate.sh

param(
    [Parameter(Position=0)]
    [string]$WorkspaceDSL
)

# Paths
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_ROOT = Resolve-Path (Join-Path $SCRIPT_DIR "..\..") -ErrorAction Stop
$ARCHITECTURE_DIR = Join-Path $PROJECT_ROOT "architecture"
$C4_VIEWS_DIR = Join-Path $ARCHITECTURE_DIR "c4-views"
$IMAGES_DIR = Join-Path $C4_VIEWS_DIR "images"
$TOOLS_DIR = Join-Path $PROJECT_ROOT ".tools"
$STRUCTURIZR_CLI = Join-Path $TOOLS_DIR "structurizr-cli\structurizr.bat"

# Colors
$RED = "`e[0;31m"
$GREEN = "`e[0;32m"
$YELLOW = "`e[1;33m"
$BLUE = "`e[0;34m"
$NC = "`e[0m"

# Ensure images directory exists
if (-not (Test-Path $IMAGES_DIR)) {
    New-Item -ItemType Directory -Path $IMAGES_DIR -Force | Out-Null
}

function command_exists {
    param([string]$cmd)
    try {
        Get-Command $cmd -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function tools_exist {
    $plantuml_jar = Join-Path $TOOLS_DIR "plantuml.jar"
    $structurizr_jar = Join-Path $TOOLS_DIR "structurizr-dsl.jar"
    $structurizr_lib = Join-Path $TOOLS_DIR "structurizr-cli\lib"

    if ((Test-Path $plantuml_jar) -and
        (Test-Path $structurizr_jar) -and
        (Test-Path $structurizr_lib) -and
        ((Get-ChildItem $structurizr_lib -ErrorAction SilentlyContinue).Count -gt 0)) {
        return $true
    }
    return $false
}

function perform_prechecks {
    Write-Host "${BLUE}[*] Performing pre-checks...${NC}"
    $issues_found = $false

    Write-Host "Detected OS: windows"
    Write-Host ""

    # Check Java
    if (command_exists "java") {
        $java_version = (& java -version 2>&1)[0]
        Write-Host "${GREEN}[+] Java: $java_version${NC}"
    }
    else {
        Write-Host "${RED}[x] Java: NOT FOUND${NC}"
        Write-Host "${YELLOW}   Please install Java 11+ from: https://adoptium.net/${NC}"
        $issues_found = $true
    }

    # Check tools
    $download_script = Join-Path $TOOLS_DIR "download-tools.ps1"

    if (tools_exist) {
        $plantuml_jar = Join-Path $TOOLS_DIR "plantuml.jar"
        $plantuml_version = (& java -jar $plantuml_jar -version 2>&1)[0]
        Write-Host "${GREEN}[+] PlantUML: $plantuml_version${NC}"
        Write-Host "${GREEN}[+] Structurizr CLI: Available${NC}"
    }
    else {
        Write-Host "${YELLOW}[!] Tools not found or incomplete${NC}"
        if (Test-Path $download_script) {
            Write-Host "${BLUE}   Running $download_script...${NC}"
            & $download_script
            if ($LASTEXITCODE -eq 0) {
                Write-Host "${GREEN}[+] Tools downloaded successfully${NC}"
            }
            else {
                Write-Host "${RED}[x] Failed to download tools${NC}"
                $issues_found = $true
            }
        }
        else {
            Write-Host "${RED}[x] Download script not found at: $download_script${NC}"
            $issues_found = $true
        }
    }

    Write-Host ""

    if ($issues_found) {
        Write-Host "${RED}[x] Pre-checks failed. Please resolve the issues above.${NC}"
        exit 1
    }
    else {
        Write-Host "${GREEN}[+] All pre-checks passed!${NC}"
        Write-Host ""
    }
}

function extract_diagram_name {
    param([string]$workspace_content)

    # Look for workspace name
    if ($workspace_content -match 'workspace\s+"([^"]+)"') {
        $name = $matches[1].ToLower()
        $name = $name -replace '[^a-z0-9]', '-'
        $name = $name -replace '-+', '-'
        $name = $name -replace '^-', ''
        $name = $name -replace '-$', ''
        return $name
    }

    # Generate from hash
    $hash = [System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($workspace_content))
    $hash_str = [BitConverter]::ToString($hash).Replace("-","").Substring(0,8).ToLower()
    return "diagram-$hash_str"
}

function process_workspace {
    param([string]$workspace_content)

    $temp_dir = Join-Path $env:TEMP "structurizr-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp_dir -Force | Out-Null

    $diagram_name = extract_diagram_name $workspace_content
    $dsl_file = Join-Path $temp_dir "$diagram_name.dsl"

    Write-Host "${BLUE}[D] Processing workspace: $diagram_name${NC}"

    # Write DSL file
    $workspace_content | Out-File -FilePath $dsl_file -Encoding UTF8

    # Generate diagrams
    Write-Host "${BLUE}[>] Running: $STRUCTURIZR_CLI export -w $dsl_file -f plantuml -o $temp_dir${NC}"

    if (Test-Path $STRUCTURIZR_CLI) {
        & cmd /c $STRUCTURIZR_CLI export -w $dsl_file -f plantuml -o $temp_dir
        Write-Host "${GREEN}[+] Generated PlantUML diagrams${NC}"

        # Convert PlantUML to SVG
        $svg_count = 0
        $puml_count = 0

        $puml_files = Get-ChildItem -Path $temp_dir -Filter "structurizr-*.puml" -ErrorAction SilentlyContinue

        foreach ($puml_file in $puml_files) {
            $base_name = $puml_file.BaseName

            # Skip key/legend diagrams
            if ($base_name -match "-key$") {
                continue
            }

            # Determine output name
            $output_name = "container"
            if ($base_name -match "Component") {
                $component_name = ($base_name -replace 'structurizr-\d+-Component-', '')
                $output_name = "component-$component_name"
            }
            elseif ($base_name -match "SystemContext") {
                $output_name = "system-context"
            }
            elseif ($base_name -match "Deployment") {
                $output_name = "deployment"
            }
            elseif ($base_name -match "Container") {
                $output_name = "container"
            }
            elseif ($base_name -match "SystemLandscape") {
                $output_name = "system-landscape"
            }

            $puml_count++

            # Convert to SVG
            $plantuml_jar = Join-Path $TOOLS_DIR "plantuml.jar"
            Write-Host "${BLUE}   Converting $base_name.puml to SVG (using bundled JAR)...${NC}"

            & java -jar $plantuml_jar -tsvg $puml_file.FullName -o $temp_dir 2>&1 | Out-Null

            $svg_file = Join-Path $temp_dir "$base_name.svg"
            if (Test-Path $svg_file) {
                $output_svg = Join-Path $IMAGES_DIR "$output_name.svg"
                Copy-Item -Path $svg_file -Destination $output_svg -Force
                Write-Host "${GREEN}[+] Created SVG: $output_name.svg${NC}"
                Write-Host "${BLUE}    Reference: ![${output_name}](/architecture/c4-views/images/${output_name}.svg)${NC}"
                $svg_count++
            }
            else {
                Write-Host "${RED}   [x] SVG file not created: $svg_file${NC}"
            }
        }

        Write-Host ""
        Write-Host "${GREEN}[D] Summary:${NC}"
        Write-Host "${GREEN}   [+] Processed $puml_count PlantUML diagram(s)${NC}"
        Write-Host "${GREEN}   [+] Generated $svg_count SVG file(s)${NC}"

        if ($svg_count -eq 0) {
            Write-Host "${RED}   [x] No SVG files were generated${NC}"
        }
    }
    else {
        Write-Host "${RED}[x] Failed to process DSL with Structurizr CLI${NC}"
        Write-Host "${YELLOW}DSL content:${NC}"
        Get-Content $dsl_file
    }

    # Cleanup
    Remove-Item -Recurse -Force $temp_dir -ErrorAction SilentlyContinue
    Write-Host ""
}

# Main execution
if (-not $WorkspaceDSL) {
    Write-Host "${BLUE}[*] Structurizr C4 DSL to SVG Generator${NC}"
    Write-Host "${BLUE}Usage: $($MyInvocation.MyCommand.Name) '<workspace_dsl_content>'${NC}"
    Write-Host ""
    Write-Host "Requirements: Java 11+ (all tools bundled)"
    Write-Host "Output: SVG files saved to /architecture/c4-views/images/"
    Write-Host ""
    Write-Host "Example:"
    Write-Host "$($MyInvocation.MyCommand.Name) 'workspace { model { user = person `"User`" } }'"
    exit 1
}

Write-Host "${BLUE}[*] Structurizr C4 DSL to SVG Generator${NC}"
Write-Host "${BLUE}[>] Output directory: $IMAGES_DIR${NC}"
Write-Host ""

perform_prechecks
process_workspace $WorkspaceDSL

Write-Host "${GREEN}[*] Processing complete!${NC}"








