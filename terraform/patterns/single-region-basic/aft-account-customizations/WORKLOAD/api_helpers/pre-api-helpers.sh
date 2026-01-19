#!/bin/bash
# Pre-API helpers - runs before Terraform apply
# Use this for any setup tasks that need to happen before infrastructure deployment

set -e

echo "Running pre-API helpers for account customizations..."

# Example: Validate custom fields
if [ -z "${vpc_cidr}" ]; then
  echo "Warning: vpc_cidr not set, will use default 10.10.0.0/16"
fi

echo "Pre-API helpers completed successfully"
