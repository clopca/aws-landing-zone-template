# Transit Gateway Module

This module creates an AWS Transit Gateway with route tables and optional organization-wide sharing via AWS RAM.

## Features

- **Transit Gateway**: Central hub for VPC connectivity
- **Route Tables**: Configurable route tables for traffic segmentation
- **RAM Sharing**: Share Transit Gateway with entire AWS Organization
- **BGP Support**: Configurable ASN for hybrid connectivity

## Usage

```hcl
module "transit_gateway" {
  source = "../../modules/transit-gateway"

  name            = "acme-tgw"
  amazon_side_asn = 64512

  # Route tables for traffic segmentation
  route_tables = ["shared", "production", "nonproduction"]

  # Share with organization
  share_with_organization = true
  organization_arn        = "arn:aws:organizations::123456789012:organization/o-example"

  # Auto-accept attachments from organization accounts
  auto_accept_shared_attachments = "enable"

  tags = {
    Environment = "shared"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix for Transit Gateway resources | `string` | n/a | yes |
| amazon_side_asn | Private ASN for the Amazon side of a BGP session | `number` | `64512` | no |
| auto_accept_shared_attachments | Auto accept shared attachments | `string` | `"enable"` | no |
| route_tables | List of route table names to create | `list(string)` | `["shared", "production", "nonproduction"]` | no |
| share_with_organization | Share Transit Gateway with entire organization | `bool` | `true` | no |
| organization_arn | ARN of the organization to share with | `string` | `""` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| transit_gateway_id | Transit Gateway ID |
| transit_gateway_arn | Transit Gateway ARN |
| route_table_ids | Map of route table names to IDs |
| ram_share_arn | RAM resource share ARN |

## Architecture

```
                    ┌─────────────────────────────────────┐
                    │         Transit Gateway             │
                    │         (Network Hub)               │
                    └─────────────────────────────────────┘
                                    │
            ┌───────────────────────┼───────────────────────┐
            │                       │                       │
    ┌───────┴───────┐       ┌───────┴───────┐       ┌───────┴───────┐
    │   Shared RT   │       │ Production RT │       │ Non-Prod RT   │
    │               │       │               │       │               │
    │ - Shared VPC  │       │ - Prod VPCs   │       │ - Dev VPCs    │
    │ - Egress VPC  │       │               │       │ - Stage VPCs  │
    └───────────────┘       └───────────────┘       └───────────────┘
```

## Route Table Strategy

| Route Table | Purpose | Typical Attachments |
|-------------|---------|---------------------|
| `shared` | Access to shared services | Shared Services VPC, Egress VPC |
| `production` | Production workloads | Production account VPCs |
| `nonproduction` | Non-production workloads | Dev, Staging, QA VPCs |

## Attaching a VPC

To attach a VPC from another account:

```hcl
# In the workload account
resource "aws_ec2_transit_gateway_vpc_attachment" "workload" {
  subnet_ids         = var.transit_subnet_ids
  transit_gateway_id = data.aws_ec2_transit_gateway.shared.id
  vpc_id             = aws_vpc.workload.id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "workload-attachment"
  }
}

# Accept RAM share first
resource "aws_ram_resource_share_accepter" "tgw" {
  share_arn = data.aws_ram_resource_share.tgw.arn
}
```

## Related Modules

- [VPC Module](../vpc/) - For creating VPCs to attach
- [Networking Module](../../network/) - For complete network hub setup
