#!/usr/bin/env bash
set -euo pipefail

echo "======================================================================================================="
echo "[MINIKUBE] 🔍 Verificando status do cluster..."
echo "-------------------------------------------------------------------------------------------------------"

if minikube status --output json \
     | jq -e '.Host == "Running" and .Kubelet == "Running" and .APIServer == "Running"' \
     >/dev/null
then
  echo "[MINIKUBE] ✅ Cluster ativo e funcionando corretamente"
  exit 0
else
  echo "[MINIKUBE] ❌ Problema detectado no cluster"
  echo "Detalhes do status atual:"
  minikube status
  exit 1
fi

# set -euo pipefail


# echo "====================================================="
# echo "[MINIKUBE] 🔍 Verificando status do cluster..."
# echo "-----------------------------------------------------"



# minikube status --output json | jq -e '.Host == "Running" and .Kubelet == "Running" and .APIServer == "Running"' >/dev/null \
#   || { echo "Minikube não esta funcionando corretamente"; exit 1; }
