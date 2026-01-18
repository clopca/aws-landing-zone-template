#!/bin/bash
# docs-dev.sh - Start Docusaurus development server

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

echo "Starting Docusaurus dev server..."
npm run start
