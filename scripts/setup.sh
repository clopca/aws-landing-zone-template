#!/bin/bash
# setup.sh - Set up AWS Landing Zone Template development environment
#
# This script installs all dependencies:
# - Beads (bd) for task tracking
# - Node.js dependencies for Docusaurus and SST
# - Terraform (if not installed)

set -e

echo "=========================================="
echo "AWS Landing Zone Template Setup"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check for required tools
check_tool() {
    if command -v "$1" &> /dev/null; then
        print_status "$1 is installed"
        return 0
    else
        print_warning "$1 is not installed"
        return 1
    fi
}

echo "Checking prerequisites..."
echo ""

# Check Node.js
if ! check_tool node; then
    print_error "Node.js is required. Install from: https://nodejs.org"
    exit 1
fi

# Check pnpm
if ! check_tool pnpm; then
    print_warning "pnpm not found. Installing..."
    npm install -g pnpm
fi

# Check Terraform
if ! check_tool terraform; then
    print_warning "Terraform not found. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew tap hashicorp/tap
        brew install hashicorp/tap/terraform
    else
        print_error "Please install Terraform manually: https://terraform.io/downloads"
        exit 1
    fi
fi

# Check AWS CLI
if ! check_tool aws; then
    print_warning "AWS CLI not found. You'll need it for deployments."
    print_warning "Install from: https://aws.amazon.com/cli/"
fi

echo ""
echo "Installing Beads (task tracking)..."
echo ""

# Detect OS and install beads
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - use Homebrew
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew is required on macOS."
        echo "Install from: https://brew.sh"
        exit 1
    fi
    
    if command -v bd &> /dev/null; then
        print_status "Beads already installed, upgrading..."
        brew upgrade steveyegge/beads/bd 2>/dev/null || true
    else
        echo "Installing Beads via Homebrew..."
        brew install steveyegge/beads/bd
    fi
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux - check if brew is available or use cargo
    if command -v brew &> /dev/null; then
        if command -v bd &> /dev/null; then
            print_status "Beads already installed"
        else
            echo "Installing Beads via Homebrew..."
            brew install steveyegge/beads/bd
        fi
    elif command -v cargo &> /dev/null; then
        echo "Installing Beads via Cargo..."
        cargo install beads
    else
        print_error "Install Homebrew (https://brew.sh) or Cargo (https://rustup.rs)"
        exit 1
    fi
else
    print_error "Unsupported OS. Please install beads manually."
    echo "See: https://github.com/steveyegge/beads"
    exit 1
fi

# Verify beads installation
if command -v bd &> /dev/null; then
    print_status "Beads installed successfully"
else
    print_error "bd command not found after installation"
    exit 1
fi

# Initialize beads if not already done
if [[ ! -f ".beads/issues.jsonl" ]]; then
    echo ""
    echo "Initializing Beads..."
    bd init
    print_status "Beads initialized"
else
    print_status "Beads already initialized"
fi

# Install docs dependencies if docs/package.json exists
if [[ -f "docs/package.json" ]]; then
    echo ""
    echo "Installing documentation dependencies..."
    cd docs
    pnpm install
    cd ..
    print_status "Documentation dependencies installed"
fi

# Install SST dependencies if infra/package.json exists
if [[ -f "infra/package.json" ]]; then
    echo ""
    echo "Installing SST dependencies..."
    cd infra
    pnpm install
    cd ..
    print_status "SST dependencies installed"
fi

# Make scripts executable
chmod +x scripts/*.sh 2>/dev/null || true

echo ""
echo "=========================================="
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Create tasks:         bd create --title='Task name' --type=task --priority=1"
echo "  2. View ready tasks:     bd ready"
echo "  3. Start docs dev:       make docs-dev"
echo "  4. Run Ralph loop:       ./scripts/ralph-loop.sh [max-iterations]"
echo ""
echo "Useful commands:"
echo "  make help              - Show all available commands"
echo "  make tf-validate       - Validate all Terraform"
echo "  make docs-build        - Build documentation"
echo "=========================================="
