---
sidebar_position: 8
---

# Mapeo de Cumplimiento {#mapeo-de-cumplimiento}

Este documento mapea la implementación de la AWS Landing Zone con los marcos de cumplimiento comunes y proporciona orientación para la preparación de auditorías.

## Descripción General {#descripcion-general-cumplimiento}

La arquitectura de la Landing Zone soporta el cumplimiento con múltiples marcos regulatorios a través de una combinación de controles preventivos, detectivos y responsivos. Este mapeo ayuda a las organizaciones a entender cómo la infraestructura soporta sus requisitos de cumplimiento.

**Importante**: Este documento describe cómo la Landing Zone ayuda a cumplir con los requisitos de cumplimiento. No constituye asesoramiento legal ni garantiza el cumplimiento. Las organizaciones deben trabajar con profesionales de cumplimiento calificados para asegurar que se cumplan sus requisitos específicos.

## CIS AWS Foundations Benchmark {#cis-aws-foundations-benchmark}

La Landing Zone implementa controles alineados con el CIS AWS Foundations Benchmark v1.5.0.

### Controles de IAM {#controles-iam-cis}

| Control CIS | Descripción | Implementación en la Landing Zone | Estado |
|-------------|-------------|----------------------------|--------|
| 1.4 | Asegurar que no existan claves de acceso para el usuario root | Cuenta root monitoreada vía regla de Config | Implementado |
| 1.5 | Asegurar que MFA esté habilitado para el usuario root | Requiere verificación manual | Manual |
| 1.6 | Asegurar que MFA de hardware esté habilitado para el usuario root | Requiere verificación manual | Manual |
| 1.7 | Eliminar el uso del usuario root para tareas administrativas | IAM Identity Center para todo el acceso | Implementado |
| 1.8 | Asegurar que la política de contraseñas de IAM requiera una longitud mínima de 14 | Política de contraseñas de la cuenta configurada | Implementado |
| 1.9 | Asegurar que la política de contraseñas de IAM prevenga la reutilización | Prevención de reutilización: 24 contraseñas | Implementado |
| 1.10 | Asegurar que MFA esté habilitado para todos los usuarios de IAM | Regla de Config: iam-user-mfa-enabled | Implementado |
| 1.12 | Asegurar que las credenciales no utilizadas durante 45 días sean desactivadas | Regla de Config: iam-user-unused-credentials-check | Implementado |
| 1.14 | Asegurar que las claves de acceso se roten cada 90 días | Regla de Config: access-keys-rotated | Implementado |
| 1.16 | Asegurar que las políticas de IAM se adjunten solo a grupos o roles | Regla de Config: iam-user-no-policies-check | Implementado |
| 1.17 | Mantener los detalles de contacto actualizados | Verificación manual en la configuración de la cuenta | Manual |
| 1.18 | Asegurar que la información de contacto de seguridad esté registrada | Verificación manual en la configuración de la cuenta | Manual |
| 1.19 | Asegurar que se utilicen roles de instancia de IAM para el acceso a recursos de AWS | SCP obliga a IMDSv2, fomenta roles de instancia | Implementado |
| 1.20 | Asegurar que se haya creado un rol de soporte | Rol de soporte creado en la cuenta management | Implementado |

### Controles de Registro (Logging) {#controles-registro-cis}

| Control CIS | Descripción | Implementación en la Landing Zone | Estado |
|-------------|-------------|----------------------------|--------|
| 2.1 | Asegurar que CloudTrail esté habilitado en todas las regiones | El trail de organización cubre todas las cuentas | Implementado |
| 2.2 | Asegurar que la validación de archivos de registro de CloudTrail esté habilitada | Validación de archivos de registro habilitada | Implementado |
| 2.3 | Asegurar que la cubeta S3 utilizada para los registros de CloudTrail no sea accesible públicamente | La política de la cubeta deniega el acceso público | Implementado |
| 2.4 | Asegurar que los trails de CloudTrail estén integrados con CloudWatch Logs | Registros de CloudTrail enviados a CloudWatch | Implementado |
| 2.5 | Asegurar que AWS Config esté habilitado en todas las regiones | Config habilitado en toda la organización | Implementado |
| 2.6 | Asegurar que el registro de acceso a la cubeta S3 esté habilitado en la cubeta de CloudTrail | Registro de acceso a S3 habilitado | Implementado |
| 2.7 | Asegurar que los registros de CloudTrail estén cifrados en reposo usando KMS | Cifrado KMS habilitado | Implementado |
| 2.8 | Asegurar que la rotación de las claves KMS creadas por el cliente esté habilitada | Rotación de claves KMS habilitada | Implementado |
| 2.9 | Asegurar que el registro de flujo de VPC esté habilitado en todas las VPCs | VPC Flow Logs habilitado para todas las VPCs | Implementado |

