# Liferay Interview Challenge

## Overview

This project is a TypeScript-based application containerized with Docker and deployed on a Kubernetes cluster. It demonstrates the use of modern infrastructure and deployment practices, focusing on scalability, reliability, and maintainability.

## Table of Contents

- [Project Overview](#overview)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Running Tests](#running-tests)
- [Architecture Overview](#architecture-overview)
- [Deployment](#deployment)
- [Makefile Commands](#makefile-commands)

## Getting Started

To get started with this project, you'll need to clone the repository and set up the development environment.

```bash
git clone https://github.com/yourusername/liferay-interview-challenge.git
cd liferay-interview-challenge
```

## Development Setup

### Prerequisites

Ensure you have the following software installed:

- **Node.js** (v14.x or later)
- **Yarn** (v1.22.x or later)
- **Docker** (v20.x or later)
- **Docker Compose** (v1.29.x or later)
- **Minikube** (v1.33.x or later)

### Installation

1. **Install dependencies:**

    ```bash
    yarn install
    ```

2. **Set up the database:**

    Use Docker Compose to start the MariaDB database.

    ```bash
    docker-compose up db
    ```

3. **Run database migrations:**

    Apply the database migrations using TypeORM.

    ```bash
    yarn typeorm migration:run
    ```

4. **Build and run the application:**

    ```bash
    yarn build
    yarn start
    ```

5. **Access the application:**

    The application will be running at `http://localhost:3000`.

## Running Tests

To run tests for this project, follow these steps:

1. **Set the environment variable for testing:**

    Set the `NODE_ENV` environment variable to `test` to ensure the application uses the test database configuration.

    ```bash
    export NODE_ENV=test
    ```

2. **Run the tests:**

    Use Yarn to execute the tests.

    ```bash
    yarn test
    ```

This will run all the test suites and output the results. Make sure that your application is correctly configured for the test environment to avoid connection issues.

## Architecture Overview

### Project Structure

The project is structured as follows:

```bash
liferay-interview-challenge/
├── src/                        # Application source code
│   ├── controller/             # Controllers
│   ├── entity/                 # Database entities
│   ├── migration/              # Database migrations
│   ├── subscriber/             # Event subscribers
│   ├── index.ts                # Application entry point
│   └── routes.ts               # Application routes
├── dist/                       # Compiled JavaScript files
├── deployments/                # Kubernetes manifests
│   ├── deployment.yaml         # Application deployment
│   ├── mariadb-deployment.yaml # MariaDB deployment
│   ├── mariadb-service.yaml    # MariaDB service
│   └── service.yaml            # Application service
├── monitoring/                 # Monitoring configuration (Prometheus & Grafana)
│   ├── grafana/                # Grafana configuration
│   └── prometheus/             # Prometheus configuration
├── scripts/                    # Utility scripts
├── .gitignore                  # Git ignore file
├── Dockerfile                  # Dockerfile to build the application image
├── docker-compose.yml          # Docker Compose configuration
├── ormconfig.env               # TypeORM configuration
├── package.json                # Node.js dependencies and scripts
├── tsconfig.json               # TypeScript configuration
└── yarn.lock                   # Yarn lockfile
```

### Application Flow

1. **Client Request:** Clients send HTTP requests to the application.
2. **Routing:** The request is routed through `routes.ts` to the appropriate controller.
3. **Controller Logic:** Controllers handle the request, interact with the database through entities, and return the response.
4. **Database Interaction:** TypeORM is used to interact with the MariaDB database.

## Deployment

### Prerequisites

Before deploying, make sure Minikube is started and configured correctly. You can start Minikube using the following command:

```bash
minikube start
```

### Setup and Deployment

The `setup.sh` script will handle building, pushing, deploying the application, and setting up port-forwarding.

1. **Make the script executable:**

    ```bash
    chmod +x scripts/setup.sh
    ```

2. **Run the setup script:**

    ```bash
    bash scripts/setup.sh
    ```

This script will handle building, pushing, deploying the application, and setting up port-forwarding. Once the services are available, it will notify you in the terminal with the following example output:

```bash
Application is running at: http://localhost:8080
Grafana is running at: http://localhost:3000
Prometheus is running at: http://localhost:9090
```

### Cleaning Up

To clean up all resources:

```bash
make clean
```

## Makefile Commands

Below is a list of the `make` commands available in this project, along with a description of what each command does:

1. **`make build`**: Builds the Docker image for the application.

    ```bash
    make build
    ```

2. **`make push`**: Pushes the Docker image to Docker Hub.

    ```bash
    make push
    ```

3. **`make scan`**: Scans the Docker image for vulnerabilities using Trivy.

    ```bash
    make scan
    ```

4. **`make deploy`**: Deploys the application to the Kubernetes cluster using the manifests in the `deployments/` directory.

    ```bash
    make deploy
    ```

5. **`make clean`**: Cleans up all resources, stopping Docker Compose and deleting the Kubernetes deployments.

    ```bash
    make clean
    ```

6. **`make up`**: Starts the application using Docker Compose.

    ```bash
    make up
    ```

7. **`make stop`**: Stops the Docker Compose services.

    ```bash
    make stop
    ```

8. **`make helm-deploy`**: Deploys the application to Kubernetes using Helm.

    ```bash
    make helm-deploy
    ```

9. **`make helm-rollback`**: Rolls back the last Helm deployment.

    ```bash
    make helm-rollback
    ```

10. **`make helm-uninstall`**: Uninstalls the Helm deployment.

    ```bash
    make helm-uninstall
    ```

11. **`make deploy-monitoring`**: Deploys Prometheus and Grafana for monitoring.

    ```bash
    make deploy-monitoring
    ```

12. **`make start-all`**: Builds, pushes, deploys the application, and deploys the monitoring stack.

    ```bash
    make start-all
    ```

13. **`make show-urls`**: Displays the URLs for the application, Grafana, and Prometheus. This command also provides a note to run `minikube tunnel` if the services are not accessible.

    ```bash
    make show-urls
    ```

    ## Continuous Integration

    This project uses GitHub Actions for Continuous Integration (CI). The CI pipeline is triggered automatically on every push to the repository or when a new tag is created following the `v*.*.*` pattern.

    ### Viewing CI Results

    To view the results of the CI pipeline:

    1. Navigate to the **Actions** tab in the GitHub repository.
    2. Look for the workflow run associated with your latest commit or tag.
    3. You should see the jobs for testing, building, and scanning the Docker image. Ensure that all jobs have passed successfully.

    ### Triggering a CI Pipeline with a Tag

    If you want to manually trigger the CI pipeline with a specific version:

    1. Make sure all your changes are committed and pushed to the repository.
    2. Create a new version tag using the following commands:

       ```bash
       git tag v1.1.0
       git push origin v1.1.0
       ```
    3. Check the Actions tab to monitor the CI process and confirm that it runs without errors.
