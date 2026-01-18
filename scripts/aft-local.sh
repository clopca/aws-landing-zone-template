#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Local testing script for AFT customizations.

OPTIONS:
    --account-id ID       Target AWS account ID (required)
    --customization NAME  Customization to run: global, WORKLOAD, etc. (required)
    --region REGION       AWS region (default: us-east-1)
    --dry-run             Validate only, don't apply
    --auto-approve        Skip confirmation prompts
    --help                Show this help message

EXAMPLES:
    $(basename "$0") --account-id 123456789012 --customization global
    $(basename "$0") --account-id 123456789012 --customization WORKLOAD --dry-run
    $(basename "$0") --account-id 123456789012 --customization global --region us-west-2

EOF
    exit 0
}

log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

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

if [[ "$CUSTOMIZATION" == "global" ]]; then
    CUSTOMIZATION_DIR="$PROJECT_ROOT/terraform/aft/aft-global-customizations/terraform"
else
    CUSTOMIZATION_DIR="$PROJECT_ROOT/terraform/aft/aft-account-customizations/$CUSTOMIZATION/terraform"
fi

if [[ ! -d "$CUSTOMIZATION_DIR" ]]; then
    log_error "Customization directory not found: $CUSTOMIZATION_DIR"
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

export AWS_ACCOUNT_ID="$ACCOUNT_ID"
export AWS_REGION="$REGION"
export TF_VAR_account_id="$ACCOUNT_ID"
export TF_VAR_region="$REGION"

cd "$CUSTOMIZATION_DIR"

log_info "Running terraform init..."
terraform init -backend=false

log_info "Running terraform validate..."
terraform validate

log_info "Running terraform fmt -check..."
if ! terraform fmt -check -recursive; then
    log_warn "Terraform formatting issues detected. Run 'terraform fmt' to fix."
fi

log_info "Running terraform plan..."
if [[ "$DRY_RUN" == "true" ]]; then
    terraform plan -input=false
    log_info "Dry run complete. No changes applied."
    exit 0
fi

terraform plan -input=false -out=tfplan

if [[ "$AUTO_APPROVE" == "true" ]]; then
    log_info "Applying changes (auto-approved)..."
    terraform apply tfplan
else
    echo ""
    read -p "Apply these changes? (yes/no): " CONFIRM
    if [[ "$CONFIRM" == "yes" ]]; then
        log_info "Applying changes..."
        terraform apply tfplan
    else
        log_info "Apply cancelled."
        rm -f tfplan
        exit 0
    fi
fi

rm -f tfplan
log_info "Local testing complete!"
