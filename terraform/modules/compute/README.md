# Compute Module

This module creates secure compute resources for AWS Landing Zone deployments, including bastion hosts with SSM Session Manager access.

## Features

- **SSM Session Manager**: No SSH keys required, secure access via AWS Systems Manager
- **IMDSv2 Required**: Instance metadata service v2 enforced for security
- **Encrypted Volumes**: EBS encryption enabled by default
- **No Public IP**: Private subnet deployment by default
- **Auto Scaling**: Optional ASG for high availability
- **CloudWatch Integration**: Optional logging and monitoring
- **Session Logging**: Session Manager activity logged to CloudWatch

## Usage

### Basic Bastion Host

```hcl
module "compute" {
  source = "../../modules/compute"

  name_prefix = "myorg"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids

  enable_bastion = true

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
```

### High Availability with Auto Scaling

```hcl
module "compute" {
  source = "../../modules/compute"

  name_prefix = "myorg"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids

  enable_bastion             = true
  enable_bastion_auto_scaling = true
  bastion_desired_capacity   = 2
  bastion_min_size           = 1
  bastion_max_size           = 3

  tags = {
    Environment = "production"
  }
}
```

### With CloudWatch Monitoring

```hcl
module "compute" {
  source = "../../modules/compute"

  name_prefix = "myorg"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids

  enable_bastion                 = true
  enable_cloudwatch_agent        = true
  enable_session_manager_logging = true
  cloudwatch_log_retention_days  = 90

  tags = {
    Environment = "production"
  }
}
```

## Connecting to Bastion

Use AWS Session Manager to connect (no SSH required):

```bash
# Using AWS CLI
aws ssm start-session --target <instance-id>

# Or use the output command
terraform output ssm_connect_command
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_prefix | Prefix for resource names | `string` | n/a | yes |
| vpc_id | VPC ID for deployment | `string` | n/a | yes |
| subnet_ids | Subnet IDs for bastion | `list(string)` | n/a | yes |
| enable_bastion | Enable bastion host | `bool` | `true` | no |
| bastion_instance_type | EC2 instance type | `string` | `"t3.micro"` | no |
| bastion_ami_id | Custom AMI ID | `string` | `""` | no |
| bastion_root_volume_size | Root volume size (GB) | `number` | `20` | no |
| bastion_root_volume_encrypted | Encrypt root volume | `bool` | `true` | no |
| enable_bastion_auto_scaling | Enable ASG for HA | `bool` | `false` | no |
| enable_cloudwatch_agent | Enable CloudWatch agent | `bool` | `false` | no |
| enable_session_manager_logging | Log SSM sessions | `bool` | `true` | no |
| enable_imdsv2 | Require IMDSv2 | `bool` | `true` | no |
| associate_public_ip | Assign public IP | `bool` | `false` | no |
| tags | Tags for resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion_instance_id | EC2 instance ID |
| bastion_private_ip | Private IP address |
| bastion_security_group_id | Security group ID |
| bastion_iam_role_arn | IAM role ARN |
| ssm_connect_command | CLI command to connect |

## Security Features

1. **No SSH Access**: Security group has no inbound rules - SSM only
2. **IMDSv2 Required**: Prevents SSRF attacks via metadata service
3. **Encrypted Storage**: EBS volumes encrypted by default
4. **Private Deployment**: No public IP by default
5. **Session Logging**: All sessions logged to CloudWatch
6. **Minimal Permissions**: IAM role has only SSM permissions
