# Variáveis para definir comandos reutilizáveis
DOCKER_IMAGE_NAME = victoralmeida92/liferay-challenge
DOCKER_IMAGE_TAG = v1.1
KUBERNETES_DEPLOYMENT_DIR = deployments/
HELM_CHART_DIR = liferay-challenge

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
deploy: deploy-dev

.PHONY: deploy-prd
deploy-prd:
	@echo "Deploying to Kubernetes - Production..."
	helm upgrade --install liferay-challenge $(HELM_CHART_DIR) -f $(HELM_CHART_DIR)/values-prd.yaml --set image.tag=$(DOCKER_IMAGE_TAG)

.PHONY: deploy-stg
deploy-stg:
	@echo "Deploying to Kubernetes - Staging..."
	helm upgrade --install liferay-challenge $(HELM_CHART_DIR) -f $(HELM_CHART_DIR)/values-stg.yaml --set image.tag=$(DOCKER_IMAGE_TAG)

.PHONY: deploy-dev
deploy-dev:
	@echo "Deploying to Kubernetes - Development..."
	helm upgrade --install liferay-challenge $(HELM_CHART_DIR) -f $(HELM_CHART_DIR)/values-dev.yaml --set image.tag=$(DOCKER_IMAGE_TAG)

.PHONY: clean
clean:
	@echo "Cleaning up resources..."
	docker-compose down
	kubectl delete -f $(KUBERNETES_DEPLOYMENT_DIR)
	helm uninstall liferay-challenge

.PHONY: up
up:
	@echo "Starting Docker Compose..."
	docker-compose up --build

.PHONY: stop
stop:
	@echo "Stopping Docker Compose..."
	docker-compose down
