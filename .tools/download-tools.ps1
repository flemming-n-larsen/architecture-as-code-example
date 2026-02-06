# Download and setup required tools for Structurizr C4 DSL generation
# This script ensures consistent tool versions across all environments
# PowerShell 5.1+ compatible version for Windows

# Tool versions
$STRUCTURIZR_VERSION = "2025.11.09"
$PLANTUML_VERSION = "1.2024.8"

# Get script directory
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$TOOLS_DIR = $SCRIPT_DIR

# Color definitions for PowerShell (using ANSI escape codes for PS 5.1+)
$colors = @{
    Green  = "`e[0;32m"
    Yellow = "`e[1;33m"
    Red    = "`e[0;31m"
    Reset  = "`e[0m"
}

<#
.SYNOPSIS
Write colored output to console
#>
function Write-ColoredOutput {
    param(
        [string]$Message,
        [string]$Color = "Reset"
    )
    Write-Host "$($colors[$Color])$Message$($colors['Reset'])"
}

<#
.SYNOPSIS
Check if a command exists
#>
function Test-CommandExists {
    param([string]$Command)

    try {
        $null = Get-Command $Command -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

<#
.SYNOPSIS
Download a file with progress indication
#>
function Invoke-Download {
    param(
        [string]$Url,
        [string]$OutFile
    )

    Write-Host "Downloading from: $Url"

    try {
        # Use PowerShell's Invoke-WebRequest with progress
        $ProgressPreference = 'Continue'
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
        return $true
    }
    catch {
        Write-ColoredOutput "Failed to download: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Main execution
Write-ColoredOutput "=== Downloading Structurizr & PlantUML Tools ===" "Green"
Write-Host ""

# Check if Java is available
if (-not (Test-CommandExists java)) {
    Write-ColoredOutput "Error: Java is not installed. Please install Java 11+ first." "Red"
    Write-Host "  Download from: https://adoptium.net/"
    exit 1
}

# Check Java version
$java_output = & java -version 2>&1
$java_version_line = $java_output[0]
Write-ColoredOutput "[+] Java version: $java_version_line" "Green"

# Extract Java version number (try both old and new format)
$java_version = 0
if ($java_version_line -match "version `"(\d+)") {
    $java_version = [int]$matches[1]
}
elseif ($java_version_line -match "(\d+)\.") {
    $java_version = [int]$matches[1]
}

if ($java_version -lt 11) {
    Write-ColoredOutput "Error: Java 11+ is required (found Java $java_version)" "Red"
    exit 1
}

Write-Host ""

# Download PlantUML
$PLANTUML_JAR = Join-Path $TOOLS_DIR "plantuml.jar"
if (Test-Path $PLANTUML_JAR) {
    Write-ColoredOutput "PlantUML already exists, skipping download" "Yellow"
}
else {
    Write-Host "Downloading PlantUML v${PLANTUML_VERSION}..."
    $plantuml_url = "https://github.com/plantuml/plantuml/releases/download/v${PLANTUML_VERSION}/plantuml-${PLANTUML_VERSION}.jar"

    if (Invoke-Download -Url $plantuml_url -OutFile $PLANTUML_JAR) {
        Write-ColoredOutput "[+] PlantUML downloaded" "Green"
    }
    else {
        Write-ColoredOutput "[x] Failed to download PlantUML" "Red"
        exit 1
    }
}

Write-Host ""

# Download Structurizr CLI
$STRUCTURIZR_DIR = Join-Path $TOOLS_DIR "structurizr-cli"
$STRUCTURIZR_ZIP = Join-Path $TOOLS_DIR "structurizr-cli.zip"

if (Test-Path $STRUCTURIZR_DIR) {
    Write-ColoredOutput "Structurizr CLI already exists, skipping download" "Yellow"
}
else {
    Write-Host "Downloading Structurizr CLI v${STRUCTURIZR_VERSION}..."
    $structurizr_url = "https://github.com/structurizr/cli/releases/download/v${STRUCTURIZR_VERSION}/structurizr-cli.zip"

    if (Invoke-Download -Url $structurizr_url -OutFile $STRUCTURIZR_ZIP) {
        Write-Host "Extracting Structurizr CLI..."

        try {
            # Use PowerShell's built-in Expand-Archive for PS 5.1+
            Expand-Archive -Path $STRUCTURIZR_ZIP -DestinationPath $STRUCTURIZR_DIR -Force
            Remove-Item -Path $STRUCTURIZR_ZIP -Force

            Write-ColoredOutput "[+] Structurizr CLI downloaded and extracted" "Green"
        }
        catch {
            Write-ColoredOutput "[x] Failed to extract Structurizr CLI: $($_.Exception.Message)" "Red"
            exit 1
        }
    }
    else {
        Write-ColoredOutput "[x] Failed to download Structurizr CLI" "Red"
        exit 1
    }
}

Write-Host ""

# Create hard link for easier access to structurizr-dsl.jar
$structurizr_dsl_jars = Get-ChildItem -Path (Join-Path $STRUCTURIZR_DIR "lib") -Filter "structurizr-dsl-*.jar" -ErrorAction SilentlyContinue

if ($structurizr_dsl_jars) {
    $STRUCTURIZR_DSL_JAR = $structurizr_dsl_jars[0].FullName
    $STRUCTURIZR_DSL_LINK = Join-Path $TOOLS_DIR "structurizr-dsl.jar"

    # Check if link already exists
    if (Test-Path $STRUCTURIZR_DSL_LINK) {
        Remove-Item -Path $STRUCTURIZR_DSL_LINK -Force -ErrorAction SilentlyContinue
    }

    try {
        # Use cmd mklink for better compatibility
        $target = Resolve-Path $STRUCTURIZR_DSL_JAR
        $link = $STRUCTURIZR_DSL_LINK
        cmd /c mklink /H "$link" "$target" 2>&1 | Out-Null

        Write-ColoredOutput "[+] Created link: structurizr-dsl.jar -> $((Split-Path -Leaf $STRUCTURIZR_DSL_JAR))" "Green"
    }
    catch {
        # Fallback: if symlink fails, just copy the file
        Copy-Item -Path $STRUCTURIZR_DSL_JAR -Destination $STRUCTURIZR_DSL_LINK -Force
        Write-ColoredOutput "[+] Copied structurizr-dsl.jar (symlink not supported on this system)" "Green"
    }
}

Write-Host ""
Write-ColoredOutput "=== Tools Setup Complete ===" "Green"
Write-Host ""
Write-Host "Available tools:"
Write-Host "  - PlantUML: $PLANTUML_JAR"
Write-Host "  - Structurizr CLI: $STRUCTURIZR_DIR"
Write-Host ""
Write-Host "Test the setup:"
Write-Host "  java -jar $PLANTUML_JAR -version"
$structurizr_dsl_jar_path = Join-Path $TOOLS_DIR "structurizr-dsl.jar"
Write-Host "  java -jar $structurizr_dsl_jar_path --version"
Write-Host ""

