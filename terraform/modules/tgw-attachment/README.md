# Transit Gateway Attachment Module

Terraform module for attaching a VPC to an existing AWS Transit Gateway with a consistent association, propagation, and spoke-route model.

## Features

- Creates a TGW VPC attachment
- Associates the attachment with a single TGW route table
- Propagates the attachment into one or more TGW route tables
- Adds VPC route table entries for organization CIDRs that should traverse the TGW

## Usage

```hcl
module "tgw_attachment" {
  source = "../../modules/tgw-attachment"

  name                       = "shared-services"
  transit_gateway_id         = local.network_catalog.transit_gateway_id
  vpc_id                     = module.shared_services_vpc.vpc_id
  subnet_ids                 = module.shared_services_vpc.transit_subnet_ids
  association_route_table_id = local.network_catalog.route_table_ids.shared
  propagation_route_table_ids = [
    local.network_catalog.route_table_ids.shared
  ]
  spoke_route_table_ids = module.shared_services_vpc.private_route_table_ids
  destination_cidrs     = ["10.0.0.0/8"]
  tags                  = { ManagedBy = "terraform" }
}
```
