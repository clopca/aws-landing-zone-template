# DNS Module

Terraform module for managing Route53 private hosted zones and Route53 Resolver endpoints for hybrid DNS resolution.

## Features

- Private Route53 hosted zones with VPC associations
- Route53 Resolver inbound endpoints (on-premises to AWS)
- Route53 Resolver outbound endpoints (AWS to on-premises)
- Conditional forwarding rules for hybrid DNS
- AWS RAM sharing for cross-account zone and rule access

## Usage

### Private Hosted Zone Only

```hcl
module "dns" {
  source = "../../modules/dns"

  name_prefix = "network-hub"
  vpc_id      = module.vpc.vpc_id

  create_private_hosted_zone = true
  private_zone_name          = "internal.example.com"
  
  share_zone_with_organization = true
  organization_arn             = "arn:aws:organizations::123456789012:organization/o-xxxxx"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Hybrid DNS with Resolver Endpoints

```hcl
module "dns" {
  source = "../../modules/dns"

  name_prefix = "network-hub"
  vpc_id      = module.vpc.vpc_id

  create_private_hosted_zone = true
  private_zone_name          = "aws.internal.example.com"
  
  create_resolver_endpoints = true
  create_inbound_endpoint   = true
  create_outbound_endpoint  = true
  
  resolver_subnet_ids = [
    module.vpc.private_subnet_ids[0],
    module.vpc.private_subnet_ids[1]
  ]
  
  resolver_allowed_cidrs = [
    "10.0.0.0/8",
    "172.16.0.0/12"
  ]
  
  forward_rules = {
    onprem = {
      domain_name = "onprem.example.com"
      target_ips = [
        {
          ip   = "10.1.1.53"
          port = 53
        },
        {
          ip   = "10.1.2.53"
          port = 53
        }
      ]
    }
  }
  
  share_zone_with_organization  = true
  share_rules_with_organization = true
  organization_arn              = "arn:aws:organizations::123456789012:organization/o-xxxxx"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_prefix | Prefix for resource names | `string` | n/a | yes |
| vpc_id | VPC ID for the private hosted zone and resolver endpoints | `string` | n/a | yes |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |
| create_private_hosted_zone | Whether to create a private hosted zone | `bool` | `false` | no |
| private_zone_name | Name of the private hosted zone | `string` | `""` | no |
| additional_vpc_ids | Additional VPC IDs to associate with the private hosted zone | `list(string)` | `[]` | no |
| share_zone_with_organization | Whether to share the private hosted zone with the organization via RAM | `bool` | `false` | no |
| organization_arn | ARN of the AWS Organization to share resources with | `string` | `""` | no |
| create_resolver_endpoints | Whether to create Route53 Resolver endpoints | `bool` | `false` | no |
| create_inbound_endpoint | Whether to create an inbound resolver endpoint | `bool` | `false` | no |
| create_outbound_endpoint | Whether to create an outbound resolver endpoint | `bool` | `false` | no |
| resolver_subnet_ids | Subnet IDs for resolver endpoints (minimum 2 required) | `list(string)` | `[]` | no |
| resolver_allowed_cidrs | CIDR blocks allowed to query the resolver endpoints | `list(string)` | `["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]` | no |
| forward_rules | Map of forwarding rules for outbound resolver | `map(object)` | `{}` | no |
| share_rules_with_organization | Whether to share resolver rules with the organization via RAM | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| private_zone_id | ID of the private hosted zone |
| private_zone_name | Name of the private hosted zone |
| private_zone_arn | ARN of the private hosted zone |
| private_zone_name_servers | Name servers for the private hosted zone |
| inbound_endpoint_id | ID of the inbound resolver endpoint |
| inbound_endpoint_ips | IP addresses of the inbound resolver endpoint |
| outbound_endpoint_id | ID of the outbound resolver endpoint |
| outbound_endpoint_ips | IP addresses of the outbound resolver endpoint |
| resolver_security_group_id | ID of the resolver security group |
| resolver_rule_ids | Map of resolver rule names to IDs |
| resolver_rule_arns | Map of resolver rule names to ARNs |
| dns_ram_share_id | ID of the DNS RAM resource share |
| resolver_rules_ram_share_id | ID of the resolver rules RAM resource share |

## Architecture

This module supports hybrid DNS resolution between AWS and on-premises environments:

1. **Inbound Endpoint**: Allows on-premises DNS servers to resolve AWS private hosted zone records
2. **Outbound Endpoint**: Allows AWS resources to resolve on-premises domain names
3. **Forwarding Rules**: Define which domains should be forwarded to on-premises DNS servers
4. **RAM Sharing**: Share zones and rules across AWS Organization accounts

## Notes

- Resolver endpoints require at least 2 subnets in different Availability Zones
- Each resolver endpoint creates 1 ENI per subnet
- Inbound endpoint IPs should be configured as forwarders in on-premises DNS
- Outbound forwarding rules are automatically applied to all VPCs that accept the RAM share
