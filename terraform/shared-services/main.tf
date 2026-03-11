data "aws_ssm_parameter" "network_catalog" {
  name = "/org/network/catalog"
}

data "aws_ssm_parameter" "log_archive_catalog" {
  name = "/org/log-archive/catalog"
}

locals {
  network_catalog     = jsondecode(data.aws_ssm_parameter.network_catalog.value)
  log_archive_catalog = jsondecode(data.aws_ssm_parameter.log_archive_catalog.value)
}

module "shared_services_vpc" {
  source = "../modules/vpc"

  name                     = "${var.organization_name}-shared-services"
  cidr_block               = var.vpc_cidr
  availability_zones       = var.availability_zones
  create_database_subnets  = false
  create_transit_subnets   = true
  enable_nat_gateway       = true
  single_nat_gateway       = false
  enable_flow_logs         = true
  flow_log_destination_arn = local.log_archive_catalog.vpc_flow_logs_bucket_arn

  tags = {
    Component = "shared-services"
  }
}

module "shared_services_attachment" {
  source = "../modules/tgw-attachment"

  name                        = "${var.organization_name}-shared-services-attachment"
  transit_gateway_id          = local.network_catalog.transit_gateway_id
  vpc_id                      = module.shared_services_vpc.vpc_id
  subnet_ids                  = module.shared_services_vpc.transit_subnet_ids
  association_route_table_id  = local.network_catalog.route_table_ids.shared
  propagation_route_table_ids = [local.network_catalog.route_table_ids.shared]
  spoke_route_table_ids       = module.shared_services_vpc.private_route_table_ids
  destination_cidrs           = var.organization_cidrs

  tags = {
    Component = "shared-services"
  }
}

resource "aws_ecr_repository" "main" {
  for_each = var.enable_ecr ? toset(var.ecr_repositories) : []

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name      = each.value
    Component = "shared-services"
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  for_each = var.enable_ecr ? toset(var.ecr_repositories) : []

  repository = aws_ecr_repository.main[each.key].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
