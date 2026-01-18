#!/bin/bash
# tf-validate.sh - Validate Terraform configurations

set -e

ACCOUNT=${1:-all}
ROOT_DIR="$(dirname "$0")/.."

validate_account() {
    local account=$1
    local dir="$ROOT_DIR/terraform/$account"
    
    if [[ ! -f "$dir/main.tf" ]]; then
        echo "Skipping $account (no main.tf found)"
        return 0
    fi
    
    echo ""
    echo "Validating terraform/$account..."
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

if [ "$ACCOUNT" = "all" ]; then
    FAILED=0
    
    # Validate account directories
    for dir in terraform/*/; do
        if [[ -d "$dir" && "$dir" != "terraform/modules/" ]]; then
            account=$(basename "$dir")
            if ! validate_account "$account"; then
                FAILED=1
            fi
        fi
    done
    
    # Validate modules
    if [[ -d "terraform/modules" ]]; then
        for module_dir in terraform/modules/*/; do
            if [[ -d "$module_dir" ]]; then
                module=$(basename "$module_dir")
                if [[ -f "$module_dir/main.tf" ]]; then
                    if ! validate_account "modules/$module"; then
                        FAILED=1
                    fi
                fi
            fi
        done
    fi
    
    echo ""
    echo "=========================================="
    if [ $FAILED -eq 0 ]; then
        echo "All validations PASSED!"
    else
        echo "Some validations FAILED!"
        exit 1
    fi
else
    validate_account "$ACCOUNT"
    echo ""
    echo "Validation complete!"
fi
