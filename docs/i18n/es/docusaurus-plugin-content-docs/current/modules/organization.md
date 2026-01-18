---
sidebar_position: 1
---

# Módulo de Organización {#organization-module}

El módulo de Organización gestiona AWS Organizations, Unidades Organizativas (OUs) y Políticas de Control de Servicios (SCPs).

## Descripción General {#overview}

Este módulo se despliega en la **Management Account** y crea:

- AWS Organization (si no existe)
- Jerarquía de Unidades Organizativas
- Políticas de Control de Servicios (SCPs)
- Configuración base de la cuenta

## Uso {#usage}

```hcl
module "organization" {
  source = "../modules/organization"

  organization_name = "acme-corp"
  
  organizational_units = {
    Security = {
      parent = "Root"
      accounts = ["Security", "Log Archive"]
    }
    Infrastructure = {
      parent = "Root"
      accounts = ["Network Hub", "Shared Services"]
    }
    Workloads = {
      parent = "Root"
      children = ["Production", "Non-Production"]
    }
    Production = {
      parent = "Workloads"
    }
    Non-Production = {
      parent = "Workloads"
    }
    Sandbox = {
      parent = "Root"
    }
  }

  scp_policies = {
    deny-leave-org = {
      targets = ["Root"]
    }
    require-imdsv2 = {
      targets = ["Workloads", "Sandbox"]
    }
    restrict-regions = {
      targets = ["Workloads"]
      allowed_regions = ["us-east-1", "us-west-2", "eu-west-1"]
    }
  }
}
```

## Entradas {#inputs}

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `organization_name` | Nombre de la organización | `string` | Yes |
| `organizational_units` | Mapa de OUs a crear | `map(object)` | Yes |
| `scp_policies` | Mapa de SCPs a crear y adjuntar | `map(object)` | No |
| `enable_all_features` | Habilitar todas las características de la organización | `bool` | No |
| `aws_service_access_principals` | Servicios de AWS a habilitar | `list(string)` | No |

## Salidas {#outputs}

| Name | Description |
|------|-------------|
| `organization_id` | ID de AWS Organization |
| `organization_arn` | ARN de AWS Organization |
| `root_id` | ID de la OU Raíz (Root) |
| `ou_ids` | Mapa de nombres de OU a IDs |
| `scp_ids` | Mapa de nombres de SCP a IDs |

## Políticas SCP {#scp-policies}

### deny-leave-org {#deny-leave-org}

Evita que las cuentas abandonen la organización.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyLeaveOrg",
      "Effect": "Deny",
      "Action": "organizations:LeaveOrganization",
      "Resource": "*"
    }
  ]
}
```

### require-imdsv2 {#require-imdsv2}

Requiere que las instancias EC2 utilicen IMDSv2.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RequireIMDSv2",
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "StringNotEquals": {
          "ec2:MetadataHttpTokens": "required"
        }
      }
    }
  ]
}
```

### restrict-regions {#restrict-regions}

Restringe las operaciones a las regiones de AWS aprobadas.

### deny-root-user {#deny-root-user}

Deniega acciones por parte del usuario raíz (excepto acciones específicas permitidas).

## Estructura de Archivos {#file-structure}

```
terraform/organization/
├── main.tf              # Organization y OUs
├── scps.tf              # Service Control Policies
├── iam-identity-center.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── backend.tf
└── terraform.tfvars.example
```

## Dependencias {#dependencies}

- Debe ser el primer módulo desplegado
- La Management account debe tener Organizations habilitado
- IAM Identity Center requiere una organización

## Relacionado {#related}

- [Arquitectura Multi-Cuenta](../architecture/multi-account)
- [Modelo de Seguridad](../architecture/security-model)
- [Módulo AFT](./aft)
