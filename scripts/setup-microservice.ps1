# Setup AI Dev Extensions Core in Microservice
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
        Write-Host "⚠ IDE mapping file not found: $MappingFile" -ForegroundColor Yellow
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
        
        $mapping = @{}
        
        # Extract target_directory
        if ($ideSection -match 'target_directory:\s*"([^"]+)"') {
            $mapping['target_directory'] = $matches[1]
        }
        
        # Extract mappings
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

# Step 1: Check for .dev-extensions
Write-Host "Step 1: Checking for .dev-extensions..." -ForegroundColor Cyan

if (-not (Test-Path ".dev-extensions")) {
    Write-Host "✗ .dev-extensions not found" -ForegroundColor Red
    Write-Host "  Please add the submodule first:" -ForegroundColor Yellow
    Write-Host "  git submodule add <repo-url> .dev-extensions" -ForegroundColor Gray
    exit 1
}

Write-Host "✓ .dev-extensions exists" -ForegroundColor Green

# Step 2: Detect or validate IDE
Write-Host ""
Write-Host "Step 2: Detecting IDE..." -ForegroundColor Cyan

$detectedIDE = $IDE

if ($IDE -eq "auto") {
    # Auto-detect IDE
    if (Test-Path ".windsurf") {
        $detectedIDE = "windsurf"
        Write-Host "✓ Detected Windsurf" -ForegroundColor Green
    } elseif (Test-Path ".cursor") {
        $detectedIDE = "cursor"
        Write-Host "✓ Detected Cursor" -ForegroundColor Green
    } elseif (Test-Path ".vscode") {
        $detectedIDE = "windsurf"  # Default to Windsurf for VS Code
        Write-Host "✓ Detected VS Code - using Windsurf configuration" -ForegroundColor Green
    } else {
        $detectedIDE = "windsurf"
        Write-Host "⚠ No IDE detected - defaulting to Windsurf" -ForegroundColor Yellow
    }
} else {
    Write-Host "✓ Using specified IDE: $detectedIDE" -ForegroundColor Green
}

# Step 3: Get enabled domains
Write-Host ""
Write-Host "Step 3: Determining enabled domains..." -ForegroundColor Cyan

$manifestPath = ".dev-extensions/manifest.yaml"
$configPath = $ConfigFile

$enabledDomains = Get-EnabledDomains -DomainsParam $Domains -ConfigPath $configPath -ManifestPath $manifestPath

Write-Host "✓ Enabled domains: $($enabledDomains -join ', ')" -ForegroundColor Green

# Step 4: Load IDE mappings
Write-Host ""
Write-Host "Step 4: Loading IDE mappings..." -ForegroundColor Cyan

$mappingFile = ".dev-extensions/config/ide-mapping.yaml"
$ideMapping = Get-IDEMapping -IDE $detectedIDE -MappingFile $mappingFile

Write-Host "✓ Target directory: $($ideMapping.target_directory)" -ForegroundColor Green
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
    Write-Host "✓ Created $ideDir" -ForegroundColor Green
} else {
    Write-Host "✓ $ideDir exists" -ForegroundColor Green
}

# Step 5: Create symlinks (flatten mode)
Write-Host ""
Write-Host "Creating symlinks (flatten mode)..." -ForegroundColor Cyan

foreach ($domain in $enabledDomains) {
    $domainPath = ".dev-extensions\domains\$domain"
    
    if (-not (Test-Path $domainPath)) {
        Write-Host "  ⚠ Domain '$domain' not found - skipping" -ForegroundColor Yellow
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
            New-SafeSymlink -LinkPath $linkPath -TargetPath $file.FullName -Description $desc -DryRun:$DryRun
        }
        
        # Handle assets/ directory - symlink to .assets-{domain}/
        $assetsPath = Join-Path $fullSourcePath "assets"
        
        if (Test-Path $assetsPath) {
            $assetLinkPath = Join-Path $targetDir ".assets-$domain"
            $desc = ".assets-$domain/"
            New-SafeSymlink -LinkPath $assetLinkPath -TargetPath $assetsPath -Description $desc -DryRun:$DryRun
        }
    }
}

# Step 6: Update .gitignore
Write-Host ""
Write-Host "Checking .gitignore..." -ForegroundColor Cyan

$gitignoreContent = @"

# AI Dev Extensions
docs/architecture/
$ideDir/.temp
"@

$gitignorePath = ".gitignore"
$needsUpdate = $false

if (Test-Path $gitignorePath) {
    $existingContent = Get-Content $gitignorePath -Raw
    if ($existingContent -notmatch "AI Dev Extensions") {
        $needsUpdate = $true
    }
} else {
    $needsUpdate = $true
}

if ($needsUpdate) {
    if (-not $DryRun) {
        Add-Content -Path $gitignorePath -Value $gitignoreContent
    }
    Write-Host "✓ Updated .gitignore" -ForegroundColor Green
} else {
    Write-Host "✓ .gitignore already configured" -ForegroundColor Green
}

# Helper function for creating symlinks
function New-SafeSymlink {
    param(
        [string]$LinkPath,
        [string]$TargetPath,
        [string]$Description,
        [switch]$DryRun
    )
    
    if (Test-Path $LinkPath) {
        Write-Host "  ⚠ $Description already exists - skipping" -ForegroundColor Yellow
        return
    }
    
    if (-not (Test-Path $TargetPath)) {
        Write-Host "  ⚠ Target not found: $TargetPath - skipping" -ForegroundColor Yellow
        return
    }
    
    if ($DryRun) {
        Write-Host "  [DRY RUN] Would create: $LinkPath → $TargetPath" -ForegroundColor Cyan
        return
    }
    
    try {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath -ErrorAction Stop | Out-Null
        Write-Host "  ✓ Created $Description" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Failed to create $Description" -ForegroundColor Red
        Write-Host "    Try running PowerShell as Administrator" -ForegroundColor Yellow
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
