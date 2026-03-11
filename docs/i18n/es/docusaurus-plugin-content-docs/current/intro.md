---
sidebar_position: 1
slug: /
description: Empiece aquí para entender AWS Landing Zone Template, sus componentes principales y la ruta de despliegue recomendada.
---

# Introducción

**AWS Landing Zone Template** es una base en Terraform, documentada con Docusaurus, para construir un entorno AWS multi-cuenta con gobernanza, seguridad, red y aprovisionamiento de cuentas bien definidos.

## Qué Incluye Esta Plantilla

- **Fundaciones organizacionales** con AWS Organizations, OUs y SCPs
- **Línea base de seguridad** con GuardDuty, Security Hub, Config y logging centralizado
- **Patrones de red hub** para conectividad compartida y DNS
- **Integración con AFT** para aprovisionamiento y personalización automatizada de cuentas
- **Documentación operativa** para despliegue, troubleshooting y operación diaria

## Antes de Empezar

- AWS CLI v2 configurado con acceso a la cuenta de management
- Terraform `>= 1.5.0`
- Node.js `>= 20` para el sitio de documentación
- Beads CLI (`bd`) para el seguimiento de trabajo

## Primeros Pasos Recomendados

1. Revise la [Descripción General de la Arquitectura](./architecture/overview).
2. Lea la guía de [Configuración de Control Tower](./architecture/control-tower).
3. Siga la [Guía Operativa de Despliegue](./runbooks/deployment).
4. Use la [Guía Operativa de Aprovisionamiento de Cuentas](./runbooks/account-vending) cuando esté listo para crear cuentas de workload.

## Estructura del Repositorio

```text
aws-landing-zone-template/
├── terraform/
│   ├── organization/      # AWS Organizations, OUs, SCPs
│   ├── security/          # GuardDuty, Security Hub, Config
│   ├── log-archive/       # CloudTrail, Config, logs centralizados
│   ├── network/           # Transit Gateway, VPCs, DNS
│   ├── shared-services/   # CI/CD, registries y tooling compartido
│   ├── aft/               # Integración con Account Factory for Terraform
│   └── modules/           # Módulos reutilizables de Terraform
├── docs/                  # Sitio Docusaurus y contenido documental
├── infra/                 # Despliegue del sitio de docs con SST
└── scripts/               # Scripts auxiliares para flujos locales
```

## Lectura Sugerida

- [Modelo de Seguridad](./architecture/security-model)
- [Diseño de Red](./architecture/network-design)
- [Estrategia de IAM](./architecture/iam-strategy)
- [Módulos](./modules/organization)
- [Guías de Operación](./runbooks/deployment)

## Soporte

- [GitHub Issues](https://github.com/your-org/aws-landing-zone-template/issues)
- [AWS Documentation](https://docs.aws.amazon.com/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
