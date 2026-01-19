#!/bin/bash
# Post-API helpers - runs after Terraform apply
# Use this for any cleanup or validation tasks after infrastructure deployment

set -e

echo "Running post-API helpers for account customizations..."

# Example: Verify VPC was created
echo "Verifying VPC deployment..."
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${account_name}" --query 'Vpcs[0].VpcId' --output text

echo "Post-API helpers completed successfully"
