# WordPress Docker Setup

A reusable Docker setup for deploying WordPress quickly and consistently. This repository allows you to spin up isolated WordPress environments for development, testing, or repeated project setups with minimal effort.
This repository provides a ready-to-use Docker configuration that installs WordPress together with a database.  
Its purpose is to:

---

## Table of Contents

1. [Description](#description)  
2. [Features](#features)  
3. [Quickstart](#quickstart)  
4. [Installation](#installation)  
5. [Usage](#usage)   

---

- Offer a **simple, consistent, and repeatable** WordPress setup  
- Allow the configuration of multiple independent WordPress instances  
- Reduce setup time by automating environment preparation  

**Contents of the repository include:**

- `docker-compose.yml` — WordPress and database containers  
- `.env.template` — Template with all configurable environment variables  
- Startup instructions for local development or server deployment  

---

## Features

- Quick WordPress deployment using Docker  
- Fully configurable via `.env`  
- Easily replicable for multiple projects  
- Suitable for local development or server environments  
- No manual database setup required  

---

## Quickstart

### Prerequirements

- Docker installed  
  (Download: https://docs.docker.com/get-docker/)  
- Docker Compose v2+  
- A copy of the `.env` file

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd <project-folder>
   ```

2. Copy the environment file:
   ```bash
   cp .env.template .env
   ```

3. Fill in the required values inside `.env`.
   Adjust values such as:
   - `WORDPRESS_DB_NAME`
   - `WORDPRESS_DB_USER`
   - `WORDPRESS_DB_PASSWORD`
   - `WORDPRESS_PORT`

4. Start the container:
     ```bash
     docker compose up -d
     ```

Access your WordPress instance in the browser and complete the installation wizard.

---

## Usage

This section explains configuration options and how to customize the setup for different outcomes.

### Adjusting Configuration

All customizable values are located inside the `.env` file.

#### Change Database Credentials

```env
WORDPRESS_DB_NAME=your_database
WORDPRESS_DB_USER=your_user
WORDPRESS_DB_PASSWORD=your_password
```

WordPress will then be available at:

```
http://localhost:8080
```

### Container Management

Stop containers:
```bash
docker compose down
```

View logs:
```bash
docker compose logs -f
```

Restart:
```bash
docker compose restart
```