# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Docker-based PostgreSQL development environment with database normalization examples (1NF to 3NF).

## Common Commands

### Start/Stop Database

```sh
# Start containers (PostgreSQL + Adminer)
docker compose up -d

# Stop containers
docker compose down
```

### Connect to PostgreSQL

```sh
docker exec -it ps psql -U test test
```

## Connection Details

- **Database**: test
- **User**: test
- **Password**: test
- **Port**: 5432 (not exposed in compose.yaml by default)
- **Adminer UI**: http://localhost:8080

## Project Structure

- `compose.yaml` - Docker Compose configuration for PostgreSQL 15 and Adminer
- `seikika/` - Database normalization tutorial with SQL scripts demonstrating progression from 1NF to 3NF
