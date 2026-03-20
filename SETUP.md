# Setup Guide

**Step-by-step guide to integrate ai-dev-extensions-core into your microservice**

This guide covers multiple integration approaches, from automated setup to manual configuration.

---

## 📋 Prerequisites

- Git installed
- Your microservice repository initialized
- Basic familiarity with symlinks or submodules

---

## 🎯 Integration Methods

### Method 1: Git Submodule (Recommended)

**Best for**: Most projects, easy version control, automatic updates

#### Automated Setup

**For Private Repositories:**
```bash
# Step 1: Add submodule (requires authentication)
git submodule add https://github.com/ornit-shaked/ai-dev-extensions-core .dev-extensions
git submodule update --init --recursive

# Step 2: Run setup script
.\.dev-extensions\scripts\setup-microservice.ps1  # Windows
bash .dev-extensions/scripts/setup-microservice.sh  # Linux/Mac
```

**The script automatically:**
- ✅ Updates submodule to latest version
- ✅ Auto-detects your IDE (Windsurf, Cursor, VS Code)
- ✅ Reads domain configuration from manifest.yaml
- ✅ Creates appropriate symlinks based on IDE mappings
- ✅ Updates .gitignore
- ✅ Shows summary of actions taken

**Script Options:**

```powershell
# Auto-detect IDE, use default domains
.\setup-microservice.ps1

# Specify IDE explicitly
.\setup-microservice.ps1 -IDE windsurf
.\setup-microservice.ps1 -IDE cursor

# Select specific domains
.\setup-microservice.ps1 -Domains "_core,architecture"
.\setup-microservice.ps1 -Domains "all"

# Combine options
.\setup-microservice.ps1 -IDE cursor -Domains "_core"

# Dry run (see what would happen)
.\setup-microservice.ps1 -DryRun
```

**Important Notes:**
- For **IntelliJ/JetBrains IDEs**: Script cannot auto-detect AI plugins. Use `-IDE intellij` and see manual setup instructions
- For **Windsurf**: Auto-detection checks both `.windsurf/` and `.vscode/` (Windsurf extends VS Code)
- **Workflow assets**: Workflows may contain `templates/` subdirectory with workflow-specific files
- **Merge strategy**: Default is "namespace" (e.g., `workflows-architecture`, `rules-core`). Use `-DirectSymlinks` for direct mode

See script header comments for full details: `scripts/setup-microservice.ps1`

#### Alternative: Fully Manual Setup

**Important**: Run these commands from your microservice root directory (where .dev-extensions/ is located)

**Linux/Mac:**
```bash
# Navigate to your microservice root
cd /path/to/your-microservice

# Create .windsurf directory if it doesn't exist
mkdir -p .windsurf

# Add architecture workflows (merge with existing)
# Path is relative to .windsurf/ location: ../.dev-extensions means "go up one level, then into .dev-extensions"
# Note: Workflows include embedded templates/ subdirectory
ln -s ../.dev-extensions/domains/architecture/workflows .windsurf/workflows-architecture

# Add core rules
ln -s ../.dev-extensions/domains/_core/rules .windsurf/rules-core

# Add core skills
ln -s ../.dev-extensions/domains/_core/skills .windsurf/skills-core

# Verify symlinks
ls -la .windsurf/
```

**Windows (PowerShell)** - Run as Administrator or enable Developer Mode:
```powershell
# Navigate to your microservice root
cd C:\path\to\your-microservice

# Create .windsurf directory if it doesn't exist
New-Item -ItemType Directory -Force -Path .windsurf

# Add architecture workflows (merge with existing)
# Use absolute paths for Windows reliability
# Note: Workflows include embedded templates/ subdirectory
$basePath = (Get-Location).Path
New-Item -ItemType SymbolicLink -Path .windsurf\workflows-architecture -Target "$basePath\.dev-extensions\domains\architecture\workflows"

# Add core rules
New-Item -ItemType SymbolicLink -Path .windsurf\rules-core -Target "$basePath\.dev-extensions\domains\_core\rules"

# Add core skills
New-Item -ItemType SymbolicLink -Path .windsurf\skills-core -Target "$basePath\.dev-extensions\domains\_core\skills"

# Verify symlinks
Get-ChildItem .windsurf\ | Select-Object Name, Target
```