### Controles de Monitoreo {#controles-monitoreo-cis}

| Control CIS | Descripción | Implementación en la Landing Zone | Estado |
|-------------|-------------|----------------------------|--------|
| 3.1 | Asegurar que existan un filtro de métricas y una alarma para llamadas API no autorizadas | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.2 | Asegurar que existan un filtro de métricas y una alarma para inicios de sesión en la Consola sin MFA | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.3 | Asegurar que existan un filtro de métricas y una alarma para el uso del usuario root | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.4 | Asegurar que existan un filtro de métricas y una alarma para cambios en las políticas de IAM | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.5 | Asegurar que existan un filtro de métricas y una alarma para cambios en la configuración de CloudTrail | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.6 | Asegurar que existan un filtro de métricas y una alarma para fallas de autenticación en la Consola | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.7 | Asegurar que existan un filtro de métricas y una alarma para la desactivación o eliminación programada de claves KMS | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.8 | Asegurar que existan un filtro de métricas y una alarma para cambios en la política de cubetas S3 | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.9 | Asegurar que existan un filtro de métricas y una alarma para cambios en la configuración de AWS Config | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.10 | Asegurar que existan un filtro de métricas y una alarma para cambios en los grupos de seguridad | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.11 | Asegurar que existan un filtro de métricas y una alarma para cambios en las NACL | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.12 | Asegurar que existan un filtro de métricas y una alarma para cambios en los gateways de red | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.13 | Asegurar que existan un filtro de métricas y una alarma para cambios en las tablas de rutas | Filtros de métricas de CloudWatch configurados | Implementado |
| 3.14 | Asegurar que existan un filtro de métricas y una alarma para cambios en las VPCs | Filtros de métricas de CloudWatch configurados | Implementado |

### Controles de Redes {#controles-redes-cis}

| Control CIS | Descripción | Implementación en la Landing Zone | Estado |
|-------------|-------------|----------------------------|--------|
| 4.1 | Asegurar que ningún grupo de seguridad permita la entrada desde 0.0.0.0/0 al puerto 22 | Regla de Config: restricted-ssh | Implementado |
| 4.2 | Asegurar que ningún grupo de seguridad permita la entrada desde 0.0.0.0/0 al puerto 3389 | Regla de Config: restricted-common-ports | Implementado |
| 4.3 | Asegurar que el grupo de seguridad por defecto restrinja todo el tráfico | Regla de Config: vpc-default-security-group-closed | Implementado |
| 4.4 | Asegurar que las tablas de enrutamiento para el VPC peering sean de mínimo acceso | Requiere revisión manual | Manual |
| 4.5 | Asegurar que las NACL de red no permitan la entrada desde 0.0.0.0/0 al puerto 22 | Requiere revisión manual | Manual |
| 4.6 | Asegurar que las NACL de red no permitan la entrada desde 0.0.0.0/0 al puerto 3389 | Requiere revisión manual | Manual |

### Controles Adicionales {#controles-adicionales-cis}

| Control CIS | Descripción | Implementación en la Landing Zone | Estado |
|-------------|-------------|----------------------------|--------|
| 5.1 | Asegurar que ninguna NACL permita la entrada desde 0.0.0.0/0 a puertos de administración remota | Reglas de Config para puertos comunes | Implementado |
| 5.2 | Asegurar que AWS Config esté habilitado | Config habilitado en toda la organización | Implementado |
| 5.3 | Asegurar que CloudTrail esté habilitado | Trail de organización habilitado | Implementado |
| 5.4 | Asegurar que GuardDuty esté habilitado | GuardDuty habilitado en todas las cuentas | Implementado |
| 5.5 | Asegurar que Security Hub esté habilitado | Security Hub habilitado con el estándar CIS | Implementado |

## Mapeo de Controles SOC 2 {#mapeo-controles-soc2}

La Landing Zone soporta los Criterios de Servicios de Confianza de SOC 2 a través de varios controles.

### Criterios Comunes (CC) {#criterios-comunes-soc2}

