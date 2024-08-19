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

.PHONY: scan
scan:
	@echo "Scanning Docker image for vulnerabilities..."
	trivy image $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

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

.PHONY: helm-deploy
helm-deploy:
	@echo "Deploying with Helm..."
	helm upgrade --install liferay-interview-challenge ./liferay-interview-challenge-chart -f ./liferay-interview-challenge-chart/values-$(ENV).yaml

.PHONY: helm-rollback
helm-rollback:
	@echo "Rolling back with Helm..."
	helm rollback liferay-interview-challenge

.PHONY: helm-uninstall
helm-uninstall:
	@echo "Uninstalling with Helm..."
	helm uninstall liferay-interview-challenge

.PHONY: deploy-monitoring
deploy-monitoring:
	@echo "Deploying Prometheus and Grafana..."
	kubectl apply -f monitoring/prometheus/
	kubectl apply -f monitoring/grafana/

.PHONY: start-all
start-all: build push deploy deploy-monitoring show-urls

.PHONY: show-urls
show-urls:
	@sleep 5 # Aguarde alguns segundos para garantir que os serviços estejam prontos
	@echo "Fetching the Minikube IP and NodePorts..."
	MINIKUBE_IP=$(shell minikube ip)
	APP_PORT=$(shell kubectl get svc/app-service -o jsonpath='{.spec.ports[0].nodePort}')
	GRAFANA_PORT=$(shell kubectl get svc/grafana-service -o jsonpath='{.spec.ports[0].nodePort}')
	PROMETHEUS_PORT=$(shell kubectl get svc/prometheus-service -o jsonpath='{.spec.ports[0].nodePort}')
	@echo "Application is running at: http://$(MINIKUBE_IP):$(APP_PORT)"
	@echo "Grafana is running at: http://$(MINIKUBE_IP):$(GRAFANA_PORT)"
	@echo "Prometheus is running at: http://$(MINIKUBE_IP):$(PROMETHEUS_PORT)"
	@echo "Note: Please run 'minikube tunnel' in a separate terminal to expose the services if they are not accessible."
