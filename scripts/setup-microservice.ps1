# Setup AI Dev Extensions Core in any project (ms, lib, any language)
# Creates symlinks for workflows, rules, and skills in your IDE
#
# USAGE:
#   From microservice root:
#     .\.dev-extensions\scripts\setup-microservice.ps1
#
# EXAMPLES:
#   .\setup-microservice.ps1                    # Auto-detect IDE, default domains
#   .\setup-microservice.ps1 -IDE cursor        # Use specific IDE
#   .\setup-microservice.ps1 -DryRun            # Preview changes only
#
# WHAT IT DOES:
#   - Detects your IDE (Windsurf/Cursor/VS Code)
#   - Creates symlinks to workflows and rules
#   - Updates .gitignore
#   - Loads domains (_core + architecture by default)

param(
    [string]$MicroservicePath = ".",
    [string]$IDE = "auto",
    [string]$Domains = "default",
    [string]$ConfigFile = ".dev-extensions.config.yaml",
    [switch]$DirectSymlinks = $false,
    [switch]$UseCopy = $false,
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"

Write-Host "AI Dev Extensions Setup" -ForegroundColor Cyan
Write-Host ""

# Change to microservice directory
Set-Location $MicroservicePath
$basePath = (Get-Location).Path
Write-Host "Working in: $basePath" -ForegroundColor Yellow
Write-Host ""

# Check if .dev-extensions exists
if (-not (Test-Path ".dev-extensions")) {
    Write-Host "ERROR: .dev-extensions submodule not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please add the submodule first:" -ForegroundColor Yellow
    Write-Host "  git submodule add <repo-url> .dev-extensions" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

# Check if this is a git repository
if (-not (Test-Path ".git")) {
    Write-Host "ERROR: Not a git repository!" -ForegroundColor Red
    Write-Host "This script must be run from the root of a git repository." -ForegroundColor Yellow
    exit 1
}

# Check for symlink permissions (Windows)
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin -and -not $UseCopy) {
    Write-Host ""
    Write-Host "INFO: Not running as Administrator - will use copy mode instead of symlinks" -ForegroundColor Cyan
    Write-Host "  Files will be copied instead of symlinked (requires manual update when package changes)" -ForegroundColor Gray
    Write-Host "  To use symlinks: Run as Administrator or enable Developer Mode" -ForegroundColor Gray
    Write-Host ""
    $UseCopy = $true
}

# Function to read simple YAML (basic key-value parsing)
function Read-SimpleYaml {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        return $null
    }
    
    $yaml = @{}
    $currentSection = $null
    $content = Get-Content $FilePath
    
    foreach ($line in $content) {
        $line = $line.Trim()
        
        # Skip comments and empty lines
        if ($line -match '^\s*#' -or $line -eq '') {
            continue
        }
        
        # Section header (e.g., "domains:")
        if ($line -match '^(\w+):$') {
            $currentSection = $matches[1]
            $yaml[$currentSection] = @{}
            continue
        }
        
        # Key-value pair
        if ($line -match '^\s*(\w+):\s*(.*)$') {
            $key = $matches[1]
            $value = $matches[2].Trim('"', "'")
            
            if ($currentSection) {
                $yaml[$currentSection][$key] = $value
            } else {
                $yaml[$key] = $value
            }
        }
    }
    
    return $yaml
}

# Function to get enabled domains
function Get-EnabledDomains {
    param(
        [string]$DomainsParam,
        [string]$ConfigPath,
        [string]$ManifestPath
    )
    
    # Priority 1: Command line parameter
    if ($DomainsParam -ne "default") {
        if ($DomainsParam -eq "all") {
            # Get all domains from manifest
            $manifest = Read-SimpleYaml $ManifestPath
            if ($manifest -and $manifest.ContainsKey('domains')) {
                return $manifest['domains'].Keys
            }
            return @("_core", "architecture")
        }
        return $DomainsParam -split ","
    }
    
    # Priority 2: Config file
    if (Test-Path $ConfigPath) {
        $config = Read-SimpleYaml $ConfigPath
        if ($config -and $config.ContainsKey('domains')) {
            $enabledDomains = @()
            foreach ($domain in $config['domains'].Keys) {
                if ($config['domains'][$domain] -eq 'true') {
                    $enabledDomains += $domain
                }
            }
            if ($enabledDomains.Count -gt 0) {
                return $enabledDomains
            }
        }
    }
    
    # Priority 3: Manifest defaults
    $manifest = Read-SimpleYaml $ManifestPath
    if ($manifest -and $manifest.ContainsKey('domains')) {
        $enabledDomains = @()
        foreach ($domain in $manifest['domains'].Keys) {
            # In simple parsing, we check if enabled_by_default is mentioned
            # This is a simplified approach - a full YAML parser would be better
            $enabledDomains += $domain
        }
        if ($enabledDomains.Count -gt 0) {
            return $enabledDomains
        }
    }
    
    # Fallback
    return @("_core", "architecture")
}

