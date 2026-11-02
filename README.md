# IN3101 Lab 02 — Library REST API

A Spring Boot REST API for managing books, prepared for IN3101 Enterprise Application Development Lab Sheet 02.

> **Database note:** The lab sheet specifies MySQL. At the user's request, this checkout is configured for the available Microsoft SQL Server instance using Windows integrated authentication. See [Database setup](#database-setup). Confirm this substitution is acceptable for submission if the marking rubric requires MySQL specifically.

## Features

- CRUD endpoints for library books (`/api/books`)
- Spring Data JPA persistence
- Bean Validation for required fields and non-negative prices
- OpenAPI documentation and Swagger UI
- Postman collection for the required test sequence

## Technology

| Component | Version |
|---|---|
| Java | 21 |
| Spring Boot | 3.5.16 |
| Microsoft JDBC Driver | 13.6.0 |
| Springdoc OpenAPI | 2.10.0 |
| Maven | 3.9+ |

## Repository structure

```text
.
├── database/
│   └── create-library-db.sql
├── postman/
│   └── IN3101-Lab02-Book-API.postman_collection.json
├── scripts/
│   ├── run-local.ps1
├── src/main/java/lk/ac/mrt/fit/library_api/
│   ├── controller/BookController.java
│   ├── model/Book.java
│   ├── repository/BookRepository.java
│   ├── service/BookService.java
│   └── LibraryApiApplication.java
├── src/main/resources/application.properties
├── .gitignore
└── pom.xml
```

## Prerequisites

- JDK 21
- Maven 3.9+
- Microsoft SQL Server reachable from this machine
- Postman Desktop (for the lab test evidence)

## Database setup

Open `database/create-library-db.sql` in SSMS and execute it. The script creates `library_db` only when it does not exist; it does not drop or reset databases. Hibernate creates or updates the `book` table when the application starts.

The default JDBC URL targets `localhost:1434`, uses encryption with a trusted local certificate, and enables Windows integrated authentication. Change `DB_URL` for a different SQL Server host or port. No password or login is stored in the repository.

The Microsoft JDBC integrated-authentication DLL is obtained by the local run script from the official Microsoft JDBC driver archive, extracted under the ignored `target/` directory, and added to the current PowerShell process's PATH. No system PATH setting is changed.

## Run locally

From the repository directory in PowerShell:

```powershell
.\scripts\run-local.ps1
```

The API listens on port `8080` by default. To use another HTTP port:

```powershell
$env:SERVER_PORT = "8081"
.\scripts\run-local.ps1
```

## API reference

| Method | Endpoint | Success response |
|---|---|---|
| `GET` | `/api/books` | `200 OK` with all books |
| `GET` | `/api/books/{id}` | `200 OK`; `404 Not Found` when absent |
| `POST` | `/api/books` | `201 Created` with generated ID |
| `PUT` | `/api/books/{id}` | `200 OK`; `404 Not Found` when absent |
| `DELETE` | `/api/books/{id}` | `204 No Content`; `404 Not Found` when absent |

`title` and `author` are required. `price` must be zero or greater. Invalid request bodies return `400 Bad Request`.

### Example request body

```json
{
  "title": "Clean Code",
  "author": "Robert C. Martin",
  "isbn": "9780132350884",
  "price": 4500.00
}
```

## API documentation

When the service is running:

- Swagger UI: <http://localhost:8080/swagger-ui.html>
- OpenAPI JSON: <http://localhost:8080/v3/api-docs>

The create-book operation documents its `201 Created` and `400 Bad Request` responses.

## Postman verification

Import `postman/IN3101-Lab02-Book-API.postman_collection.json` into Postman. The requests cover book creation, listing, retrieval, update, deletion, deleted-record lookup, and blank-title validation. The collection is configured for student index `234235L`.
## Configuration

| Variable | Default | Purpose |
|---|---|---|
| `SERVER_PORT` | `8080` | API HTTP port |
| `DB_URL` | `jdbc:sqlserver://localhost:1434;databaseName=library_db;...` | JDBC connection URL |
| `DB_USERNAME` | empty | Optional SQL login username |
| `DB_PASSWORD` | empty | Optional SQL login password |

The checked-in configuration uses Windows integrated authentication. Keep local credentials out of Git if you change it to SQL authentication.

## Student

- **Name:** W.M.D.N.Wijerathne
- **Index:** 234235L
- **Repository:** [Dhanujaya738/Lab-Exercise](https://github.com/Dhanujaya738/Lab-Exercise)