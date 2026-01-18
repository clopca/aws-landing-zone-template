#!/bin/bash
# docs-build.sh - Build Docusaurus documentation

set -e

cd "$(dirname "$0")/../docs"

if [[ ! -f "package.json" ]]; then
    echo "Error: docs/package.json not found"
    echo "Documentation not yet initialized"
    exit 1
fi

if [[ ! -d "node_modules" ]]; then
    echo "Installing dependencies..."
    npm install
fi

echo "Building documentation..."
npm run build

echo ""
echo "Build complete! Output in docs/build/"
