#!/bin/bash
# tf-plan.sh - Run Terraform plan for a specific account

set -e

ACCOUNT=${1:-}
ROOT_DIR="$(dirname "$0")/.."

if [[ -z "$ACCOUNT" ]]; then
    echo "Usage: ./scripts/tf-plan.sh <account>"
    echo ""
    echo "Available accounts:"
    for dir in terraform/*/; do
        if [[ -d "$dir" && "$dir" != "terraform/modules/" ]]; then
            account=$(basename "$dir")
            if [[ -f "$dir/main.tf" ]]; then
                echo "  - $account"
            fi
        fi
    done
    exit 1
fi

DIR="$ROOT_DIR/terraform/$ACCOUNT"

if [[ ! -d "$DIR" ]]; then
    echo "Error: Directory terraform/$ACCOUNT does not exist"
    exit 1
fi

if [[ ! -f "$DIR/main.tf" ]]; then
    echo "Error: No main.tf found in terraform/$ACCOUNT"
    exit 1
fi

echo "=========================================="
echo "Terraform Plan: $ACCOUNT"
echo "=========================================="
echo ""

cd "$DIR"

# Initialize
echo "Initializing..."
terraform init

echo ""
echo "Planning..."
terraform plan

echo ""
echo "=========================================="
echo "Plan complete for $ACCOUNT"
echo ""
echo "To apply: cd terraform/$ACCOUNT && terraform apply"
