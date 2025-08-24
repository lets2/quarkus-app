#!/usr/bin/env bash
set -euo pipefail

docker build -t java-sonar-pipeline -f infra/sonar-scanner/Dockerfile .

docker run --rm --network host java-sonar-pipeline bash -c "
    mvn clean verify sonar:sonar \
      -Dsonar.projectKey=meu-projeto-java \
      -Dsonar.host.url=http://localhost:9000 \
      -Dsonar.login=sqp_30ed57d7d605b1942d8e3bf61b16d273f8ca6eb1 \
      -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml
"