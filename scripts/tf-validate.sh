#!/bin/bash
# tf-validate.sh - Validate Terraform configurations

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST_FILE="$ROOT_DIR/terraform/validation-manifest.txt"
TARGET=${1:-all}

validate_target() {
    local target=$1
    local dir="$ROOT_DIR/terraform/$target"

    echo ""
    echo "Validating terraform/$target..."
    echo "--------------------------------"

    cd "$dir"

    # Initialize without backend
    terraform init -backend=false -input=false > /dev/null 2>&1 || {
        echo "  Init failed, trying with upgrade..."
        terraform init -backend=false -input=false -upgrade > /dev/null 2>&1
    }

    # Validate
    if terraform validate; then
        echo "  Validation: PASSED"
    else
        echo "  Validation: FAILED"
        return 1
    fi
    
    # Check formatting
    if terraform fmt -check -recursive > /dev/null 2>&1; then
        echo "  Formatting: PASSED"
    else
        echo "  Formatting: FAILED (run: terraform fmt -recursive)"
        return 1
    fi
    
    cd "$ROOT_DIR"
}

echo "=========================================="
echo "Terraform Validation"
echo "=========================================="

if [[ ! -f "$MANIFEST_FILE" ]]; then
    echo "Validation manifest not found: $MANIFEST_FILE"
    exit 1
fi

read_manifest() {
    grep -v '^\s*#' "$MANIFEST_FILE" | sed '/^\s*$/d'
}

if [ "$TARGET" = "all" ]; then
    FAILED=0

    while IFS= read -r entry; do
        if ! validate_target "$entry"; then
            FAILED=1
        fi
    done < <(read_manifest)

    echo ""
    echo "=========================================="
    if [ $FAILED -eq 0 ]; then
        echo "All validations PASSED!"
    else
        echo "Some validations FAILED!"
        exit 1
    fi
else
    validate_target "$TARGET"
    echo ""
    echo "Validation complete!"
fi
