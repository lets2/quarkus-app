#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-}"

echo "======================================================================================================="
echo "[K8S] 🕵️‍♂️ Verifica se a aplicacao esta disponivel em $ENVIRONMENT via curl"
echo "-------------------------------------------------------------------------------------------------------"

[ -z "$ENVIRONMENT" ] && { echo "uso: $0 <des|prd>"; exit 1; }

HOST="${ENVIRONMENT}.minikube"
IP="$(minikube ip)"
URL="http://${HOST}/hello"

for i in {1..30}; do
  if curl -fsS --resolve "${HOST}:80:${IP}" "${URL}" >/dev/null; then
    echo "✅ OK: $(curl -s --resolve "${HOST}:80:${IP}" "${URL}")";
    echo "-------------------------------------------------------------------------"
    exit 0;
  fi

  sleep 2
done

echo "🔴 Falhou: ${URL} (IP ${IP})"; kubectl -n ${ENVIRONMENT} get pods; exit 1
