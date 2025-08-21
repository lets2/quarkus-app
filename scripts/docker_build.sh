#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME_WITH_TAG=$1
IMAGE_NAME_WITH_LATEST_TAG=$2

echo "======================================================================================================="
echo "[DOCKER] 🚢🟦 Build da imagem de container: $IMAGE_NAME_WITH_TAG and $IMAGE_NAME_WITH_LATEST_TAG"
echo "-------------------------------------------------------------------------------------------------------"

docker build -t "$IMAGE_NAME_WITH_TAG" -t "$IMAGE_NAME_WITH_LATEST_TAG" .
