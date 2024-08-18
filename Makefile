# Variáveis para definir comandos reutilizáveis
DOCKER_IMAGE_NAME = victoralmeida92/liferay-challenge
DOCKER_IMAGE_TAG = v1.1
KUBERNETES_DEPLOYMENT_DIR = deployments/

# Comandos
.PHONY: build
build:
	@echo "Building Docker image..."
	docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

.PHONY: push
push:
	@echo "Pushing Docker image to Docker Hub..."
	docker push $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

.PHONY: deploy
deploy:
	@echo "Deploying to Kubernetes..."
	kubectl apply -f $(KUBERNETES_DEPLOYMENT_DIR)

.PHONY: clean
clean:
	@echo "Cleaning up resources..."
	docker-compose down
	kubectl delete -f $(KUBERNETES_DEPLOYMENT_DIR)

.PHONY: up
up:
	@echo "Starting Docker Compose..."
	docker-compose up --build

.PHONY: stop
stop:
	@echo "Stopping Docker Compose..."
	docker-compose down
