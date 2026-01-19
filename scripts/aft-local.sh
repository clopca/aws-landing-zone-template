#!/usr/bin/env bash
#
# aft-local.sh - Local testing script for AFT customizations
#
# This script allows you to test AFT account customizations locally before
# deploying them through the AFT pipeline. It mocks SSM parameters and runs
# Terraform commands against your customization code.
#
# Usage:
#   ./scripts/aft-local.sh --account-id 123456789012 --customization global
#   ./scripts/aft-local.sh --account-id 123456789012 --customization PROD-WORKLOAD --region us-west-2
#   ./scripts/aft-local.sh --help
#

set -euo pipefail

# Script directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

#######################################
# Print usage information
#######################################
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Local testing script for AFT account customizations.

OPTIONS:
    --account-id ID       Target AWS account ID (required)
    --customization NAME  Customization to run: global, PROD-WORKLOAD, etc. (required)
    --region REGION       AWS region (default: us-east-1)
    --dry-run             Validate only, don't apply changes
    --auto-approve        Skip confirmation prompts for apply
    --help                Show this help message

EXAMPLES:
    # Test global customization
    $(basename "$0") --account-id 123456789012 --customization global

    # Test account-specific customization with dry-run
    $(basename "$0") --account-id 123456789012 --customization PROD-WORKLOAD --dry-run

    # Test in different region with auto-approve
    $(basename "$0") --account-id 123456789012 --customization global --region us-west-2 --auto-approve

CUSTOMIZATION TYPES:
    - global: Applied to all AFT-managed accounts
    - PROD-WORKLOAD: Account-specific customization (example)
    - DEV-WORKLOAD: Account-specific customization (example)

DIRECTORY STRUCTURE:
    terraform/aft/
    ├── aft-global-customizations/     # Global customizations
    │   └── terraform/
    └── aft-account-customizations/    # Account-specific customizations
        ├── PROD-WORKLOAD/
        │   └── terraform/
        └── DEV-WORKLOAD/
            └── terraform/

EOF
    exit 0
}

#######################################
# Print colored log messages
# Arguments:
#   $1 - Log level (INFO, WARN, ERROR, SUCCESS)
#   $2+ - Message
#######################################
log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }

ACCOUNT_ID=""
CUSTOMIZATION=""
REGION="us-east-1"
DRY_RUN=false
AUTO_APPROVE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --account-id)
            ACCOUNT_ID="$2"
            shift 2
            ;;
        --customization)
            CUSTOMIZATION="$2"
            shift 2
            ;;
        --region)
            REGION="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --auto-approve)
            AUTO_APPROVE=true
            shift
            ;;
        --help|-h)
            usage
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            ;;
    esac
done

if [[ -z "$ACCOUNT_ID" ]]; then
    log_error "Missing required option: --account-id"
    usage
fi

if [[ -z "$CUSTOMIZATION" ]]; then
    log_error "Missing required option: --customization"
    usage
fi

if ! [[ "$ACCOUNT_ID" =~ ^[0-9]{12}$ ]]; then
    log_error "Invalid account ID format: $ACCOUNT_ID (must be 12 digits)"
    exit 1
fi

if [[ "$CUSTOMIZATION" == "global" ]]; then
    CUSTOMIZATION_DIR="$PROJECT_ROOT/terraform/aft/aft-global-customizations/terraform"
else
    CUSTOMIZATION_DIR="$PROJECT_ROOT/terraform/aft/aft-account-customizations/$CUSTOMIZATION/terraform"
fi

if [[ ! -d "$CUSTOMIZATION_DIR" ]]; then
    log_error "Customization directory not found: $CUSTOMIZATION_DIR"
    log_info "Available customizations:"
    
    if [[ -d "$PROJECT_ROOT/terraform/aft/aft-global-customizations/terraform" ]]; then
        echo "  - global"
    fi
    
    if [[ -d "$PROJECT_ROOT/terraform/aft/aft-account-customizations" ]]; then
        for dir in "$PROJECT_ROOT/terraform/aft/aft-account-customizations"/*; do
            if [[ -d "$dir/terraform" ]]; then
                echo "  - $(basename "$dir")"
            fi
        done
    fi
    
    exit 1
fi

log_info "AFT Local Testing"
log_info "================="
log_info "Account ID: $ACCOUNT_ID"
log_info "Customization: $CUSTOMIZATION"
log_info "Region: $REGION"
log_info "Directory: $CUSTOMIZATION_DIR"
log_info "Dry Run: $DRY_RUN"
echo ""

log_info "Setting up mock SSM parameters for local testing"
export AWS_ACCOUNT_ID="$ACCOUNT_ID"
export AWS_REGION="$REGION"
export TF_VAR_account_id="$ACCOUNT_ID"
export TF_VAR_region="$REGION"
export TF_VAR_aft_management_account_id="111111111111"
export TF_VAR_aft_execution_role_name="AWSAFTExecution"
export TF_VAR_aft_session_name="aft-local-test"
export TF_VAR_ct_management_account_id="111111111111"
export TF_VAR_log_archive_account_id="222222222222"
export TF_VAR_audit_account_id="333333333333"
log_success "Mock SSM parameters configured"
echo ""

cd "$CUSTOMIZATION_DIR"

log_info "Running terraform init..."
terraform init -backend=false

log_info "Running terraform validate..."
if terraform validate; then
    log_success "Terraform validation passed"
else
    log_error "Terraform validation failed"
    exit 1
fi
echo ""

log_info "Running terraform fmt -check..."
if terraform fmt -check -recursive; then
    log_success "Terraform formatting check passed"
else
    log_warn "Terraform formatting issues detected. Run 'terraform fmt -recursive' to fix."
fi
echo ""

log_info "Running terraform plan..."
if [[ "$DRY_RUN" == "true" ]]; then
    if terraform plan -input=false; then
        log_success "Terraform plan completed successfully"
        log_info "Dry run complete. No changes applied."
    else
        log_error "Terraform plan failed"
        exit 1
    fi
    exit 0
fi

if terraform plan -input=false -out=tfplan; then
    log_success "Terraform plan completed successfully"
    log_info "Plan saved to: $CUSTOMIZATION_DIR/tfplan"
else
    log_error "Terraform plan failed"
    exit 1
fi
echo ""

if [[ "$AUTO_APPROVE" == "true" ]]; then
    log_info "Applying changes (auto-approved)..."
    if terraform apply tfplan; then
        log_success "Terraform apply completed successfully"
    else
        log_error "Terraform apply failed"
        rm -f tfplan
        exit 1
    fi
else
    log_warn "This will apply changes to AWS account $ACCOUNT_ID"
    log_warn "Make sure you have the correct AWS credentials configured"
    echo ""
    read -p "Apply these changes? (yes/no): " CONFIRM
    if [[ "$CONFIRM" == "yes" ]]; then
        log_info "Applying changes..."
        if terraform apply tfplan; then
            log_success "Terraform apply completed successfully"
        else
            log_error "Terraform apply failed"
            rm -f tfplan
            exit 1
        fi
    else
        log_info "Apply cancelled by user"
        rm -f tfplan
        exit 0
    fi
fi

rm -f tfplan
echo ""
log_success "AFT local testing completed"