# Function to read IDE mapping from YAML
function Get-IDEMapping {
    param(
        [string]$IDE,
        [string]$MappingFile
    )
    
    if (-not (Test-Path $MappingFile)) {
        Write-Host "[WARNING] IDE mapping file not found: $MappingFile" -ForegroundColor Yellow
        Write-Host "  Using fallback mappings" -ForegroundColor Gray
        return @{
            target_directory = ".windsurf"
            workflows = "workflows"
            rules = "rules"
            skills = "skills"
        }
    }
    
    # Read the mapping file and extract IDE-specific mappings
    # This is a simplified parser - for production, use a proper YAML library
    $content = Get-Content $MappingFile -Raw
    
    # Extract IDE section
    $idePattern = "(?ms)^\s+${IDE}:.*?(?=^\s+\w+:|$)"
    if ($content -match $idePattern) {
        $ideSection = $matches[0]
        
        # Start with fallback defaults
        $mapping = @{
            target_directory = ".windsurf"
            workflows = "workflows"
            rules = "rules"
            skills = "skills"
        }
        
        # Extract target_directory (override if found)
        if ($ideSection -match 'target_directory:\s*"([^"]+)"') {
            $mapping['target_directory'] = $matches[1]
        }
        
        # Extract mappings (override if found)
        if ($ideSection -match '(?ms)mappings:(.*?)(?=\n\s+\w+:|$)') {
            $mappingsSection = $matches[1]
            
            if ($mappingsSection -match 'workflows:.*?target:\s*"([^"]+)"') {
                $mapping['workflows'] = $matches[1]
            }
            if ($mappingsSection -match 'rules:.*?target:\s*"([^"]+)"') {
                $mapping['rules'] = $matches[1]
            }
            if ($mappingsSection -match 'skills:.*?target:\s*"([^"]+)"') {
                $mapping['skills'] = $matches[1]
            }
        }
        
        return $mapping
    }
    
    # Fallback
    return @{
        target_directory = ".windsurf"
        workflows = "workflows"
        rules = "rules"
        skills = "skills"
    }
}

# Helper function for creating symlinks or copies
function New-SafeSymlink {
    param(
        [string]$LinkPath,
        [string]$TargetPath,
        [string]$Description,
        [switch]$UseCopy,
        [switch]$DryRun
    )
    
    if (Test-Path $LinkPath) {
        Write-Host "  [SKIP] $Description already exists" -ForegroundColor Yellow
        return
    }
    
    if (-not (Test-Path $TargetPath)) {
        Write-Host "  [WARNING] Target not found: $TargetPath" -ForegroundColor Yellow
        return
    }
    
    if ($DryRun) {
        $action = if ($UseCopy) { "copy" } else { "symlink" }
        Write-Host "  [DRY RUN] Would $action`: $LinkPath → $TargetPath" -ForegroundColor Cyan
        return
    }
    
    if ($UseCopy) {
        # Copy mode - copy file or directory
        try {
            if (Test-Path $TargetPath -PathType Container) {
                Copy-Item -Path $TargetPath -Destination $LinkPath -Recurse -ErrorAction Stop
            } else {
                Copy-Item -Path $TargetPath -Destination $LinkPath -ErrorAction Stop
            }
            Write-Host "  [OK] Copied $Description" -ForegroundColor Green
        } catch {
            Write-Host "  [ERROR] Failed to copy $Description" -ForegroundColor Red
        }
    } else {
        # Symlink mode
        try {
            New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath -ErrorAction Stop | Out-Null
            Write-Host "  [OK] Created symlink for $Description" -ForegroundColor Green
        } catch {
            Write-Host "  [ERROR] Failed to create symlink for $Description" -ForegroundColor Red
            Write-Host "    Run as Administrator or use -UseCopy parameter" -ForegroundColor Yellow
        }
    }
}

# Step 1: Check for .dev-extensions
Write-Host "Step 1: Checking for .dev-extensions..." -ForegroundColor Cyan

if (-not (Test-Path ".dev-extensions")) {
    Write-Host "[ERROR] .dev-extensions not found" -ForegroundColor Red
    Write-Host "  Please add the submodule first:" -ForegroundColor Yellow
    Write-Host "  git submodule add <repo-url> .dev-extensions" -ForegroundColor Gray
    exit 1
}

Write-Host "[OK] .dev-extensions exists" -ForegroundColor Green

# Step 2: Detect or validate IDE
Write-Host ""
Write-Host "Step 2: Detecting IDE..." -ForegroundColor Cyan

$detectedIDE = $IDE