| Control | Servicio de Confianza | Descripción | Implementación en la Landing Zone | Estado |
|---------|---------------|-------------|----------------------------|--------|
| CC6.1 | Seguridad | Controles de acceso lógico y físico | IAM Identity Center, obligación de MFA | Implementado |
| CC6.2 | Seguridad | Registro y autorización previos a la emisión de credenciales | IAM Identity Center con aprovisionamiento SCIM | Implementado |
| CC6.3 | Seguridad | Aprovisionamiento y modificación de credenciales de acceso | Automatizado vía IAM Identity Center | Implementado |
| CC6.6 | Seguridad | Acceso lógico eliminado cuando ya no es necesario | Regla de Config: iam-user-unused-credentials-check | Implementado |
| CC6.7 | Seguridad | Credenciales de acceso restringidas a usuarios autorizados | Conjuntos de permisos con mínimo privilegio | Implementado |
| CC7.2 | Seguridad | Detección de eventos de seguridad | GuardDuty, Security Hub, CloudWatch | Implementado |
| CC7.3 | Seguridad | Incidentes de seguridad identificados y comunicados | Notificaciones SNS, hallazgos de Security Hub | Implementado |
| CC7.4 | Seguridad | Incidentes de seguridad mitigados | Funciones Lambda de auto-remediación | Implementado |
| CC8.1 | Gestión de Cambios | Proceso de gestión de cambios | Terraform IaC con control de versiones | Implementado |

### Criterios de Disponibilidad (A) {#criterios-disponibilidad-soc2}

| Control | Descripción | Implementación en la Landing Zone | Estado |
|---------|-------------|----------------------------|--------|
| A1.1 | Capacidad de procesamiento actual monitoreada | Métricas y alarmas de CloudWatch | Implementado |
| A1.2 | Componentes del sistema protegidos contra factores ambientales | Soporte de arquitectura Multi-AZ | Implementado |
| A1.3 | Procedimientos del plan de recuperación establecidos | Estrategias de respaldo documentadas | Documentado |

### Criterios de Confidencialidad (C) {#criterios-confidencialidad-soc2}

| Control | Descripción | Implementación en la Landing Zone | Estado |
|---------|-------------|----------------------------|--------|
| C1.1 | Información confidencial protegida durante la transmisión | Obligación de TLS, VPC endpoints | Implementado |
| C1.2 | Información confidencial protegida durante el almacenamiento | Cifrado KMS para datos en reposo | Implementado |

## Salvaguardas de HIPAA {#salvaguardas-hipaa}

La Landing Zone soporta las salvaguardas técnicas y administrativas de HIPAA para la Información de Salud Protegida (PHI).

**Nota**: El cumplimiento de HIPAA requiere un Business Associate Agreement (BAA) con AWS. Este mapeo asume que existe un BAA.

### Salvaguardas Técnicas {#salvaguardas-tecnicas-hipaa}

| Salvaguarda | Requisito | Implementación en la Landing Zone | Estado |
|-----------|-------------|----------------------------|--------|
| 164.312(a)(1) | Control de Acceso - Identificación Única de Usuario | IAM Identity Center con identidades únicas | Implementado |
| 164.312(a)(2)(i) | Control de Acceso - Procedimiento de Acceso de Emergencia | Roles IAM de emergencia (break-glass) documentados | Implementado |
| 164.312(a)(2)(iii) | Control de Acceso - Cierre de Sesión Automático | Tiempo de espera de sesión en IAM Identity Center | Implementado |
| 164.312(a)(2)(iv) | Control de Acceso - Cifrado y Descifrado | Cifrado KMS para datos en reposo | Implementado |
| 164.312(b) | Controles de Auditoría | CloudTrail, Config, VPC Flow Logs | Implementado |
| 164.312(c)(1) | Integridad - Mecanismo para autenticar ePHI | Validación de archivos de registro de CloudTrail | Implementado |
| 164.312(d) | Autenticación de Persona o Entidad | Obligación de MFA vía políticas de IAM | Implementado |
| 164.312(e)(1) | Seguridad en la Transmisión - Controles de Integridad | Obligación de TLS 1.2+ | Implementado |
| 164.312(e)(2)(i) | Seguridad en la Transmisión - Cifrado | TLS para datos en tránsito | Implementado |

### Salvaguardas Administrativas {#salvaguardas-administrativas-hipaa}

