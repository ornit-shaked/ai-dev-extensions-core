#!/bin/bash
# Setup AI Dev Extensions Core in Microservice
# Run this script from your microservice root directory
#
# USAGE:
#   bash setup-microservice.sh                    # Default: Windsurf
#   bash setup-microservice.sh cursor             # For Cursor IDE
#   bash setup-microservice.sh vscode             # For VS Code
#
# WHAT IT DOES:
#   - Validates .dev-extensions submodule exists
#   - Configures IDE (Windsurf/Cursor/VS Code)
#   - Creates symlinks or copies (flatten mode)
#   - Loads enabled domains from config

set -e

# Parameters
MICROSERVICE_PATH="${1:-.}"
IDE="${2:-windsurf}"  # windsurf, cursor, or vscode
USE_COPY=false

echo "AI Dev Extensions Setup"
echo ""

# Change to microservice directory
cd "$MICROSERVICE_PATH"
BASE_PATH="$(pwd)"
echo "Working in: $BASE_PATH"
echo ""

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "ERROR: Git is not installed or not in PATH!"
    exit 1
fi

# Check if this is a git repository
if [ ! -d ".git" ]; then
    echo "ERROR: Not a git repository!"
    echo "This script must be run from the root of a git repository."
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

# Step 2: Validate IDE
echo ""
echo "Step 2: Configuring for IDE..."
IDE=$(echo "$IDE" | tr '[:upper:]' '[:lower:]')

case "$IDE" in
    windsurf|cursor|vscode)
        ;;
    *)
        echo "[WARNING] Unknown IDE '$IDE' - defaulting to Windsurf"
        IDE="windsurf"
        ;;
esac

echo "[OK] Using IDE: $IDE"

# Step 3: Get enabled domains
echo ""
echo "Step 3: Determining enabled domains..."

MANIFEST_PATH=".dev-extensions/manifest.yaml"
ENABLED_DOMAINS=()

# Read default domains from manifest
if [ -f "$MANIFEST_PATH" ]; then
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*(.+)$ ]]; then
            domain="${BASH_REMATCH[1]}"
            domain=$(echo "$domain" | tr -d '"' | tr -d "'")
            ENABLED_DOMAINS+=("$domain")
        fi
    done < <(sed -n '/^enabled_domains:/,/^[^ ]/p' "$MANIFEST_PATH" | grep '  -')
fi

if [ ${#ENABLED_DOMAINS[@]} -eq 0 ]; then
    ENABLED_DOMAINS=("_core" "architecture")
fi

echo "[OK] Enabled domains: ${ENABLED_DOMAINS[*]}"

# Step 4: Load IDE mapping
echo ""
echo "Step 4: Loading IDE mappings..."

IDE_MAPPING_FILE=".dev-extensions/config/ide-mapping.yaml"
TARGET_DIR=".windsurf"
WORKFLOWS_DIR="workflows"
RULES_DIR="rules"
SKILLS_DIR="skills"

# Parse IDE mapping (simplified YAML parser)
if [ -f "$IDE_MAPPING_FILE" ]; then
    in_ide_section=false
    while IFS= read -r line; do
        # Check if we entered the IDE section
        if [[ "$line" =~ ^[[:space:]]*${IDE}:[[:space:]]*$ ]]; then
            in_ide_section=true
            continue
        fi
        
        # Exit section if we hit another top-level key
        if [[ "$line" =~ ^[[:space:]]*[a-z]+:[[:space:]]*$ ]] && [ "$in_ide_section" = true ]; then
            in_ide_section=false
        fi
        
        # Parse values within section
        if [ "$in_ide_section" = true ]; then
            if [[ "$line" =~ target_directory:[[:space:]]*\"(.+)\" ]]; then
                TARGET_DIR="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ workflows:.*target:[[:space:]]*\"(.+)\" ]]; then
                WORKFLOWS_DIR="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ rules:.*target:[[:space:]]*\"(.+)\" ]]; then
                RULES_DIR="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ skills:.*target:[[:space:]]*\"(.+)\" ]]; then
                SKILLS_DIR="${BASH_REMATCH[1]}"
            fi
        fi
    done < "$IDE_MAPPING_FILE"
fi

echo "[OK] Target directory: $TARGET_DIR"
echo "  workflows → $WORKFLOWS_DIR"
echo "  rules → $RULES_DIR"
echo "  skills → $SKILLS_DIR"

# Step 5: Create IDE directory
echo ""
echo "Creating IDE directory..."
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    echo "[OK] Created $TARGET_DIR"
else
    echo "[OK] $TARGET_DIR exists"
fi

# Helper function for creating symlinks or copies
create_safe_link() {
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
    
    if [ "$USE_COPY" = true ]; then
        if [ -d "$target_path" ]; then
            cp -r "$target_path" "$link_path"
        else
            cp "$target_path" "$link_path"
        fi
        echo "  [OK] Copied $description"
    else
        ln -s "$(cd "$(dirname "$target_path")" && pwd)/$(basename "$target_path")" "$link_path"
        echo "  [OK] Created symlink for $description"
    fi
}

# Step 6: Create symlinks/copies (flatten mode)
echo ""
if [ "$USE_COPY" = true ]; then
    echo "Copying files (flatten mode)..."
else
    echo "Creating symlinks (flatten mode)..."
fi

for domain in "${ENABLED_DOMAINS[@]}"; do
    domain_path=".dev-extensions/domains/$domain"
    
    if [ ! -d "$domain_path" ]; then
        echo "  [WARNING] Domain '$domain' not found - skipping"
        continue
    fi
    
    # Process each content type
    for content_type in "workflows" "rules" "skills"; do
        source_path="$domain_path/$content_type"
        
        if [ ! -d "$source_path" ]; then
            continue
        fi
        
        # Get target directory based on content type
        case "$content_type" in
            workflows) target_subdir="$WORKFLOWS_DIR" ;;
            rules) target_subdir="$RULES_DIR" ;;
            skills) target_subdir="$SKILLS_DIR" ;;
        esac
        
        target_dir="$TARGET_DIR/$target_subdir"
        mkdir -p "$target_dir"
        
        # Flatten mode: Individual file symlinks/copies
        if [ "$content_type" = "skills" ]; then
            file_pattern="*.skill.yaml"
        else
            file_pattern="*.md"
        fi
        
        for file in "$source_path"/$file_pattern 2>/dev/null; do
            [ -e "$file" ] || continue
            filename=$(basename "$file")
            link_path="$target_dir/$filename"
            desc="$filename ($domain)"
            create_safe_link "$link_path" "$file" "$desc"
        done
        
        # Handle assets/ directory
        assets_path="$source_path/assets"
        if [ -d "$assets_path" ]; then
            asset_link_path="$target_dir/.assets-$domain"
            desc=".assets-$domain/"
            create_safe_link "$asset_link_path" "$assets_path" "$desc"
        fi
    done
done

# Summary
echo ""
echo "Setup complete!"
echo ""
echo "Summary:"
echo "  IDE: $IDE"
echo "  Target: $TARGET_DIR"
echo "  Domains: ${ENABLED_DOMAINS[*]}"
echo ""
