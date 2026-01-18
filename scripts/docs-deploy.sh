#!/bin/bash
# docs-deploy.sh - Deploy documentation using SST

set -e

STAGE=${1:-dev}

echo "Deploying documentation to stage: $STAGE"
echo "=========================================="

cd "$(dirname "$0")/../infra"

if [[ ! -f "package.json" ]]; then
    echo "Error: infra/package.json not found"
    echo "SST infrastructure not yet configured"
    exit 1
fi

if [[ ! -d "node_modules" ]]; then
    echo "Installing SST dependencies..."
    npm install
fi

# Build docs first
echo "Building documentation..."
cd ../docs
npm run build
cd ../infra

# Deploy with SST
echo ""
echo "Deploying with SST..."
npx sst deploy --stage "$STAGE"

echo ""
echo "=========================================="
echo "Deployment complete!"
