#!/usr/bin/env bash
set -euo pipefail

IMAGE_REF="${1-}"

echo "======================================================================================================="
echo "[MINIKUBE] ⌛ Carregando imagem $IMAGE_REF ..."
echo "-------------------------------------------------------------------------------------------------------"

minikube image load "$IMAGE_REF"
