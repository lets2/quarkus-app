#!/usr/bin/env bash
set -euo pipefail

CLUSTER="${1-}"

echo "======================================================================================================="
echo "[MINIKUBE] 🔍 Verificando status do cluster $CLUSTER ..."
echo "-------------------------------------------------------------------------------------------------------"

[ -z "$CLUSTER" ] && { echo "uso: $0 <des|prd>"; exit 1; }

if minikube status -p "${CLUSTER}" --output json \
     | jq -e '.Host == "Running" and .Kubelet == "Running" and .APIServer == "Running"' \
     >/dev/null
then
  echo "[MINIKUBE] ✅ Cluster $CLUSTER ativo e funcionando corretamente"
  exit 0
else
  echo "[MINIKUBE] ❌ Problema detectado no cluster $CLUSTER "
  echo "Detalhes do status atual:"
  minikube status -p "${SCLUSTER}"
  exit 1
fi

# set -euo pipefail


# echo "====================================================="
# echo "[MINIKUBE] 🔍 Verificando status do cluster..."
# echo "-----------------------------------------------------"



# minikube status --output json | jq -e '.Host == "Running" and .Kubelet == "Running" and .APIServer == "Running"' >/dev/null \
#   || { echo "Minikube não esta funcionando corretamente"; exit 1; }
