#!/bin/bash

# Script para iniciar o make start-all e o port-forwarding em três terminais separados

# Função para abrir um novo terminal e executar um comando
open_new_terminal() {
  local command=$1
  if [[ "$OSTYPE" == "darwin"* ]]; then
    osascript -e "tell application \"Terminal\" to do script \"$command\""
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    gnome-terminal -- bash -c "$command; exec bash"
  else
    echo "Sistema operacional não suportado para abrir novos terminais automaticamente."
    exit 1
  fi
}

# Iniciar a construção, push e deployment da aplicação
echo "Iniciando a construção, push e deployment da aplicação..."
make start-all

# Espera de 60 segundos para que os pods estejam online
echo "Aguardando 60 segundos para os pods ficarem online..."
for i in {1..60}; do
  echo -ne "Esperando... $i/60 segundos\r"
  sleep 1
done
echo -ne "\n"

# Verifica se os pods estão no estado "Running"
echo "Verificando o status dos pods..."
kubectl wait --for=condition=Ready pod --all --timeout=120s -n default

# Port-forwarding para o serviço da aplicação
echo "Iniciando o port-forwarding..."
open_new_terminal "kubectl port-forward svc/app-service 8080:80 -n default"

# Port-forwarding para o serviço do Grafana
open_new_terminal "kubectl port-forward svc/grafana-service 3000:80 -n default"

# Port-forwarding para o serviço do Prometheus
open_new_terminal "kubectl port-forward svc/prometheus-service 9090:9090 -n default"

echo "Port-forwarding iniciado. Serviços disponíveis em:"
echo "Aplicação: http://localhost:8080"
echo "Grafana: http://localhost:3000"
echo "Prometheus: http://localhost:9090"
