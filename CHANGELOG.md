# Changelog

Todas as mudanças notáveis neste projeto serão documentadas aqui.

O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/)
e este projeto adere a [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [Unreleased]

## [1.1.0] - 2025-08-24

### Added

- Pipeline estruturado com **Makefile** e scripts shell:
  - Build da aplicação usando Maven
  - Build da imagem Docker
  - Análise de qualidade com **SonarQube**
  - Análise de vulnerabilidades da imagem com **Trivy**
  - Análise de misconfigurations em manifests Kubernetes com **Trivy**
  - Deploy automatizado em ambientes **Minikube (des e prd)**
- Documentação atualizada explicando como executar a aplicação e rodar a pipeline.

### Changed

- `pom.xml` atualizado para versão `1.1.0`.

## [1.0.0] - 2025-08-22

### Added

- Primeira versão estável do projeto
- Implementação inicial em Quarkus com Maven
