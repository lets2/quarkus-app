# Deployment Automatizado de Aplicação Quarkus em Ambiente Orquestrado Local

Este repositório contém uma solução para o desafio técnico de **implantação automatizada em ambiente orquestrado**, com foco em práticas de **DevSecOps**.

A aplicação escolhida foi baseada no projeto [quarkus-getting-started](https://github.com/quarkusio/quarkus-quickstarts/tree/main/getting-started). Ao código original, foram aplicadas algumas adaptações e melhorias para suportar Swagger/OpenAPI Specification, health check, análise estática com SonarQube e deployment em cluster kubernetes.

## Documentos Importantes

> Os Links abaixo levam para documentos presentes no diretório **`docs/`**. Visite-os para entender os requisitos, como preparar o ambiente, como é o versionamento, como executar a pipeline localmente e como validar a aplicação.
>
> - [1. Requisitos](./docs/01-requisitos.md)
> - [2. Instalação e Setup do Ambiente](./docs/02-instalacao-setup-ambiente.md)
> - [3. Etapas e Execução da Pipeline](./docs/03-pipeline.md)
> - [4. Validação da Aplicação](./docs/04-validacao.md)
> - [5. Execução local](./docs/05-rodar-localmente.md)

## Entregáveis do Desafio

- Cluster Kubernetes local provisionado via **Minikube**
- Pipeline local de automação (Makefile + scripts bash)
- Aplicação **Quarkus** compilada e empacotada
- Imagem de container Docker (base Eclipse Temurin)
- Deploy da aplicação nos ambientes:
  - **DES** (Desenvolvimento)
  - **PRD** (Produção simulado)
- Documentação técnica detalhada

## Requisitos Técnicos

- **Imagem de Container Base:** [Docker Hub Eclipse Temurin](https://hub.docker.com/_/eclipse-temurin)
- **Código da aplicação:** [Quarkus-getting-started](https://github.com/quarkusio/quarkus-quickstarts/tree/main/getting-started)
