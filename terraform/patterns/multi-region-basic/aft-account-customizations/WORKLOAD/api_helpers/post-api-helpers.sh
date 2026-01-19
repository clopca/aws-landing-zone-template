#!/bin/bash
# Post-API helpers - runs after Terraform apply
# Use this for any cleanup or validation tasks after infrastructure deployment

set -e

echo "Running post-API helpers for multi-region account customizations..."

# Verify primary VPC was created
echo "Verifying primary VPC deployment in ${primary_region}..."
aws ec2 describe-vpcs \
  --region "${primary_region}" \
  --filters "Name=tag:Name,Values=${account_name}-primary" \
  --query 'Vpcs[0].VpcId' \
  --output text

# Verify secondary VPC was created
echo "Verifying secondary VPC deployment in ${secondary_region}..."
aws ec2 describe-vpcs \
  --region "${secondary_region}" \
  --filters "Name=tag:Name,Values=${account_name}-secondary" \
  --query 'Vpcs[0].VpcId' \
  --output text

# Verify backup vault
echo "Verifying backup vault..."
aws backup describe-backup-vault \
  --region "${primary_region}" \
  --backup-vault-name "${account_name}-backup" \
  --query 'BackupVaultName' \
  --output text

echo "Post-API helpers completed successfully"
