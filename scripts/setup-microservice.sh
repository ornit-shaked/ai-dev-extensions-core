#!/bin/bash
# Setup AI Dev Extensions Core in Microservice
# Run this script from your microservice root directory
#
# Behavior:
# - If .dev-extensions doesn't exist: Adds as git submodule
# - If .dev-extensions exists: Updates to latest version from remote
# - Always creates/updates symlinks and .gitignore
#
# To force re-initialization (e.g., if submodule is broken):
#   rm -rf .dev-extensions
#   Then run this script again

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

# Step 1: Add or update submodule
# Strategy: Always run 'git submodule update' to ensure latest version
if [ ! -d ".dev-extensions" ]; then
    # Submodule doesn't exist - add it
    echo "Adding ai-dev-extensions-core as git submodule..."
    
    if git submodule add https://github.com/ornit-shaked/ai-dev-extensions-core .dev-extensions &> /dev/null; then
        echo "✓ Added .dev-extensions submodule"
    else
        echo "ERROR: Failed to add submodule!"
        echo "If submodule already exists in .gitmodules, remove it first or delete .dev-extensions/"
        exit 1
    fi
fi

# Always update submodule to ensure latest version
# This runs whether submodule was just added or already existed
echo "Updating submodule to latest version..."
if git submodule update --init --recursive --remote &> /dev/null; then
    echo "✓ Submodule up to date"
else
    echo "WARNING: Submodule update had issues, but continuing..."
fi

# Step 2: Create .windsurf directory
if [ ! -d ".windsurf" ]; then
    mkdir -p .windsurf
    echo "✓ Created .windsurf directory"
else
    echo "✓ .windsurf directory already exists"
fi

# Step 3: Create symlinks
echo ""
echo "Creating symlinks..."

create_safe_symlink() {
    local link_path="$1"
    local target_path="$2"
    local description="$3"
    
    if [ -e "$link_path" ]; then
        echo "  ⚠ $description already exists - skipping"
        return
    fi
    
    if [ ! -e "$target_path" ]; then
        echo "  ⚠ Target not found: $target_path - skipping"
        return
    fi
    
    ln -s "$target_path" "$link_path"
    echo "  ✓ Created $description"
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
        echo "✓ Updated .gitignore"
    else
        echo "✓ .gitignore already contains AI Dev Extensions entries"
    fi
else
    echo "$GITIGNORE_CONTENT" > .gitignore
    echo "✓ Created .gitignore"
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