| Salvaguarda | Requisito | Implementación en la Landing Zone | Estado |
|-----------|-------------|----------------------------|--------|
| 164.308(a)(1)(ii)(B) | Gestión de Riesgos | Hallazgos de Security Hub, alertas de GuardDuty | Implementado |
| 164.308(a)(3)(i) | Procedimiento de Autorización de la Fuerza Laboral | Revisiones de acceso de IAM Identity Center | Manual |
| 164.308(a)(3)(ii)(A) | Autorización y Supervisión | Conjuntos de permisos con mínimo privilegio | Implementado |
| 164.308(a)(3)(ii)(B) | Procedimiento de Autorización de la Fuerza Laboral | Se requieren revisiones de acceso periódicas | Manual |
| 164.308(a)(3)(ii)(C) | Procedimientos de Terminación | Desaprovisionamiento de usuarios en IAM Identity Center | Implementado |
| 164.308(a)(4)(i) | Gestión del Acceso a la Información | Políticas de IAM, SCPs | Implementado |
| 164.308(a)(5)(ii)(C) | Monitoreo de Inicio de Sesión | Eventos de inicio de sesión en la consola de CloudTrail | Implementado |
| 164.308(a)(6)(ii) | Respuesta e Informes | Runbooks de respuesta a incidentes | Documentado |
| 164.308(a)(7)(ii)(A) | Plan de Respaldo de Datos | Estrategias de respaldo documentadas | Documentado |
| 164.308(a)(7)(ii)(B) | Plan de Recuperación ante Desastres | Procedimientos de DR documentados | Documentado |

## Controles PCI-DSS {#controles-pci-dss}

La Landing Zone soporta los requisitos de PCI-DSS para los entornos de datos de titulares de tarjeta (CDE).

**Nota**: El cumplimiento de PCI-DSS requiere una segmentación de red adecuada para aislar el CDE. Este mapeo asume que el CDE se despliega en cuentas/VPCs dedicadas.

### Construir y Mantener una Red Segura {#red-segura-pci}

| Requisito | Descripción | Implementación en la Landing Zone | Estado |
|-------------|-------------|----------------------------|--------|
| 1.1 | Estándares de configuración de firewall | Grupos de seguridad, NACLs documentadas | Implementado |
| 1.2 | Las configuraciones de firewall restringen las conexiones | Denegación por defecto, reglas de permiso explícitas | Implementado |
| 1.3 | Prohibir el acceso público directo entre Internet y el CDE | Subredes privadas, NAT Gateway para la salida | Implementado |
| 1.4 | Instalar software de firewall personal en dispositivos móviles | No aplicable (solo infraestructura) | N/A |
| 2.1 | Cambiar siempre los valores por defecto suministrados por el proveedor | AMIs personalizadas, sin contraseñas por defecto | Implementado |
| 2.2 | Desarrollar estándares de configuración para los componentes del sistema | Estándares de fortalecimiento (hardening) documentados | Documentado |
| 2.3 | Cifrar todo el acceso administrativo que no sea por consola | SSM Session Manager, sin claves SSH | Implementado |
| 2.4 | Mantener un inventario de los componentes del sistema | Inventario de recursos de AWS Config | Implementado |

### Proteger los Datos de los Titulares de Tarjeta {#proteger-datos-pci}

| Requisito | Descripción | Implementación en la Landing Zone | Estado |
|-------------|-------------|----------------------------|--------|
| 3.4 | Hacer que el PAN sea ilegible en cualquier lugar donde se almacene | Cifrado KMS en reposo | Implementado |
| 3.5 | Documentar e implementar procedimientos para proteger las claves | Políticas de claves KMS, rotación habilitada | Implementado |
| 4.1 | Usar criptografía fuerte para la transmisión sobre redes abiertas | Obligación de TLS 1.2+ | Implementado |
| 4.2 | No enviar nunca PANs no protegidos por mensajería de usuario final | Control a nivel de aplicación | N/A |

### Mantener un Programa de Gestión de Vulnerabilidades {#vulnerabilidades-pci}

| Requisito | Descripción | Implementación en la Landing Zone | Estado |
|-------------|-------------|----------------------------|--------|
| 5.1 | Desplegar software antivirus | Inspector para el escaneo de vulnerabilidades | Implementado |
| 6.1 | Establecer un proceso para identificar vulnerabilidades de seguridad | Security Hub, Inspector | Implementado |
| 6.2 | Asegurar que todos los componentes del sistema estén protegidos contra vulnerabilidades conocidas | Gestión de parches vía Systems Manager | Implementado |
| 6.3 | Desarrollar aplicaciones de software seguras | Prácticas de SDLC seguro documentadas | Documentado |

### Implementar Medidas Fuertes de Control de Acceso {#control-acceso-pci}

