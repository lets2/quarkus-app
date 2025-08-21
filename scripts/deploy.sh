#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-}"; IMAGE_REF="${2:-}"

echo "======================================================================================================="
echo "[K8S] 🚀📦 Deploy para o  ambiente $ENVIRONMENT com imagem $IMAGE_REF"
echo "-------------------------------------------------------------------------------------------------------"

[ -z "$ENVIRONMENT" -o -z "$IMAGE_REF" ] && { echo "uso: $0 <des|prd> <image_ref>"; exit 1; }

OVERLAY="k8s/overlays/${ENVIRONMENT}"

pushd "$OVERLAY" >/dev/null

kustomize edit set image app-image="${IMAGE_REF}"

popd >/dev/null

# kubectl create ns des 2>/dev/null || true
kubectl create namespace "${ENVIRONMENT}" --dry-run=client -o yaml | kubectl apply -f -

kustomize build "$OVERLAY" | kubectl apply -f -

kubectl -n "${ENVIRONMENT}" rollout status deploy/quarkus-app-${ENVIRONMENT} --timeout=180s
