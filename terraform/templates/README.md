# Jinja2 Templates for Dynamic Terraform Configuration

This directory contains Jinja2 templates for generating dynamic Terraform configurations, particularly useful for cross-account operations in AFT.

## Templates

| Template | Purpose |
|----------|---------|
| `providers.tf.j2` | AWS provider with assume role configuration |
| `backend.tf.j2` | S3 backend with DynamoDB locking |

## Usage

### Install Dependencies

```bash
pip install -r requirements.txt
```

### Render Provider Configuration

```bash
python render.py \
    --template providers.tf.j2 \
    --output providers.tf \
    --var account_id=123456789012 \
    --var region=us-east-1 \
    --var role_name=AFTExecution
```

### Render Backend Configuration

```bash
python render.py \
    --template backend.tf.j2 \
    --output backend.tf \
    --var bucket=my-terraform-state \
    --var key=accounts/123456789012/terraform.tfstate \
    --var region=us-east-1 \
    --var dynamodb_table=terraform-locks
```

### Using Config File

Create a YAML config file:

```yaml
account_id: "123456789012"
region: us-east-1
role_name: AFTExecution
environment: production
secondary_region: us-west-2
```

Then render:

```bash
python render.py \
    --template providers.tf.j2 \
    --output providers.tf \
    --config config.yaml
```

## Template Variables

### providers.tf.j2

| Variable | Required | Description |
|----------|----------|-------------|
| account_id | Yes | Target AWS account ID |
| region | Yes | Primary AWS region |
| role_name | Yes | IAM role to assume |
| session_name | No | STS session name (default: terraform-session) |
| environment | No | Environment tag (default: production) |
| secondary_region | No | Secondary region for multi-region deployments |

### backend.tf.j2

| Variable | Required | Description |
|----------|----------|-------------|
| bucket | Yes | S3 bucket for state |
| key | Yes | State file key/path |
| region | Yes | S3 bucket region |
| dynamodb_table | Yes | DynamoDB table for locking |
| role_arn | No | IAM role ARN for backend access |

## Integration with AFT

These templates are used by AFT to generate provider configurations dynamically for each account customization. The `render.py` script is called during the AFT pipeline to create account-specific Terraform configurations.