**Alternative: Direct symlinks (if .windsurf/ is empty or you want to replace)**
```powershell
# Only if .windsurf/ is empty - create direct symlinks
if (-not (Test-Path .windsurf\workflows)) {
  New-Item -ItemType SymbolicLink -Path .windsurf\workflows -Target .dev-extensions\domains\architecture\workflows
  New-Item -ItemType SymbolicLink -Path .windsurf\rules -Target .dev-extensions\domains\_core\rules
  New-Item -ItemType SymbolicLink -Path .windsurf\skills -Target .dev-extensions\domains\_core\skills
}
```

**✅ Benefits**:
- All 3 content types included: workflows (with templates/), rules, skills
- Existing content remains untouched
- Package content added with clear naming (`-architecture`, `-core`)
- No backup needed
- Easy to identify package vs. project content

#### Step 3: (Optional) Configure Domain Selection

Create `.dev-extensions.config.yaml` in your microservice root to customize which domains are loaded:

```yaml
# .dev-extensions.config.yaml
domains:
  enabled:
    - _core
    - architecture
    # - security  # Uncomment when available

ide: windsurf  # or cursor, vscode, intellij
```

This file is optional. If not present, the script uses defaults from `manifest.yaml`.

#### Step 4: Commit Changes

```bash
git add .gitmodules .dev-extensions .windsurf
git commit -m "chore: integrate ai-dev-extensions-core"
git push
```

#### Step 4: Team Members Setup

When team members clone the repository:

```bash
git clone <your-repo-url>
cd <your-repo>

# Initialize submodules
git submodule update --init --recursive
```

#### Updating Extensions

```bash
# Update to latest version
git submodule update --remote .dev-extensions

# Or update to specific version
cd .dev-extensions
git checkout v1.0.0
cd ..
git add .dev-extensions
git commit -m "chore: update extensions to v1.0.0"
```

---

### Method 2: npm Package (When Available)

**Best for**: Node.js projects, automated dependency management

#### Step 1: Install Package

```bash
npm install -D @your-org/ai-dev-extensions-core
```

#### Step 2: Create Symlinks

```bash
# Extensions are in node_modules
mkdir -p .windsurf

ln -s ../node_modules/@your-org/ai-dev-extensions-core/domains/architecture/workflows .windsurf/workflows
ln -s ../node_modules/@your-org/ai-dev-extensions-core/domains/architecture/templates .windsurf/templates
ln -s ../node_modules/@your-org/ai-dev-extensions-core/rules .windsurf/rules
```

#### Step 3: Add to .gitignore

```bash
# .gitignore
node_modules/
.windsurf/workflows
.windsurf/templates
.windsurf/rules
```

**Note**: Symlinks are gitignored, so each developer runs `npm install` to get extensions.

---

### Method 3: Manual Copy (Simple but Static)

**Best for**: Quick testing, one-time setup

#### Step 1: Download Release

```bash
curl -L https://github.com/your-org/ai-dev-extensions-core/archive/v0.1.0.tar.gz | tar xz
mv ai-dev-extensions-core-0.1.0 .dev-extensions
```

#### Step 2: Copy Files

```bash
mkdir -p .windsurf/workflows .windsurf/rules .windsurf/skills

# Copy individual workflow files
cp .dev-extensions/domains/architecture/workflows/*.md .windsurf/workflows/

# Copy workflow assets directory
cp -r .dev-extensions/domains/architecture/workflows/assets .windsurf/workflows/.assets-architecture

# Copy rules and skills
cp .dev-extensions/domains/_core/rules/*.md .windsurf/rules/
cp .dev-extensions/domains/_core/skills/*.skill.yaml .windsurf/skills/
```

