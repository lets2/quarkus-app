#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-}"; IMAGE_REF="${2:-}"

echo "======================================================================================================="
echo "[K8S] 🚀📦 Deploy para o  ambiente $ENVIRONMENT com imagem $IMAGE_REF"
echo "-------------------------------------------------------------------------------------------------------"

[ -z "$ENVIRONMENT" -o -z "$IMAGE_REF" ] && { echo "uso: $0 <des|prd> <image_ref>"; exit 1; }

tmp_dir=$(mktemp -d)

# copia toda a pasta k8s mantendo a estrutura
cp -r k8s/* "$tmp_dir/"

pushd "$tmp_dir/overlays/${ENVIRONMENT}" > /dev/null

kustomize edit set image app-image="${IMAGE_REF}"
kubectl create ns des 2>/dev/null || true
kustomize build . | kubectl apply -f -

popd > /dev/null

rm -rf "$tmp_dir"

kubectl -n "${ENVIRONMENT}" rollout status deploy/quarkus-app-${ENVIRONMENT} --timeout=180s
