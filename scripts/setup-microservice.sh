#!/bin/bash
# Setup AI Dev Extensions Core in Microservice
# Run this script from your microservice root directory
#
# Prerequisites:
# - .dev-extensions submodule must already exist
# - Run from microservice root (where .git/ is)
#
# What it does:
# - Detects Windsurf IDE (simplified version - no multi-IDE support)
# - Creates symlinks for workflows and rules
# - Updates .gitignore

set -e

MICROSERVICE_PATH="${1:-.}"
DIRECT_SYMLINKS="${2:-false}"

echo "Setting up AI Dev Extensions Core..."
echo ""

# Change to microservice directory
cd "$MICROSERVICE_PATH"
BASE_PATH="$(pwd)"

echo "Working in: $BASE_PATH"
echo ""

# Check if git is available (needed for all operations)
if ! command -v git &> /dev/null; then
    echo "ERROR: Git is not installed or not in PATH!"
    exit 1
fi

# Check if this is a git repository
if [ ! -d ".git" ]; then
    echo "ERROR: Not a git repository!"
    echo "Please initialize git first: git init"
    exit 1
fi

# Step 1: Check for .dev-extensions
echo "Step 1: Checking for .dev-extensions..."
if [ ! -d ".dev-extensions" ]; then
    echo "[ERROR] .dev-extensions not found"
    echo "  Please add the submodule first:"
    echo "  git submodule add <repo-url> .dev-extensions"
    exit 1
fi

echo "[OK] .dev-extensions exists"

# Step 2: Create .windsurf directory (hardcoded - bash version is Windsurf-only)
echo ""
echo "Step 2: Creating IDE directory..."
if [ ! -d ".windsurf" ]; then
    mkdir -p .windsurf
    echo "[OK] Created .windsurf directory"
else
    echo "[OK] .windsurf directory already exists"
fi

# Step 3: Create symlinks
echo ""
echo "Creating symlinks..."

create_safe_symlink() {
    local link_path="$1"
    local target_path="$2"
    local description="$3"
    
    if [ -e "$link_path" ]; then
        echo "  [SKIP] $description already exists"
        return
    fi
    
    if [ ! -e "$target_path" ]; then
        echo "  [WARNING] Target not found: $target_path"
        return
    fi
    
    ln -s "$target_path" "$link_path"
    echo "  [OK] Created $description"
}

if [ "$DIRECT_SYMLINKS" = "true" ]; then
    # Direct symlinks (only if .windsurf is empty)
    create_safe_symlink ".windsurf/workflows" "$BASE_PATH/.dev-extensions/domains/architecture/workflows" "workflows (direct)"
    create_safe_symlink ".windsurf/templates" "$BASE_PATH/.dev-extensions/domains/architecture/templates" "templates (direct)"
    create_safe_symlink ".windsurf/rules" "$BASE_PATH/.dev-extensions/domains/_core/rules" "rules (direct)"
    create_safe_symlink ".windsurf/skills" "$BASE_PATH/.dev-extensions/domains/_core/skills" "skills (direct)"
else
    # Namespaced symlinks (merge with existing)
    create_safe_symlink ".windsurf/workflows-architecture" "$BASE_PATH/.dev-extensions/domains/architecture/workflows" "workflows-architecture"
    create_safe_symlink ".windsurf/templates-architecture" "$BASE_PATH/.dev-extensions/domains/architecture/templates" "templates-architecture"
    create_safe_symlink ".windsurf/rules-core" "$BASE_PATH/.dev-extensions/domains/_core/rules" "rules-core"
    create_safe_symlink ".windsurf/skills-core" "$BASE_PATH/.dev-extensions/domains/_core/skills" "skills-core"
fi

# Step 4: Update .gitignore
echo ""
echo "Checking .gitignore..."

GITIGNORE_CONTENT="
# AI Dev Extensions - Generated documentation
docs/architecture/

# Windsurf temporary files
.windsurf/.temp
"

if [ -f ".gitignore" ]; then
    if ! grep -q "docs/architecture/" .gitignore; then
        echo "$GITIGNORE_CONTENT" >> .gitignore
        echo "[OK] Updated .gitignore"
    else
        echo "[OK] .gitignore already contains AI Dev Extensions entries"
    fi
else
    echo "$GITIGNORE_CONTENT" > .gitignore
    echo "[OK] Created .gitignore"
fi

# Step 5: Summary
echo ""
echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "Symlinks created in .windsurf/:"
ls -l .windsurf/ | grep "^l" | awk '{print "  →", $9}'

echo ""
echo "Next steps:"
echo "1. Open this microservice in Windsurf IDE"
echo "2. Workflows should appear in workflow selector"
echo "3. Try running: /architecture-intake-create"
echo ""
echo "To commit the changes:"
echo "  git add .gitmodules .dev-extensions .windsurf .gitignore"
echo "  git commit -m 'chore: integrate ai-dev-extensions-core'"
echo ""