| Requisito | Descripción | Implementación en la Landing Zone | Estado |
|-------------|-------------|----------------------------|--------|
| 7.1 | Limitar el acceso a los componentes del sistema y a los datos de los titulares de tarjeta | Políticas de IAM, conjuntos de permisos | Implementado |
| 7.2 | Establecer un sistema de control de acceso para los componentes del sistema | RBAC de IAM Identity Center | Implementado |
| 8.1 | Definir e implementar políticas para la identificación de usuarios | Identidades de IAM únicas | Implementado |
| 8.2 | Asegurar una gestión adecuada de la autenticación de usuarios | Obligación de MFA, políticas de contraseñas | Implementado |
| 8.3 | Asegurar todo el acceso administrativo individual que no sea por consola | MFA para todo el acceso administrativo | Implementado |
| 8.5 | No utilizar IDs de grupo, compartidos o genéricos | Se requieren identidades de IAM individuales | Implementado |
| 8.6 | Uso de otros mecanismos de autenticación | MFA vía IAM Identity Center | Implementado |

### Monitorear y Probar las Redes Regularmente {#monitoreo-redes-pci}

| Requisito | Descripción | Implementación en la Landing Zone | Estado |
|-------------|-------------|----------------------------|--------|
| 10.1 | Implementar pistas de auditoría para vincular el acceso a individuos | CloudTrail registra todas las llamadas API | Implementado |
| 10.2 | Implementar pistas de auditoría automatizadas para todos los componentes del sistema | CloudTrail, VPC Flow Logs, Config | Implementado |
| 10.3 | Registrar las entradas de la pista de auditoría para todos los componentes del sistema | CloudTrail captura todos los eventos requeridos | Implementado |
| 10.4 | Sincronizar todos los relojes y horas críticos del sistema | NTP vía opciones DHCP de la VPC | Implementado |
| 10.5 | Asegurar las pistas de auditoría | Registros de CloudTrail cifrados e inmutables | Implementado |
| 10.6 | Revisar los registros y eventos de seguridad | CloudWatch Logs Insights, Security Hub | Implementado |
| 10.7 | Retener el historial de la pista de auditoría durante al menos un año | Políticas de ciclo de vida de S3 para la retención de registros | Implementado |
| 11.1 | Implementar procesos para probar la presencia de puntos de acceso inalámbricos | No aplicable (infraestructura en la nube) | N/A |
| 11.2 | Ejecutar escaneos de vulnerabilidades de red internos y externos | Escaneo de vulnerabilidades de Inspector | Implementado |
| 11.3 | Implementar una metodología de pruebas de penetración | Requiere pruebas de penetración manuales | Manual |
| 11.4 | Usar técnicas de detección/prevención de intrusiones | GuardDuty para la detección de amenazas | Implementado |
| 11.5 | Desplegar el monitoreo de la integridad de los archivos | Config para la detección de cambios en los recursos | Implementado |

### Mantener una Política de Seguridad de la Información {#politica-seguridad-pci}

| Requisito | Descripción | Implementación en la Landing Zone | Estado |
|-------------|-------------|----------------------------|--------|
| 12.1 | Establecer, publicar, mantener y difundir la política de seguridad | Políticas de seguridad documentadas | Documentado |
| 12.3 | Desarrollar políticas de uso para tecnologías críticas | Se requieren políticas de uso aceptable | Manual |
| 12.4 | Asegurar que la política de seguridad defina claramente las responsabilidades de seguridad de la información | Matriz RACI documentada | Documentado |
| 12.10 | Implementar un plan de respuesta a incidentes | Runbooks de respuesta a incidentes | Documentado |

## Guía de Recolección de Evidencias {#guia-recoleccion-evidencias}

### Qué Evidencias Recolectar {#que-evidencias-recolectar}

Para las auditorías de cumplimiento, recolecte los siguientes tipos de evidencias:

#### Evidencias de Configuración {#evidencias-configuracion}

- **Estado de Terraform**: Demuestra la infraestructura como código.
- **Instantáneas (Snapshots) de AWS Config**: Configuración de los recursos en un momento dado.
- **Hallazgos de Security Hub**: Estado de cumplimiento para los estándares habilitados.
- **Documentos de Política de IAM**: Configuraciones de control de acceso.
- **Documentos de SCP**: Guardrails a nivel de organización.

#### Evidencias de Actividad {#evidencias-actividad}

- **Registros de CloudTrail**: Actividad de la API para el período de tiempo especificado.
- **VPC Flow Logs**: Tráfico de red para el período de tiempo especificado.
- **Registros de CloudWatch**: Registros de aplicaciones y del sistema.
- **Hallazgos de GuardDuty**: Amenazas de seguridad detectadas.
- **Hallazgos de Access Analyzer**: Acceso no intencionado a recursos.

