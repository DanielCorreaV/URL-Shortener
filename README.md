
# SHRTN — URL Shortener Core & Infrastructure Ecosystem

Este repositorio funciona como el **módulo recopilatorio y orquestador central** del sistema de acortamiento de enlaces y analíticas en tiempo real (**SHRTN**). Su propósito principal no es contener la lógica de negocio detallada de cada componente, sino **cimentar la infraestructura global compartida** y servir de monorrepo organizativo para vincular los distintos módulos del ecosistema (los cuales se gestionan y despliegan de forma independiente).

---

## 🏗️ Arquitectura de Directorios

La estructura del proyecto está dividida estratégicamente para separar los recursos globales de las plataformas de microservicios e interfaces web:

```text
C:\CODE PROJECTS\URL-SHORTENER
│   .gitignore
│   .gitmodules
│   README.md             <-- (Este archivo)
│
├───shared                <-- 🚀 NÚCLEO INFRAESTRUCTURA COMPARTIDA
│   └───terraform
│           main.tf       <-- Base de Datos (DynamoDB), Redes y Roles IAM Core
│           outputs.tf
│           providers.tf
│           variables.tf
│
└───modules               <-- Componentes Descentralizados (Repositorios Independientes)
    ├───frontend          
    │   ├───URL-Shortener-front-shorter-redirector
    │   ├───URL-Shortener-front-stats
    │   └───URL-Shortener-init
    │
    └───backend (Lambdas) 
        ├───URL-Shortener-auth
        ├───URL-Shortener-redirector
        ├───URL-Shortener-shortener
        └───URL-Shortener-stats

```

---

## 🎯 El Directorio Crucial: `/shared`

El motor de aprovisionamiento de este repositorio reside en la carpeta `shared/terraform`. A diferencia de los Terraform locales que se encuentran dentro de cada frontend o backend de la carpeta `modules` (orientados solo a su propio despliegue adaptativo), **esta capa cimenta los recursos globales e inmutables** que todos los microservicios necesitan consumir para interoperar de forma segura.

### Componentes Core Aprovisionados en `shared`:

1. **Motores de Persistencia (NoSQL):** Definición y despliegue de las tablas globales en **AWS DynamoDB** para el almacenamiento transaccional de los enlaces acortados, los usuarios del sistema y las trazas históricas de los accesos (`visit_history`).
2. **Políticas de Seguridad y Roles Centrales (IAM):** Creación de los perfiles de ejecución compartidos, garantizando el principio de menor privilegio para que las funciones Lambda del ecosistema puedan interactuar con la base de datos de manera hermética.
3. **Redes y Gobernanza de Proveedores:** Inicialización base del proveedor de AWS y control de variables compartidas.

---

## 📦 Gestión de Módulos (`/modules`)

Cada subcarpeta dentro de `modules` representa un entregable aislado con su propio ciclo de vida, integración continua (GitHub Workflows), configuraciones locales y empaquetado de infraestructura:

* **`frontend/`**: Aloja las SPA (Single Page Applications) construidas con arquitecturas nativas modernas y Tailwind CSS, las cuales se empaquetan en buckets S3 privados y se exponen globalmente mediante distribuciones perimetrales en **AWS CloudFront**.
* **`backend/`**: Contiene los handlers desarrollados bajo entornos de ejecución Node.js que dan vida a la API Serverless mediante **AWS Lambda** y **API Gateway**.

> **Nota de Despliegue:** Al ser módulos desacoplados arquitectónicamente, los archivos de Terraform internos en cada submódulo invocan u obtienen los ARNs y outputs generados previamente por el bloque `/shared`.

---

## 🚀 Flujo de Inicialización del Proyecto

Para desplegar de manera correcta el ecosistema SHRTN, es mandatorio respetar el orden de precedencia de la infraestructura:

### Paso 1: Levantar los cimientos compartidos

Accede a la carpeta raíz de infraestructura e inicializa los recursos troncales (Base de datos y Roles):

```bash
cd shared/terraform
terraform init
terraform apply

```

*Guarda los outputs generados aquí (como los nombres de las tablas de DynamoDB o ARNs de Roles), ya que te serán solicitados por los módulos independientes.*

### Paso 2: Despliegue secuencial de módulos

Una vez construida la base en AWS, se procede a ingresar a cada repositorio de la carpeta `modules` para ejecutar sus despliegues individuales de forma aislada según se requiera actualizar la lógica de negocio o la interfaz de usuario.
