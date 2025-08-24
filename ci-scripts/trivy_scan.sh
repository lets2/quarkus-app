#!/usr/bin/env bash
set -euo pipefail

IMAGE_REF="${1:-}"

echo "======================================================================================================="
echo "[TRIVY] 👀 Scan de vulnerabilidade na imagem de container usando Aquasec trivy 👀"
echo "-------------------------------------------------------------------------------------------------------"

[ -z "$IMAGE_REF" ] && { echo "uso: $0 <image_ref>"; exit 1; }

docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    aquasec/trivy:latest image --exit-code 0 --ignore-unfixed --severity HIGH,CRITICAL,MEDIUM  ${IMAGE_REF} 


echo "======================================================================================================="
echo "[TRIVY] 👀 Analise de misconfiguration nos manifests k8s usando Aquasec trivy 👀"
echo "-------------------------------------------------------------------------------------------------------"

tmp_dir="$(mktemp -d)"

trap 'rm -rf "$tmp_dir"' EXIT

cp -r k8s/* "$tmp_dir/"

docker run --rm -v "$tmp_dir":/k8s aquasec/trivy:0.65.0 config \
    --exit-code 0 \
    --severity HIGH,CRITICAL,MEDIUM \
    /k8s
