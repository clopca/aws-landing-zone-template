#!/bin/bash
# Pre-API helpers - runs before Terraform apply
# Use this for any setup tasks that need to happen before infrastructure deployment

set -e

echo "Running pre-API helpers for multi-region account customizations..."

# Validate custom fields
if [ -z "${primary_vpc_cidr}" ]; then
  echo "Warning: primary_vpc_cidr not set, will use default 10.10.0.0/16"
fi

if [ -z "${secondary_vpc_cidr}" ]; then
  echo "Warning: secondary_vpc_cidr not set, will use default 10.20.0.0/16"
fi

# Validate regions are different
if [ "${primary_region}" == "${secondary_region}" ]; then
  echo "ERROR: primary_region and secondary_region must be different"
  exit 1
fi

echo "Pre-API helpers completed successfully"
