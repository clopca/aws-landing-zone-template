#!/bin/bash
set -euo pipefail

echo "Running post-API helpers for multi-region WORKLOAD account"
echo "Account ID: ${AWS_ACCOUNT_ID:-unknown}"
echo "Primary Region: ${PRIMARY_REGION:-us-east-1}"
echo "DR Region: ${DR_REGION:-us-west-2}"
