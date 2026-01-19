# Custom Checkov Checks

This directory contains custom Checkov security checks specific to this AWS Landing Zone.

## Existing Custom Checks

### CKV_CUSTOM_1: Required Tags Check

**File**: `required_tags.py`

**Purpose**: Ensures all taggable resources have required tags:
- `ManagedBy` - Identifies who/what manages the resource
- `Environment` - Identifies the environment (dev, staging, prod, etc.)

**Applies to**:
- aws_vpc
- aws_subnet
- aws_security_group
- aws_instance
- aws_s3_bucket
- aws_iam_role
- aws_lambda_function
- aws_rds_cluster
- aws_dynamodb_table

## Creating New Custom Checks

### Basic Structure

```python
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck
from checkov.common.models.enums import CheckResult, CheckCategories

class MyCustomCheck(BaseResourceCheck):
    def __init__(self):
        name = "Description of what this check does"
        id = "CKV_CUSTOM_X"  # Use next available number
        supported_resources = ["aws_resource_type"]
        categories = [CheckCategories.CONVENTION]  # or ENCRYPTION, IAM, etc.
        super().__init__(
            name=name,
            id=id,
            categories=categories,
            supported_resources=supported_resources,
        )

    def scan_resource_conf(self, conf):
        # Your check logic here
        # Return CheckResult.PASSED or CheckResult.FAILED
        return CheckResult.PASSED

check = MyCustomCheck()
```

### Available Categories

- `CheckCategories.ENCRYPTION` - Encryption-related checks
- `CheckCategories.IAM` - IAM and access control checks
- `CheckCategories.NETWORKING` - Network security checks
- `CheckCategories.LOGGING` - Logging and monitoring checks
- `CheckCategories.BACKUP_AND_RECOVERY` - Backup configuration checks
- `CheckCategories.CONVENTION` - Organizational conventions and standards

### Testing Custom Checks

Run Checkov against a specific directory to test your custom check:

```bash
checkov -d terraform/organization --external-checks-dir terraform/.checkov/custom-checks
```

### Custom Check ID Convention

Use the format `CKV_CUSTOM_X` where X is a sequential number:
- CKV_CUSTOM_1: Required Tags
- CKV_CUSTOM_2: Your next check
- CKV_CUSTOM_3: Another check
- etc.

## Examples of Useful Custom Checks

### Enforce Specific Naming Conventions

```python
def scan_resource_conf(self, conf):
    name = conf.get("name", [""])[0]
    if not name.startswith("lz-"):
        return CheckResult.FAILED
    return CheckResult.PASSED
```

### Ensure KMS Keys Have Rotation Enabled

```python
supported_resources = ["aws_kms_key"]

def scan_resource_conf(self, conf):
    rotation = conf.get("enable_key_rotation", [False])[0]
    if rotation is True:
        return CheckResult.PASSED
    return CheckResult.FAILED
```

### Validate S3 Bucket Naming

```python
import re

supported_resources = ["aws_s3_bucket"]

def scan_resource_conf(self, conf):
    bucket = conf.get("bucket", [""])[0]
    # Enforce org-specific naming: org-env-purpose-random
    pattern = r"^[a-z0-9-]+-[a-z]+-[a-z0-9-]+-[a-z0-9]{8}$"
    if re.match(pattern, bucket):
        return CheckResult.PASSED
    return CheckResult.FAILED
```

## References

- [Checkov Custom Policies Documentation](https://www.checkov.io/3.Custom%20Policies/Custom%20Policies%20Overview.html)
- [Checkov Python SDK](https://www.checkov.io/3.Custom%20Policies/Python%20Custom%20Policies.html)
- [Check Categories](https://github.com/bridgecrewio/checkov/blob/main/checkov/common/models/enums.py)
