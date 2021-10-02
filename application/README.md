# Demo - Knote-js dockerized application

## Introduction
This repository contains a architecture for a Knote-js - a Node application.

## Requirements

The system components are as follows:

1. **Application:** A statically built Node.js app which includes both frontend and backend functionalities.
2. **MongoDB:** A mongodb service that operates as a persistence layer for the server
3. **Minio:** a high-performance, S3 compatible object storage.

The 3 above services need to communicate to each other, and be orchestrated via docker-compose.

## Local Setup

### Prerequisite
- Tools: [Docker](https://docs.docker.com/get-docker/), [docker-compose](https://docs.docker.com/compose/install/)

### Start Applications

```bash
$ cd ./application
$ docker-compose up -d
```

### Check logs

```bash
$ docker-compose logs -f
```

**NOTE**:
- Server would be running at: `http://localhost:3000/`

### Stop Applications

```bash
$ docker-compose down 
```
