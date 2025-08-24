[⬅️ Voltar para o README](../README.md#requirements#estrutura-da-documentação)

# 3. Etapas e Execução da Pipeline

A automação foi implementada usando **Makefile** e **scripts bash** (presentes no diretório **`ci-scripts/`**), simulando o comportamento de uma pipeline CI/CD.

## 3.1. Executar a Pipeline

Antes de executar a Pipeline Local, certifique-se de que o ambiente esteja preparado. Se necessário, reveja o item: [2. Instalação e Setup do Ambiente](./02-instalacao-setup-ambiente.md).

Para disparar a Pipeline local, utiliza-se o [GNU Make](https://www.gnu.org/software/make/#download). No arquivo `./Makefile` existe um target agregador (ou meta-target) chamado **pipeline**, cujo único propósito é chamar outros targets numa sequência definida (a sequência de tasks que compõe a pipeline).

> Importante: lembre-se de dá permissão de execução para os scripts shell da pasta ci-scripts/
>
> ```bash
> sudo chmod -R +x ci-scripts/
> ```

A partir da raiz do projeto, abra o terminal. Para rodar a pipeline completa, aplique esse comando:

```bash
make pipeline
```

No terminal, é possível observar a sequência de etapas sendo aplicadas.

## 3.2. Etapas da Pipeline

A pipeline executa a seguinte sequência de etapas:

1. **Build da Imagem Docker da aplicação**

   - Usa o Dockerfile da raiz do projejo para construir a imagem da aplicação, utilizando multi-stage build
   - Para compilar e testar, usa imagem base `maven:3.9-eclipse-temurin-17`
   - Para a imagem final, usa `eclipse-temurin:17-jr`, apropriada para ambiente de execução
   - Cria imagens de container com as tags:
     - `latest`
     - `<versão-do-pom>-<hash-curto-do-commit-atual>` (ex.: `1.1.0-SNAPSHOT-4eaf90c`)

1. **Análise Estática**

   - Gera análise estática e cria relatórios de cobertura com `jacoco`
   - Os resultados são enviados para o `SonarQube` server, que está rodando em `localhost:9000`

1. **Scan de Vulnerabilidades**

   - Usa o `Trivy image` para detectar vulnerabilidades nas imagens que compõe a imagem da aplicação
   - Usa o `Trivy config` para detectar miss configuration nos manifests Kubernetes (diretório **`/k8s`**).

1. **Validação do Cluster**

   - Verifica se Minikube está ativo

1. **Carregar imagem no Minikube**

   - Carregamento da imagem com tag `<versão-do-pom>-<hash-curto-do-commit-atual>` no Minikube

1. **Deploy em DES**

   - Aplica `kustomize` para alterar a referência de imagem para a nova tag e gerar o YAML final combinando base e overlay
   - Faz o deploy da aplicação usando os manifests via `kubectl`

1. **Verificação de disponibilidade de app em DES**

   - Faz algumas requisições usando `curl` para `http://des.minikube` com o objetivo de verificar a disponibilidade da aplicação

1. **Aprovação de deploy em PRD**

   - Verifica se está permitido fazer o deploy em PRD
   - Se a variável `ALLOW_PRD_DEPLOYMENT=true`, vai para a próxima etapa

1. **Deploy em PRD**

   - Faz o deploy da aplicação usando os manifests via `kubectl`

1. **Verificação de disponibilidade de app em PRD**

   - Faz algumas requisições usando `curl` para `http://prd.minikube` com o objetivo de verificar a disponibilidade da aplicação

---

[⬅️ Voltar para o README](../README.md#requirements#estrutura-da-documentação)

[⬅️ Anterior: 2. Instalação e Setup do Ambiente](./02-instalacao-setup-ambiente.md)

[➡️ Próximo: 4. Validação da Aplicação](./04-validacao.md)
