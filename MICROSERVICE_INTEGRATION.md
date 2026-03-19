# Microservice Integration Guide

**Step-by-step guide to integrate ai-dev-extensions-core into your microservice**

This guide covers multiple integration approaches, from simple to advanced.

---

## 📋 Prerequisites

- Git installed
- Your microservice repository initialized
- Basic familiarity with symlinks or submodules

---

## 🎯 Integration Methods

### Method 1: Git Submodule (Recommended)

**Best for**: Most projects, easy version control, automatic updates

#### Step 1: Add Submodule

```bash
# Navigate to your microservice root
cd /path/to/your-microservice

# Add ai-dev-extensions-core as a submodule
git submodule add https://github.com/your-org/ai-dev-extensions-core .dev-extensions

# Initialize and update
git submodule update --init --recursive
```

#### Step 2: Create Symlinks for Windsurf

```bash
# Create .windsurf directory if it doesn't exist
mkdir -p .windsurf

# Link workflows (architecture domain example)
ln -s ../.dev-extensions/domains/architecture/workflows .windsurf/workflows

# Link templates
ln -s ../.dev-extensions/domains/architecture/templates .windsurf/templates

# Link rules
ln -s ../.dev-extensions/rules .windsurf/rules
```

**Windows (PowerShell)**:
```powershell
# Create directory
New-Item -ItemType Directory -Force -Path .windsurf

# Create symlinks (requires admin or developer mode)
New-Item -ItemType SymbolicLink -Path .windsurf\workflows -Target .dev-extensions\domains\architecture\workflows
New-Item -ItemType SymbolicLink -Path .windsurf\templates -Target .dev-extensions\domains\architecture\templates
New-Item -ItemType SymbolicLink -Path .windsurf\rules -Target .dev-extensions\rules
```

#### Step 3: Commit Changes

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
mkdir -p .windsurf/workflows .windsurf/templates .windsurf/rules

cp -r .dev-extensions/domains/architecture/workflows/* .windsurf/workflows/
cp -r .dev-extensions/domains/architecture/templates/* .windsurf/templates/
cp -r .dev-extensions/rules/* .windsurf/rules/
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
ln -s ../.dev-extensions/domains/architecture/templates .windsurf/templates
```

**Multiple Domains**:
```bash
# Architecture
ln -s ../.dev-extensions/domains/architecture/workflows .windsurf/workflows-architecture
ln -s ../.dev-extensions/domains/architecture/templates .windsurf/templates-architecture

# Code Review
ln -s ../.dev-extensions/domains/code-review/workflows .windsurf/workflows-code-review
ln -s ../.dev-extensions/domains/code-review/templates .windsurf/templates-code-review

# Security (opt-in)
ln -s ../.dev-extensions/domains/security/workflows .windsurf/workflows-security
```

**Note**: Check if Windsurf supports multiple workflow directories. If not, use single directory approach.

---

## 📁 Recommended Project Structure

After integration, your microservice should look like:

```
your-microservice/
├── .dev-extensions/          # Extension package (submodule or npm)
├── .windsurf/
│   ├── workflows/           # Symlink to .dev-extensions/domains/.../workflows
│   ├── templates/           # Symlink to .dev-extensions/domains/.../templates
│   └── rules/               # Symlink to .dev-extensions/rules
├── .arch-intake/            # Generated by architecture workflows (gitignored)
│   └── your-service-name/
├── .code-review/            # Generated by code review workflows (gitignored)
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

# If using npm method, ignore symlinks
.windsurf/workflows
.windsurf/templates
.windsurf/rules
```

**Do NOT gitignore**:
- `.dev-extensions/` (if using submodule - tracked by .gitmodules)
- `.windsurf/` directory itself (only contents if symlinks)

---

## ✅ Verification

After integration, verify setup:

### Check Symlinks

```bash
ls -la .windsurf/

# Should show:
# workflows -> ../.dev-extensions/domains/architecture/workflows
# templates -> ../.dev-extensions/domains/architecture/templates
# rules -> ../.dev-extensions/rules
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
