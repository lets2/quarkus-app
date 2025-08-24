#!/usr/bin/env bash
set -euo pipefail

echo "======================================================================================================="
echo "[PERMISSION] 🕵️‍♂️ Verificando permissões para deploy em PRD..."
echo "-------------------------------------------------------------------------------------------------------"

ALLOW_PRD_DEPLOYMENT="${1:-false}"

if [[ "$ALLOW_PRD_DEPLOYMENT" == "true" ]]; then
  echo "✅ Permissão concedida para deploy em PRD.✅";
  exit 0;
else
  echo "❌🔒 Deploy em PRD bloqueado por configuracao. 🔒❌"
  echo "======================================================================================================="
	echo "FIM DA PIPELINE"
	echo "======================================================================================================="
  echo "Encerrando com codigo:"
  exit 78;
fi