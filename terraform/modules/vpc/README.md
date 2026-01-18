# VPC Module

Creates a VPC with multi-tier subnet architecture designed for AWS Landing Zone deployments.

## Features

- **Multi-AZ Deployment**: Subnets across multiple availability zones
- **Tiered Subnets**: Public, private, database, and transit subnets
- **NAT Gateway**: Optional NAT gateway (single or per-AZ)
- **VPC Flow Logs**: Optional flow logging to S3 or CloudWatch
- **Secure Defaults**: Default security group with no rules

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                          VPC                                 │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Public    │  │   Public    │  │   Public    │         │
│  │  Subnet AZ1 │  │  Subnet AZ2 │  │  Subnet AZ3 │         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
│         │                │                │                  │
│  ┌──────┴──────┐  ┌──────┴──────┐  ┌──────┴──────┐         │
│  │   Private   │  │   Private   │  │   Private   │         │
│  │  Subnet AZ1 │  │  Subnet AZ2 │  │  Subnet AZ3 │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  Database   │  │  Database   │  │  Database   │         │
│  │  Subnet AZ1 │  │  Subnet AZ2 │  │  Subnet AZ3 │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Transit   │  │   Transit   │  │   Transit   │         │
│  │  Subnet AZ1 │  │  Subnet AZ2 │  │  Subnet AZ3 │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

## Usage

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name               = "workload-vpc"
  cidr_block         = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  enable_nat_gateway = true
  single_nat_gateway = false  # One NAT per AZ for HA

  enable_flow_logs         = true
  flow_log_destination_arn = "arn:aws:s3:::my-flow-logs-bucket"

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
```

## Subnet CIDR Allocation

Given a `/16` VPC CIDR, subnets are allocated as follows:

| Subnet Type | CIDR Range | Example (10.0.0.0/16) |
|-------------|------------|------------------------|
| Public      | /20        | 10.0.0.0/20 - 10.0.48.0/20 |
| Private     | /20        | 10.0.64.0/20 - 10.0.112.0/20 |
| Database    | /20        | 10.0.128.0/20 - 10.0.176.0/20 |
| Transit     | /22        | 10.0.192.0/22 - 10.0.204.0/22 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | VPC name | `string` | n/a | yes |
| cidr_block | VPC CIDR block | `string` | n/a | yes |
| availability_zones | List of AZs | `list(string)` | n/a | yes |
| enable_dns_support | Enable DNS support | `bool` | `true` | no |
| enable_dns_hostnames | Enable DNS hostnames | `bool` | `true` | no |
| enable_nat_gateway | Create NAT gateways | `bool` | `true` | no |
| single_nat_gateway | Use single NAT gateway | `bool` | `false` | no |
| enable_flow_logs | Enable VPC flow logs | `bool` | `true` | no |
| flow_log_destination_arn | Flow logs destination ARN | `string` | `""` | no |
| tags | Tags for resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| vpc_cidr_block | VPC CIDR block |
| public_subnet_ids | Public subnet IDs |
| private_subnet_ids | Private subnet IDs |
| database_subnet_ids | Database subnet IDs |
| transit_subnet_ids | Transit subnet IDs |
| nat_gateway_ids | NAT gateway IDs |
| private_route_table_ids | Private route table IDs |
| transit_route_table_id | Transit route table ID |

## Security Features

1. **Default Security Group**: Restricted with no ingress/egress rules
2. **Private Subnets**: No direct internet access
3. **Database Isolation**: Separate subnets for databases
4. **Transit Subnets**: Dedicated subnets for Transit Gateway attachments
