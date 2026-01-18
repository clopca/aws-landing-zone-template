---
sidebar_position: 1
---

# Guía Operativa de Aprovisionamiento de Cuentas {#account-vending-runbook}

Esta guía operativa describe cómo aprovisionar nuevas cuentas de AWS utilizando Account Factory for Terraform (AFT).

## Requisitos Previos {#prerequisites}

- [ ] Acceso al repositorio de AFT (CodeCommit o GitHub)
- [ ] Aprobación del equipo de plataforma para la nueva cuenta
- [ ] Detalles de la cuenta: nombre, correo electrónico, OU, centro de costos
- [ ] Información del usuario de SSO para el propietario de la cuenta

## Proceso de Solicitud de Cuenta {#account-request-process}

### Paso 1: Recopilar Información {#step-1-gather-information}

Recopile la siguiente información:

| Campo | Ejemplo | Notas |
|-------|---------|-------|
| Nombre de la Cuenta | `acme-prod-ecommerce` | Siga la convención de nombres |
| Correo de la Cuenta | `aws+prod-ecommerce@acme.com` | Correo único por cuenta |
| OU | `Production` | Debe existir en la organización |
| Correo del Usuario SSO | `team-lead@acme.com` | Acceso inicial de administrador |
| Centro de Costos | `CC-12345` | Para la asignación de facturación |
| Entorno | `production` | prod, staging, dev, sandbox |
| Tipo de Carga de Trabajo | `ecommerce` | Categoría de la aplicación |

### Paso 2: Crear la Solicitud de Cuenta {#step-2-create-account-request}

1. Clone el repositorio de solicitudes de cuenta de AFT:

```bash
git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/aft-account-request
cd aft-account-request
```

2. Cree un nuevo archivo de Terraform:

```bash
touch terraform/prod-ecommerce.tf
```

3. Añada la configuración de la solicitud de cuenta:

```hcl
# terraform/prod-ecommerce.tf
module "prod_ecommerce" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "aws+prod-ecommerce@acme.com"
    AccountName               = "acme-prod-ecommerce"
    ManagedOrganizationalUnit = "Production"
    SSOUserEmail              = "team-lead@acme.com"
    SSOUserFirstName          = "Team"
    SSOUserLastName           = "Lead"
  }

  account_tags = {
    Environment       = "production"
    CostCenter        = "CC-12345"
    Team              = "ecommerce"
    DataClassification = "confidential"
  }

  custom_fields = {
    workload_type      = "ecommerce"
    vpc_cidr           = "10.10.0.0/16"
    requires_tgw       = "true"
    compliance_scope   = "pci-dss"
  }

  account_customizations_name = "PROD-ECOMMERCE"
}
```

### Paso 3: Crear Personalizaciones de Cuenta (Opcional) {#step-3-create-account-customizations}

Si la cuenta necesita personalizaciones específicas:

1. Cree el directorio de personalización:

```bash
mkdir -p ../aft-account-customizations/PROD-ECOMMERCE/terraform
```

2. Añada la configuración de personalización:

```hcl
# aft-account-customizations/PROD-ECOMMERCE/terraform/main.tf

# Create workload VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "prod-ecommerce"
  cidr = local.custom_fields.vpc_cidr

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = [for i in range(3) : cidrsubnet(local.custom_fields.vpc_cidr, 4, i)]
  public_subnets  = [for i in range(3) : cidrsubnet(local.custom_fields.vpc_cidr, 4, i + 8)]

  enable_nat_gateway = true
  single_nat_gateway = false

  tags = local.tags
}

# Attach to Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count = local.custom_fields.requires_tgw == "true" ? 1 : 0

  subnet_ids         = module.vpc.private_subnets
  transit_gateway_id = data.aws_ssm_parameter.tgw_id.value
  vpc_id             = module.vpc.vpc_id

  tags = merge(local.tags, {
    Name = "prod-ecommerce-tgw-attachment"
  })
}
```

### Paso 4: Enviar Solicitud de Extracción (Pull Request) {#step-4-submit-pull-request}

1. Cree una rama y realice el commit:

```bash
git checkout -b account/prod-ecommerce
git add .
git commit -m "feat: request new account prod-ecommerce"
git push origin account/prod-ecommerce
```

2. Cree el Pull Request con:
   - Título: `Account Request: prod-ecommerce`
   - Descripción: Justificación comercial y detalles
   - Revisores: Equipo de plataforma

### Paso 5: Revisión y Aprobación {#step-5-review-and-approval}

El equipo de plataforma revisará:

- [ ] El nombre de la cuenta sigue las convenciones
- [ ] El correo electrónico es único y sigue el patrón
- [ ] La OU es apropiada para la carga de trabajo
- [ ] Las etiquetas están completas
- [ ] Las personalizaciones son válidas
- [ ] La asignación de costos está establecida

### Paso 6: Fusión y Aprovisionamiento {#step-6-merge-and-provision}

Tras la aprobación:

1. El PR se fusiona con la rama principal (main)
2. El pipeline de AFT se activa automáticamente
3. Control Tower aprovisiona la cuenta
4. Se aplican las personalizaciones globales
5. Se aplican las personalizaciones específicas de la cuenta

### Paso 7: Verificar la Cuenta {#step-7-verify-account}

1. Verifique el estado del pipeline de AFT en CodePipeline
2. Verifique que la cuenta aparezca en AWS Organizations
3. Pruebe el acceso SSO
4. Verifique que existan los recursos de la línea base

```bash
# Listar cuentas en la OU
aws organizations list-accounts-for-parent \
  --parent-id ou-xxxx-xxxxxxxx

# Verificar el estado de la cuenta
aws organizations describe-account \
  --account-id 123456789012
```

## Solución de Problemas {#troubleshooting}

### Fallo en el Pipeline {#pipeline-failed}

1. Verifique los detalles de ejecución de CodePipeline
2. Revise los logs de CloudWatch para las Step Functions
3. Problemas comunes:
   - Formato de correo electrónico inválido
   - La OU no existe
   - Error de sintaxis en Terraform

### La Cuenta no Aparece {#account-not-appearing}

1. Verifique el Account Factory de Control Tower
2. Verifique el portafolio de Service Catalog
3. Busque acciones pendientes en Control Tower

### Problemas de Acceso SSO {#sso-access-issues}

1. Verifique que el usuario SSO exista
2. Verifique la asignación del conjunto de permisos (permission set)
3. Verifique que la cuenta esté inscrita en IAM Identity Center

## Reversión {#rollback}

Para eliminar una cuenta aprovisionada:

1. Elimine el archivo de solicitud de cuenta
2. Cree el PR y fusiónelo
3. **Nota**: AFT no elimina automáticamente las cuentas
4. Cierre manualmente la cuenta a través de la consola de Organizations

## Relacionado {#related}

- [Documentación del Módulo AFT](../modules/aft)
- [Arquitectura Multi-Cuenta](../architecture/multi-account)
- [Guía Operativa de Despliegue](./deployment)