#### Evidencias de Cumplimiento {#evidencias-cumplimiento-audit}

- **Informes de Cumplimiento de Reglas de Config**: Estado de cumplimiento a lo largo del tiempo.
- **Informes de Cumplimiento de Security Hub**: Estándares CIS, PCI-DSS, HIPAA.
- **Informes de Cumplimiento de Parches**: Estado de parches de Systems Manager.
- **Informes de Escaneo de Vulnerabilidades**: Hallazgos de Inspector.

### Dónde se Almacenan las Evidencias {#donde-almacenar-evidencias}

| Tipo de Evidencia | Ubicación de Almacenamiento | Período de Retención |
|---------------|------------------|------------------|
| Registros de CloudTrail | S3: `log-archive-cloudtrail-<account-id>` | 7 años |
| VPC Flow Logs | S3: `log-archive-vpcflowlogs-<account-id>` | 1 año |
| Instantáneas de Config | S3: `log-archive-config-<account-id>` | 7 años |
| Hallazgos de GuardDuty | Security Hub (Cuenta de Security) | 90 días |
| Hallazgos de Security Hub | Security Hub (Cuenta de Security) | 90 días |
| Registros de CloudWatch | CloudWatch Logs (por cuenta) | 1 año |
| Hallazgos de Access Analyzer | Access Analyzer (Cuenta de Security) | 90 días |

### Recolección Automatizada de Evidencias {#recoleccion-automatizada-evidencias}

Utilice los siguientes scripts para recolectar evidencias para las auditorías:

```bash
# Export CloudTrail logs for date range
aws s3 sync s3://log-archive-cloudtrail-<account-id>/AWSLogs/ \
  ./evidence/cloudtrail/ \
  --exclude "*" \
  --include "*2024/01/*"

# Export Config compliance report
aws configservice describe-compliance-by-config-rule \
  --output json > evidence/config-compliance.json

# Export Security Hub findings
aws securityhub get-findings \
  --filters '{"ComplianceStatus":[{"Value":"FAILED","Comparison":"EQUALS"}]}' \
  --output json > evidence/securityhub-findings.json

# Export IAM credential report
aws iam generate-credential-report
aws iam get-credential-report \
  --output text --query 'Content' | base64 -d > evidence/iam-credentials.csv
```

## Lista de Verificación para la Preparación de Auditorías {#preparacion-auditorias}

### Tareas Pre-Auditoría (4-6 semanas antes) {#tareas-pre-auditoria}

- [ ] Revisar y actualizar las políticas y procedimientos de seguridad.
- [ ] Ejecutar informes de cumplimiento de Security Hub para todos los estándares habilitados.
- [ ] Revisar y remediar los hallazgos de Security Hub de severidad alta/crítica.
- [ ] Verificar que CloudTrail esté registrando en la cubeta S3 correcta.
- [ ] Verificar que Config esté registrando todos los tipos de recursos requeridos.
- [ ] Revisar los usuarios de IAM y eliminar las cuentas no utilizadas.
- [ ] Revisar las claves de acceso de IAM y rotarlas si es necesario.
- [ ] Revisar el estado de MFA para todos los usuarios privilegiados.
- [ ] Exportar informes de cumplimiento para el período de tiempo requerido.
- [ ] Preparar diagramas de arquitectura (red, seguridad, flujo de datos).
- [ ] Documentar cualquier excepción o control compensatorio.
- [ ] Revisar y actualizar los runbooks de respuesta a incidentes.
- [ ] Verificar los procedimientos de respaldo y recuperación ante desastres.

### Requisitos de Documentación {#requisitos-documentacion}

Prepare la siguiente documentación para los auditores:

#### Documentación de Arquitectura {#documentacion-arquitectura}

- [ ] Diagrama de arquitectura de red.
- [ ] Diagrama de arquitectura de seguridad.
- [ ] Diagramas de flujo de datos.
- [ ] Estructura de cuentas y jerarquía de OUs.
- [ ] Matriz de conjuntos de permisos de IAM Identity Center.

#### Documentación de Políticas {#documentacion-politicas-audit}

- [ ] Política de seguridad de la información.
- [ ] Política de respuesta a incidentes.
- [ ] Política de control de acceso.
- [ ] Política de gestión de cambios.
- [ ] Política de clasificación de datos.
- [ ] Política de uso aceptable.

#### Documentación Operativa {#documentacion-operativa}