#### Step 3: Commit

```bash
git add .windsurf/
git commit -m "chore: add ai-dev-extensions workflows"
```

**Downside**: No automatic updates, manual copy needed for new versions.

---

## 🔧 Configuration

### Choosing Which Domains to Enable

**Architecture Only** (most common):
```bash
ln -s ../.dev-extensions/domains/architecture/workflows .windsurf/workflows
```

**Multiple Domains**:
```bash
# Architecture
ln -s ../.dev-extensions/domains/architecture/workflows .windsurf/workflows-architecture

# Code Review
ln -s ../.dev-extensions/domains/code-review/workflows .windsurf/workflows-code-review

# Security (opt-in)
ln -s ../.dev-extensions/domains/security/workflows .windsurf/workflows-security
```

**Note**: Check if Windsurf supports multiple workflow directories. If not, use single directory approach.

---

## 📁 Recommended Project Structure

After integration, your microservice should look like:

```
your-microservice/
├── .dev-extensions/          # Extension package (submodule)
├── .windsurf/
│   ├── workflows/           # Individual workflow files (flatten mode)
│   │   ├── architecture-intake-create.md  # Symlink to package file
│   │   ├── architecture-intake-resolve.md
│   │   └── .assets-architecture/          # Symlink to package assets/
│   ├── rules/              # Individual rule files
│   └── skills/             # Individual skill files
├── .arch-intake/            # Generated by architecture workflows (gitignored)
│   └── your-service-name/
├── src/                     # Your service code
├── .gitignore
├── .gitmodules              # If using submodules
└── README.md
```

---

## 🚫 What to .gitignore

Add to your `.gitignore`:

```gitignore
# AI-generated outputs (ephemeral)
.arch-intake/
.code-review/
.security/
.auto-prompt-hub/

# If you copy files instead of symlinks, ignore them
.windsurf/workflows-*/
.windsurf/rules-*/
.windsurf/skills-*/
```

**Do NOT gitignore**:
- `.dev-extensions/` (if using submodule - tracked by .gitmodules)
- `.windsurf/` directory itself (only contents if symlinks)

---

## ✅ Verification

After integration, verify setup:

### Check Symlinks

```bash
ls -la .windsurf/workflows/

# Should show (flatten mode):
# architecture-intake-create.md -> ../../.dev-extensions/domains/architecture/workflows/architecture-intake-create.md
# architecture-intake-resolve.md -> ../../.dev-extensions/domains/architecture/workflows/architecture-intake-resolve.md
# .assets-architecture/ -> ../../.dev-extensions/domains/architecture/workflows/assets/
```

### Test in Windsurf

1. Open your microservice in Windsurf
2. Type `/` in chat to see slash commands
3. Verify workflows appear (e.g., `/architecture-intake-create`)
4. Run a workflow to test

---

## 🔄 Updating Extensions

### Git Submodule Method

```bash
# Update to latest
cd .dev-extensions
git pull origin main
cd ..
git add .dev-extensions
git commit -m "chore: update extensions"

# Or update to specific version
cd .dev-extensions
git fetch --tags
git checkout v1.1.0
cd ..
git add .dev-extensions
git commit -m "chore: update extensions to v1.1.0"
```

### npm Method

```bash
# Update to latest
npm update @your-org/ai-dev-extensions-core

# Or specific version
npm install -D @your-org/ai-dev-extensions-core@1.1.0
```

---

## 🐛 Troubleshooting

### Symlinks Not Working on Windows

**Issue**: Symlinks require admin privileges

**Solution 1**: Enable Developer Mode
1. Settings → Update & Security → For Developers
2. Enable "Developer Mode"
3. Retry symlink creation

**Solution 2**: Use Directory Junctions (no admin needed)
```powershell
mklink /J .windsurf\workflows .dev-extensions\domains\architecture\workflows
```

