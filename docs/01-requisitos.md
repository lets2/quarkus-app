[⬅️ Voltar para o README](../README.md#estrutura-da-documentação)

# 1. Requisitos

A solução foi desenvolvida e testada em **Ubuntu 22.04** como sistema host.

## 1.1. Ferramentas utilizadas no ambiente e respectivas versões

| Ferramenta     | Versão                          | Observações                                           |
| -------------- | ------------------------------- | ----------------------------------------------------- |
| **Java (JDK)** | 21.0.4                          | compatível com req. mínimo JDK 17+ do getting-started |
| **Maven**      | 3.6.3                           |                                                       |
| **Docker**     | 28.0.1                          |                                                       |
| **Minikube**   | v1.34.0                         |                                                       |
| **Kubectl**    | Client v1.33.4 / Server v1.31.0 |                                                       |
| **Kustomize**  | v5.7.1                          |                                                       |
| **GNU Make**   | 4.3                             |                                                       |
| **Act**        | v0.2.80                         |                                                       |
| **SonarQube**  | sonarqube:9.9.8-community       | utilizado via container Docker                        |
| **Trivy**      | aquasec/trivy:0.65.0            | utilizado via container Docker                        |

## 1.2. Observações

- Todas as versões acima foram as utilizadas no ambiente de desenvolvimento, podendo ser substituídas por versões equivalentes ou superiores, desde que compatíveis.
- O uso de **JDK 21** não apresentou incompatibilidades, pois em [getting-started](https://github.com/quarkusio/quarkus-quickstarts/tree/main/getting-started#requirements) pede-se JDK 17+.

## 1.3. Requisitos Técnicos do Desafio

- **Imagem de Container Base:** [Docker hub eclipse temurin](https://hub.docker.com/_/eclipse-temurin)
- **Código da aplicação:** [Quarkus-getting-started](https://github.com/quarkusio/quarkus-quickstarts/tree/main/getting-started)

---

[⬅️ Voltar para o README](../README.md#requirements#estrutura-da-documentação)

[➡️ Próximo: 2. Instalação e Setup do Ambiente](./02-instalacao-setup-ambiente.md)