- [ ] Runbooks para operaciones comunes.
- [ ] Procedimientos de respuesta a incidentes.
- [ ] Procedimientos de recuperación ante desastres.
- [ ] Procedimientos de respaldo y restauración.
- [ ] Procedimientos de gestión de parches.

#### Documentación de Cumplimiento {#documentacion-cumplimiento-audit}

- [ ] Evaluación de riesgos.
- [ ] Matriz de controles (mapeo del marco de trabajo a la implementación).
- [ ] Documentación de excepciones.
- [ ] Resultados de las pruebas de penetración (si aplica).
- [ ] Resultados de los escaneos de vulnerabilidades.

### Aprovisionamiento de Acceso para Auditores {#acceso-auditores}

#### Acceso de Solo Lectura {#acceso-solo-lectura-audit}

Cree un conjunto de permisos de IAM Identity Center dedicado para los auditores:

```hcl
# SecurityAuditor permission set
resource "aws_ssoadmin_permission_set" "security_auditor" {
  name             = "SecurityAuditor"
  description      = "Read-only access for security auditors"
  instance_arn     = aws_ssoadmin_instance.main.arn
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "security_audit" {
  instance_arn       = aws_ssoadmin_instance.main.arn
  permission_set_arn = aws_ssoadmin_permission_set.security_auditor.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_ssoadmin_managed_policy_attachment" "view_only" {
  instance_arn       = aws_ssoadmin_instance.main.arn
  permission_set_arn = aws_ssoadmin_permission_set.security_auditor.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}
```

#### Acceso a las Evidencias {#acceso-evidencias}

Otorgue a los auditores acceso a las cubetas S3 de evidencias:

```hcl
# S3 bucket policy for auditor access
data "aws_iam_policy_document" "auditor_evidence_access" {
  statement {
    sid    = "AuditorReadAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.auditor_role.arn]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.cloudtrail_logs.arn,
      "${aws_s3_bucket.cloudtrail_logs.arn}/*"
    ]
  }
}
```

#### Acceso Limitado en el Tiempo {#acceso-limitado-tiempo}

Utilice credenciales temporales con expiración:

```bash
# Create temporary credentials for auditor (12 hours)
aws sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/AuditorRole \
  --role-session-name audit-session-2024-01 \
  --duration-seconds 43200
```

### Durante la Auditoría {#durante-auditoria}

- [ ] Proporcionar a los auditores las credenciales de acceso.
- [ ] Programar la reunión de inicio (kickoff) para revisar el alcance.
- [ ] Proporcionar acceso al repositorio de documentación.
- [ ] Asignar un punto de contacto para las preguntas de los auditores.
- [ ] Rastrear las solicitudes y respuestas de los auditores.
- [ ] Documentar cualquier hallazgo u observación.
- [ ] Programar reuniones diarias de seguimiento con el equipo de auditoría.

### Post-Auditoría {#post-auditoria}

- [ ] Revisar los hallazgos y recomendaciones de la auditoría.
- [ ] Crear un plan de remediación para los hallazgos.
- [ ] Actualizar la documentación basada en el feedback.
- [ ] Implementar mejoras en los procesos.
- [ ] Programar una auditoría de seguimiento (si es necesario).

## Cumplimiento Continuo {#cumplimiento-continuo}

### Reglas de AWS Config para el Cumplimiento {#reglas-config-cumplimiento}

La Landing Zone despliega reglas de Config que monitorean continuamente el cumplimiento:

#### Reglas del Benchmark CIS {#reglas-cis}

```hcl
# Root account MFA
aws_config_config_rule.root_account_mfa_enabled

# IAM password policy
aws_config_config_rule.iam_password_policy

# CloudTrail enabled
aws_config_config_rule.cloudtrail_enabled

# S3 bucket public access
aws_config_config_rule.s3_bucket_public_read_prohibited
aws_config_config_rule.s3_bucket_public_write_prohibited

# Security group rules
aws_config_config_rule.restricted_ssh
aws_config_config_rule.restricted_rdp
```

#### Reglas de Cumplimiento Personalizadas {#reglas-personalizadas}

```hcl
# Require encryption for EBS volumes
aws_config_config_rule.encrypted_volumes

# Require VPC Flow Logs
aws_config_config_rule.vpc_flow_logs_enabled

# Require IMDSv2
aws_config_config_rule.ec2_imdsv2_check
```

### Estándares de Security Hub {#estandares-security-hub}

Security Hub evalúa continuamente el cumplimiento con los estándares habilitados:

#### Estándares Habilitados {#estandares-habilitados}

