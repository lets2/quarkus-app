#!/usr/bin/env bash
set -euo pipefail

echo "======================================================================================================="
echo "[PERMISSION] 🕵️‍♂️ Analise Sonarqube..."
echo "-------------------------------------------------------------------------------------------------------"

SONAR_SERVER="${1:-}";  SONAR_PROJECT_KEY="${2:-}" SONAR_TOKEN="${3:-}" 

[ -z "$SONAR_SERVER" -o -z "$SONAR_PROJECT_KEY" -o -z "$SONAR_TOKEN" ] && \
    { echo "uso: $0 <http://sonar-host:port> <project-key> <token_sonar>"; exit 1; }

docker build -t sonar-scanner-quarkus -f infra/sonar-scanner/Dockerfile .

docker run --rm --network host sonar-scanner-quarkus bash -c "
    mvn clean verify sonar:sonar \
      -Dsonar.host.url=${SONAR_SERVER} \
      -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
      -Dsonar.login=${SONAR_TOKEN} \
      -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml
"