**Solution 3**: Use manual copy method instead

---

### Workflows Not Appearing in Windsurf

**Check**:
1. Symlinks are correct: `ls -la .windsurf/workflows`
2. Workflow files have frontmatter (YAML header)
3. Restart Windsurf
4. Check Windsurf version compatibility (see manifest.yaml)

---

### Submodule Not Pulling Updates

```bash
# Ensure submodule is tracking a branch
git config -f .gitmodules submodule..dev-extensions.branch main

# Update
git submodule update --remote

# Verify
cd .dev-extensions
git status  # Should be on main branch
```

---

## 🏢 Team Workflows

### For New Team Members

**Initial Setup** (after cloning repo):
```bash
git clone <repo-url>
cd <repo>
git submodule update --init --recursive
```

### For Continuous Integration (CI/CD)

Add to your CI script:
```yaml
# .github/workflows/ci.yml
steps:
  - uses: actions/checkout@v3
    with:
      submodules: recursive  # Important!
  
  - name: Verify extensions
    run: test -d .dev-extensions
```

---

## 📊 Migration Between Methods

### From Manual Copy → Submodule

```bash
# Remove copied files
rm -rf .windsurf/workflows .windsurf/templates .windsurf/rules

# Add submodule
git submodule add https://github.com/your-org/ai-dev-extensions-core .dev-extensions

# Create symlinks (see Method 1)
ln -s ../.dev-extensions/domains/architecture/workflows .windsurf/workflows
# ... etc
```

### From Submodule → npm

```bash
# Remove submodule
git submodule deinit .dev-extensions
git rm .dev-extensions
rm -rf .git/modules/.dev-extensions

# Install npm package
npm install -D @your-org/ai-dev-extensions-core

# Update symlinks to point to node_modules
ln -sf ../node_modules/@your-org/ai-dev-extensions-core/domains/architecture/workflows .windsurf/workflows
```

---

## 🎓 Advanced: Custom Domain Selection Script

Create `scripts/setup-extensions.sh`:

```bash
#!/bin/bash
# Setup script for ai-dev-extensions-core integration

EXTENSION_DIR=".dev-extensions"
WINDSURF_DIR=".windsurf"

# Prompt for domains
echo "Select domains to enable:"
echo "1. Architecture (recommended)"
echo "2. Code Review"
echo "3. Security"
echo "4. All"
read -p "Enter choices (comma-separated, e.g., 1,2): " choices

mkdir -p "$WINDSURF_DIR"

# Parse choices
if [[ "$choices" == *"1"* ]] || [[ "$choices" == *"4"* ]]; then
    ln -sf "../$EXTENSION_DIR/domains/architecture/workflows" "$WINDSURF_DIR/workflows-arch"
    echo "✓ Enabled architecture domain"
fi

if [[ "$choices" == *"2"* ]] || [[ "$choices" == *"4"* ]]; then
    ln -sf "../$EXTENSION_DIR/domains/code-review/workflows" "$WINDSURF_DIR/workflows-review"
    echo "✓ Enabled code-review domain"
fi

if [[ "$choices" == *"3"* ]] || [[ "$choices" == *"4"* ]]; then
    ln -sf "../$EXTENSION_DIR/domains/security/workflows" "$WINDSURF_DIR/workflows-security"
    echo "✓ Enabled security domain"
fi

# Always link rules
ln -sf "../$EXTENSION_DIR/rules" "$WINDSURF_DIR/rules"

echo "✅ Setup complete!"
```

Usage:
```bash
chmod +x scripts/setup-extensions.sh
./scripts/setup-extensions.sh
```

---

## 📞 Support

- **Questions**: Open an issue on GitHub
- **Documentation**: See main [README.md](./README.md)
- **Agent Guide**: [AGENT_GUIDE.md](./AGENT_GUIDE.md)

---

**Integration complete! Your microservice is now AI-workflow enabled.** 🚀
