# Construcción y automatización de una infraestructura de red mediante Terraform

**Materia:** Automatización de Infraestructura Digital II  
**Alumno:** Juan Carlos Rafael Rodríguez Blanco  
**Plataforma:** Debian/WSL + Docker  
**Herramienta principal:** Terraform

## 1. Introducción

La Infraestructura como Código (IaC) permite definir y administrar una infraestructura mediante archivos de configuración en lugar de realizar manualmente cada configuración. En esta práctica se utiliza Terraform para definir una infraestructura de red virtual mediante código, utilizando Docker como plataforma de laboratorio. Esto permite crear, verificar, destruir y reconstruir la infraestructura de manera reproducible.

## 2. Descripción del problema

Una pequeña empresa configura su entorno de desarrollo manualmente, lo que puede provocar errores humanos, configuraciones diferentes entre servidores, dificultad para reproducir el entorno, falta de documentación y dificultad para identificar cambios.

Como solución se implementó una infraestructura mediante Terraform, utilizando una red privada y tres servicios representados mediante contenedores Docker.

## 3. Arquitectura

La infraestructura utiliza la red:

- Red: `10.10.0.0/24`
- Gateway: `10.10.0.1`

Los servicios son:

| Servicio | Contenedor | Dirección IP |
|---|---|---|
| Web | `iac-web` | `10.10.0.10` |
| Aplicación | `iac-app` | `10.10.0.20` |
| Base de datos | `iac-db` | `10.10.0.30` |

La arquitectura completa se encuentra documentada en:

`docs/arquitectura.md`

## 4. Herramientas utilizadas

- Debian/WSL
- Terraform
- Docker
- Docker Compose
- Git
- Bash
- curl
- ping
- Docker CLI

## 5. Descripción de DevOps

DevOps integra prácticas de desarrollo y operaciones con el objetivo de automatizar y mejorar el proceso de creación, implementación y verificación de sistemas.

En esta práctica se aplican principios de DevOps mediante:

- Automatización de la infraestructura.
- Infraestructura como Código.
- Uso de scripts Bash.
- Control de versiones mediante Git.
- Verificación automatizada.
- Reproducibilidad de la infraestructura.

## 6. Ventajas de la automatización

La automatización de infraestructura permite:

- Reducir errores humanos.
- Mantener configuraciones consistentes.
- Reproducir un entorno de forma sencilla.
- Reducir el tiempo necesario para implementar recursos.
- Documentar la infraestructura mediante código.
- Identificar cambios mediante control de versiones.
- Facilitar la reconstrucción del entorno.

## 7. Descripción del código Terraform

El directorio `terraform/` contiene la definición de la infraestructura.

### `main.tf`

Define el proveedor Docker, la red, las imágenes y los contenedores utilizados en el laboratorio.

### `variables.tf`

Define los parámetros utilizados por la infraestructura, como la red, direcciones IP, imágenes y puertos.

### `terraform.tfvars`

Contiene los valores utilizados específicamente para este laboratorio.

### `outputs.tf`

Muestra información importante después de la implementación, como las direcciones IP, el nombre de la red y la URL del servidor web.

## 8. Descripción de los scripts

### `scripts/deploy.sh`

Automatiza el proceso de despliegue ejecutando:

```text
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
