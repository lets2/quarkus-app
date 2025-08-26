#!/usr/bin/env bash
set -euo pipefail

CLUSTER="${1-}"; IMAGE_REF="${2-}"

echo "======================================================================================================="
echo "[MINIKUBE] ⌛ Carregando imagem $IMAGE_REF no cluster $CLUSTER ..."
echo "-------------------------------------------------------------------------------------------------------"

[ -z "$CLUSTER" -o -z "$IMAGE_REF" ] && { echo "uso: $0 <des|prd> <image_ref>"; exit 1; }

minikube -p "${CLUSTER}" image load "$IMAGE_REF"