- **CIS AWS Foundations Benchmark v1.4.0**: 43 controles.
- **AWS Foundational Security Best Practices v1.0.0**: más de 50 controles.
- **PCI DSS v3.2.1**: más de 40 controles (opcional).

#### Puntuación de Cumplimiento {#puntuacion-cumplimiento}

Security Hub proporciona una puntuación de cumplimiento para cada estándar:

```
CIS AWS Foundations Benchmark: 87% (38/43 controles pasando)
AWS Foundational Security Best Practices: 92% (46/50 controles pasando)
```

#### Supresión de Hallazgos {#supresion-hallazgos}

Para riesgos aceptados o controles compensatorios, suprima los hallazgos:

```bash
# Suppress a specific finding
aws securityhub update-findings \
  --filters '{"Id":[{"Value":"arn:aws:securityhub:...","Comparison":"EQUALS"}]}' \
  --note '{"Text":"Accepted risk - compensating control in place","UpdatedBy":"security-team"}' \
  --workflow '{"Status":"SUPPRESSED"}'
```

### Remediación Automatizada {#remediacion-automatizada}

La Landing Zone incluye la remediación automatizada para violaciones de cumplimiento comunes:

#### Funciones Lambda de Auto-Remediación {#lambda-auto-remediacion}

```hcl
# Remediate non-compliant S3 buckets
module "s3_remediation" {
  source = "../modules/auto-remediation"
  
  rule_name    = "s3-bucket-public-read-prohibited"
  lambda_function = "remediate-s3-public-access"
}

# Remediate security group violations
module "sg_remediation" {
  source = "../modules/auto-remediation"
  
  rule_name    = "restricted-ssh"
  lambda_function = "remediate-security-group-ssh"
}
```

#### Flujo de Trabajo de Remediación {#flujo-remediacion}

1. La regla de Config detecta el incumplimiento.
2. La regla de EventBridge activa la función Lambda.
3. La función Lambda remedia el problema.
4. Se envía una notificación SNS al equipo de seguridad.
5. Se actualiza el hallazgo de Security Hub.

### Dashboards de Cumplimiento {#dashboards-cumplimiento}

#### Dashboard de Security Hub {#dashboard-security-hub}

Vea el estado de cumplimiento en todas las cuentas:

```
Consola de AWS → Security Hub → Resumen → Estándares de seguridad
```

#### Dashboard de CloudWatch Personalizado {#dashboard-cloudwatch-cumplimiento}

Cree dashboards personalizados para las métricas de cumplimiento:

```hcl
resource "aws_cloudwatch_dashboard" "compliance" {
  dashboard_name = "compliance-overview"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/Config", "ComplianceScore", { stat = "Average" }]
          ]
          title = "Config Compliance Score"
        }
      }
    ]
  })
}
```

### Informes de Cumplimiento {#informes-cumplimiento-continuo}

#### Informes de Cumplimiento Semanales {#informes-semanales}

Informes semanales automatizados enviados al equipo de seguridad:

```bash
# Generate weekly compliance report
aws securityhub get-findings \
  --filters '{"ComplianceStatus":[{"Value":"FAILED","Comparison":"EQUALS"}]}' \
  --max-results 100 | \
  jq -r '.Findings[] | [.Title, .Severity.Label, .Resources[0].Id] | @csv' > \
  weekly-compliance-report.csv
```

#### Resumen Ejecutivo Mensual {#resumen-ejecutivo-mensual}

Métricas de cumplimiento de alto nivel para la dirección:

- Puntuación de cumplimiento general por marco de trabajo.
- Análisis de tendencias (mejorando/empeorando).
- Top 5 de hallazgos recurrentes.
- Velocidad de remediación.
- Hallazgos de severidad alta/crítica abiertos.

## Referencias {#referencias-cumplimiento}

- [CIS AWS Foundations Benchmark v1.5.0](https://www.cisecurity.org/benchmark/amazon_web_services)
- [Guía del Usuario de AWS Security Hub](https://docs.aws.amazon.com/securityhub/latest/userguide/)
- [Guía del Desarrollador de AWS Config](https://docs.aws.amazon.com/config/latest/developerguide/)
- [Programas de Cumplimiento de AWS](https://aws.amazon.com/compliance/programs/)
- [HIPAA en AWS](https://aws.amazon.com/compliance/hipaa-compliance/)
- [PCI DSS en AWS](https://aws.amazon.com/compliance/pci-dss-level-1-faqs/)
- [SOC 2 en AWS](https://aws.amazon.com/compliance/soc-faqs/)
