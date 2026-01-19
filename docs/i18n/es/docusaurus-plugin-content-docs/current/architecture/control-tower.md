---
sidebar_position: 2
---

# Configuración de Control Tower

AWS Control Tower es la base de esta landing zone. Esta guía cubre los prerrequisitos y el proceso de configuración.

## Prerrequisitos

Antes de desplegar esta plantilla de landing zone, necesitas:

1. **Cuenta AWS** - Una cuenta AWS nueva para servir como cuenta Management
2. **AWS Organizations** - No habilitado (Control Tower lo creará)
3. **IAM Identity Center** - No habilitado (Control Tower lo configurará)
4. **Direcciones de Email** - Emails únicos para:
   - Cuenta Log Archive
   - Cuenta Audit
   - Cuenta AFT Management
   - Cuentas adicionales que planees crear

:::warning Cuenta Nueva Recomendada
Control Tower funciona mejor con una cuenta AWS nueva. Si usas una cuenta existente con Organizations ya habilitado, necesitarás seguir la guía de [Control Tower con Organizations existente](https://docs.aws.amazon.com/controltower/latest/userguide/existing-orgs.html).
:::

## Desplegar Control Tower

### Paso 1: Habilitar Control Tower

1. Inicia sesión en la Consola de AWS como usuario root o un usuario IAM con permisos de administrador
2. Navega al servicio **AWS Control Tower**
3. Haz clic en **Set up landing zone**
4. Configura lo siguiente:

| Configuración | Recomendación |
|---------|---------------|
| **Región Principal** | Tu región principal (ej. `us-east-1`) |
| **Regiones Adicionales** | Regiones donde desplegarás workloads |
| **OU Foundational** | `Security` (por defecto) |
| **OU Adicional** | `Sandbox` (por defecto) |
| **Cuenta Log Archive** | Crear nueva con email dedicado |
| **Cuenta Audit** | Crear nueva con email dedicado |

5. Revisa y acepta los permisos del servicio
6. Haz clic en **Set up landing zone**

:::info Tiempo de Configuración
La configuración de Control Tower toma aproximadamente 30-60 minutos en completarse.
:::

### Paso 2: Crear OUs Adicionales

Después de que la configuración de Control Tower se complete, crea OUs adicionales a través de la consola de Control Tower:

1. Navega a **Control Tower** → **Organization**
2. Haz clic en **Create organizational unit**
3. Crea los siguientes OUs:

| Nombre OU | Propósito | Padre |
|---------|---------|--------|
| **Infrastructure** | Network Hub, Shared Services, AFT | Root |
| **Workloads** | Workloads de producción y staging | Root |
| **Workloads/Production** | Cuentas de producción | Workloads |
| **Workloads/Staging** | Cuentas de staging | Workloads |
| **Workloads/Development** | Cuentas de desarrollo | Workloads |

### Paso 3: Habilitar Guardrails

Control Tower viene con guardrails obligatorios. Habilita guardrails adicionales recomendados:

1. Navega a **Control Tower** → **Guardrails**
2. Habilita guardrails **Strongly Recommended** para todos los OUs
3. Considera habilitar guardrails **Elective** según tus necesidades de cumplimiento

Guardrails clave para habilitar:

| Guardrail | Tipo | Propósito |
|-----------|------|---------|
| Denegar acceso público de lectura a S3 | Preventivo | Protección de datos |
| Denegar acceso público de escritura a S3 | Preventivo | Protección de datos |
| Detectar MFA no habilitado para root | Detectivo | Seguridad de identidad |
| Detectar instancias RDS públicas | Detectivo | Protección de datos |
| Detectar SSH sin restricciones | Detectivo | Seguridad de red |

### Paso 4: Configurar IAM Identity Center

1. Navega a **IAM Identity Center**
2. Configura la fuente de identidad:
   - **Directorio IAM Identity Center** (por defecto) - para equipos pequeños
   - **IdP Externo** - para empresas (Okta, Azure AD, etc.)
3. Crea Permission Sets:
   - `AdministratorAccess` - Acceso admin completo
   - `ReadOnlyAccess` - Auditoría y revisión
   - `PowerUserAccess` - Acceso de desarrollador
4. Crea Grupos y asigna usuarios

## Verificar Configuración de Control Tower

Antes de proceder con el despliegue de AFT, verifica:

```bash
# Listar OUs (desde la cuenta Management)
aws organizations list-organizational-units-for-parent \
  --parent-id $(aws organizations list-roots --query 'Roots[0].Id' --output text)

# Listar cuentas
aws organizations list-accounts

# Verificar estado de Control Tower
aws controltower list-enabled-controls \
  --target-identifier arn:aws:organizations::ACCOUNT_ID:ou/o-xxxxx/ou-xxxx-xxxxxxxx
```

## IDs de Cuenta para AFT

Recopila estos IDs de cuenta para la configuración de AFT:

| Cuenta | Cómo Encontrar |
|---------|-------------|
| ID Cuenta Management | Consola AWS → esquina superior derecha → Account ID |
| ID Cuenta Log Archive | Control Tower → Organization → Log Archive |
| ID Cuenta Audit | Control Tower → Organization → Audit |

## Próximos Pasos

Una vez que Control Tower esté desplegado:

1. [Crear Cuenta AFT Management](../runbooks/deployment#paso-1-crear-cuenta-aft)
2. [Desplegar AFT](../runbooks/deployment#paso-2-desplegar-aft)
3. [Configurar Personalizaciones de Cuenta](../modules/aft)

## Solución de Problemas

### Falló la Configuración de Control Tower

Revisa los stacks de CloudFormation en la cuenta Management:
- Stacks `AWSControlTowerBP-*`
- Revisa los eventos para razones de fallo

Problemas comunes:
- **Límites de servicio** - Solicita incrementos de límite antes de reintentar
- **Email ya usado** - Usa emails únicos para cada cuenta
- **Región no habilitada** - Habilita regiones en Account Settings primero

### No se Pueden Crear OUs

Asegúrate de usar la consola de Control Tower, no AWS Organizations directamente. Control Tower necesita registrar OUs para aplicar guardrails.

### Guardrails No se Aplican

1. Verifica que el OU esté registrado con Control Tower
2. Revisa drift de guardrails: **Control Tower** → **Landing zone settings** → **Repair**
