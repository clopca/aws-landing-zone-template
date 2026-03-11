module "dns" {
  source = "../modules/dns"

  name_prefix = var.organization_name
  vpc_id      = module.hub_vpc.vpc_id

  create_private_hosted_zone        = true
  private_zone_name                 = var.private_hosted_zone_name
  share_zone_with_organization      = true
  organization_arn                  = var.organization_arn
  create_resolver_endpoints         = var.enable_dns_firewall
  create_inbound_endpoint           = var.enable_dns_firewall
  create_outbound_endpoint          = var.enable_dns_firewall
  create_internal_forward_rule      = var.enable_dns_firewall
  internal_forward_rule_domain_name = var.private_hosted_zone_name
  resolver_subnet_ids               = module.hub_vpc.private_subnet_ids
  resolver_allowed_cidrs            = ["10.0.0.0/8"]

  tags = {
    Component = "dns"
  }
}

resource "aws_ram_resource_association" "resolver_rule" {
  count = var.enable_dns_firewall ? 1 : 0

  resource_arn       = module.dns.resolver_rule_arns["internal"]
  resource_share_arn = module.dns.dns_ram_share_arn
}