if ($IDE -eq "auto") {
    # Auto-detect IDE
    if (Test-Path ".windsurf") {
        $detectedIDE = "windsurf"
        Write-Host "[OK] Detected Windsurf" -ForegroundColor Green
    } elseif (Test-Path ".cursor") {
        $detectedIDE = "cursor"
        Write-Host "[OK] Detected Cursor" -ForegroundColor Green
    } elseif (Test-Path ".vscode") {
        $detectedIDE = "windsurf"  # Default to Windsurf for VS Code
        Write-Host "[OK] Detected VS Code - using Windsurf configuration" -ForegroundColor Green
    } else {
        $detectedIDE = "windsurf"
        Write-Host "[WARNING] No IDE detected - defaulting to Windsurf" -ForegroundColor Yellow
    }
} else {
    Write-Host "[OK] Using specified IDE: $detectedIDE" -ForegroundColor Green
}

# Step 3: Get enabled domains
Write-Host ""
Write-Host "Step 3: Determining enabled domains..." -ForegroundColor Cyan

$manifestPath = ".dev-extensions/manifest.yaml"
$configPath = $ConfigFile

$enabledDomains = Get-EnabledDomains -DomainsParam $Domains -ConfigPath $configPath -ManifestPath $manifestPath

Write-Host "[OK] Enabled domains: $($enabledDomains -join ', ')" -ForegroundColor Green

# Step 4: Load IDE mappings
Write-Host ""
Write-Host "Step 4: Loading IDE mappings..." -ForegroundColor Cyan

$mappingFile = ".dev-extensions/config/ide-mapping.yaml"
$ideMapping = Get-IDEMapping -IDE $detectedIDE -MappingFile $mappingFile

Write-Host "[OK] Target directory: $($ideMapping.target_directory)" -ForegroundColor Green
Write-Host "  workflows → $($ideMapping.workflows)" -ForegroundColor Gray
Write-Host "  rules → $($ideMapping.rules)" -ForegroundColor Gray
Write-Host "  skills → $($ideMapping.skills)" -ForegroundColor Gray

# Step 5: Create IDE directory if needed
Write-Host ""
Write-Host "Creating IDE directory..." -ForegroundColor Cyan

$ideDir = $ideMapping.target_directory
if (-not (Test-Path $ideDir)) {
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path $ideDir | Out-Null
    }
    Write-Host "[OK] Created $ideDir" -ForegroundColor Green
} else {
    Write-Host "[OK] $ideDir exists" -ForegroundColor Green
}

# Step 5: Create symlinks or copies (flatten mode)
Write-Host ""
if ($UseCopy) {
    Write-Host "Copying files (flatten mode)..." -ForegroundColor Cyan
} else {
    Write-Host "Creating symlinks (flatten mode)..." -ForegroundColor Cyan
}

foreach ($domain in $enabledDomains) {
    $domainPath = ".dev-extensions\domains\$domain"
    
    if (-not (Test-Path $domainPath)) {
        Write-Host "  [WARNING] Domain '$domain' not found - skipping" -ForegroundColor Yellow
        continue
    }
    
    # Check what this domain provides
    $contentTypes = @("workflows", "rules", "skills")
    
    foreach ($contentType in $contentTypes) {
        $sourcePath = "$domainPath\$contentType"
        
        if (-not (Test-Path $sourcePath)) {
            continue
        }
        
        # Get target from IDE mapping
        $targetName = $ideMapping[$contentType]
        if (-not $targetName) {
            continue
        }
        
        $targetDir = "$ideDir\$targetName"
        
        # Create target directory if needed
        if (-not $DryRun -and -not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        
        $fullSourcePath = "$basePath\$sourcePath"
        
        # Flatten mode: Individual file symlinks
        $filePattern = if ($contentType -eq "skills") { "*.skill.yaml" } else { "*.md" }
        $files = Get-ChildItem "$fullSourcePath\$filePattern" -ErrorAction SilentlyContinue
        
        foreach ($file in $files) {
            $linkPath = Join-Path $targetDir $file.Name
            $desc = "$($file.Name) ($domain)"
            New-SafeSymlink -LinkPath $linkPath -TargetPath $file.FullName -Description $desc -UseCopy:$UseCopy -DryRun:$DryRun
        }
        
        # Handle assets/ directory - symlink to .assets-{domain}/
        $assetsPath = Join-Path $fullSourcePath "assets"
        
        if (Test-Path $assetsPath) {
            $assetLinkPath = Join-Path $targetDir ".assets-$domain"
            $desc = ".assets-$domain/"
            New-SafeSymlink -LinkPath $assetLinkPath -TargetPath $assetsPath -Description $desc -UseCopy:$UseCopy -DryRun:$DryRun
        }
    }
}

# Summary
Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  IDE: $detectedIDE" -ForegroundColor Gray
Write-Host "  Target: $ideDir" -ForegroundColor Gray
Write-Host "  Domains: $($enabledDomains -join ', ')" -ForegroundColor Gray
Write-Host ""

if ($DryRun) {
    Write-Host "This was a DRY RUN - no changes were made" -ForegroundColor Yellow
    Write-Host "Run without -DryRun to apply changes" -ForegroundColor Gray
}
