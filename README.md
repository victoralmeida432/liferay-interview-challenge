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
- [Contributing](#contributing)
- [License](#license)

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

### Docker

To build and push the Docker image:

```bash
make build
make push
```

### Kubernetes

To deploy the application to a Kubernetes cluster:

```bash
make deploy
```

### Cleaning Up

To clean up all resources:

```bash
make clean
```

## Contributing

We welcome contributions from the community! Please follow these steps to contribute:

1. **Fork the repository** on GitHub.
2. **Create a new branch** for your feature or bugfix.
3. **Make your changes** and commit them with descriptive messages.
4. **Push your changes** to your fork.
5. **Create a Pull Request** against the `main` branch of the original repository.

### Code Style

Please ensure your code adheres to the existing code style. We use ESLint and Prettier to enforce consistency:

```bash
yarn lint
yarn format
```

### Reporting Issues

If you find any issues, please open an issue on GitHub with detailed information so we can address it.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
