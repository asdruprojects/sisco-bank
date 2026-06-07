# Sisco Bank

Aplicación web para el registro y administración de clientes bancarios (personas naturales y jurídicas), desarrollada con Ruby on Rails, PostgreSQL y Bootstrap.

## Tecnologías

- Ruby 3.3
- Rails 8.1.3
- PostgreSQL 14+
- Bootstrap 5

## Requisitos previos

- Ruby 3.3
- Rails 8.1.3
- PostgreSQL 14+

Verifica tu entorno:

```bash
ruby -v
rails -v
psql --version
```

## Instalación

```bash
git clone https://github.com/asdruprojects/sisco-bank.git
cd sisco_bank
bundle install
```

## Variables de entorno

Copia el archivo de ejemplo:

```bash
cp .env.example .env
```

Edita `.env` con tu usuario de PostgreSQL:

```env
DATABASE_USER=tu_usuario_de_postgres
DATABASE_PASSWORD=tu_contraseña_de_postgres
```

## Base de datos

```bash
rails db:create
rails db:migrate
rails db:seed
```

`db:seed` crea 9 clientes de ejemplo (5 naturales y 4 jurídicos).

## Correr el proyecto

```bash
rails server
```

Abre [http://localhost:3000](http://localhost:3000)

## Funcionalidades

- Crear, consultar, editar y eliminar clientes
- Eliminación lógica (soft delete) — los registros no se borran físicamente
- Soporte para personas naturales (cédula o pasaporte) y jurídicas (RIF)
- Búsqueda por nombre o razón social
- Búsqueda por número de documento
- Filtro por tipo de persona
- API REST con respuestas JSON

## API REST

Base URL: `http://localhost:3000/api/v1`

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/clients` | Listar clientes |
| GET | `/clients/:id` | Ver cliente |
| POST | `/clients` | Crear cliente |
| PUT | `/clients/:id` | Actualizar cliente |
| DELETE | `/clients/:id` | Eliminar cliente (soft delete) |

### Parámetros de búsqueda (GET /clients)

| Parámetro | Descripción |
|-----------|-------------|
| `name` | Buscar por nombre o razón social |
| `document` | Buscar por número de documento |
| `person_type` | Filtrar por `natural` o `juridico` |

### Ejemplo de creación (POST /clients)

```json
{
  "client": {
    "person_type": "natural",
    "email": "jose@gmail.com",
    "phone_primary": "04141234567",
    "natural_person_attributes": {
      "full_name": "José García"
    },
    "documents_attributes": [
      {
        "document_type": "cedula",
        "document_number": "V-12345678",
        "issued_at": "2020-01-01",
        "expires_at": "2030-01-01"
      }
    ]
  }
}
```

## Estructura del proyecto

```
app/
├── controllers/
│   ├── clients_controller.rb         # CRUD web
│   └── api/v1/clients_controller.rb  # API REST
├── models/
│   ├── client.rb                     # Modelo principal
│   ├── document.rb                   # Documentos del cliente
│   ├── natural_person.rb             # Datos persona natural
│   └── legal_entity.rb              # Datos persona jurídica
└── views/
    └── clients/                      # Vistas Bootstrap
```

## Diseño de base de datos

| Tabla | Descripción |
|-------|-------------|
| `clients` | Datos comunes + soft delete |
| `documents` | Documentos del cliente (cédula, pasaporte, RIF) |
| `natural_people` | Nombre completo (persona natural) |
| `legal_entities` | Razón social (persona jurídica) |