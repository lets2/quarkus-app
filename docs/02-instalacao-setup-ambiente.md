[⬅️ Voltar para o README](../README.md#requirements#estrutura-da-documentação)

# 2. Instalação e Setup do Ambiente

## 2.1. Instalação de ferramentas

As principais ferramentas podem ser instaladas manualmente ou via gerenciador de pacotes. Links oficiais:

- [Java (Temurin JDK)](https://adoptium.net/pt-BR/temurin/releases?version=21)
- [Maven](https://maven.apache.org/install.html)
- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)
- [Act](https://nektosact.com/installation/)
- [GNU Make](https://www.gnu.org/software/make/#download)

### 2.1.1. Verificação das versões instaladas:

Para verificar se as ferramentas estão instaladas, aplique os comandos abaixo:

```bash
java --version
mvn --version
docker --version
minikube version
kubectl version
kustomize version
act --version
make --version
```

## 2.2. Configuração do Minikube

Para aproveitar o engine do Docker já instalado, evitando a criação de uma VM separada, o minikube permite passar o driver do docker ao aplicar o comando de iniciar o cluster:

```bash
minikube start --driver=docker
```

Ative o addon **Ingress** dentro do cluster Minikube, através desse comando:

```bash
minikube addons enable ingress
```

Ao habilitar o addon Ingress, o Minikube instala automaticamente um controller (por exemplo, NGINX) e configura tudo. O Ingress atua como um roteador HTTP/HTTPS dentro do cluster, permitindo expor múltiplos services em um único endereço IP, usando regras de host e path.

```bash
minikube start --driver=docker
minikube addons enable ingress
```

## 2.3. Configuração de DNS local (hosts)

### 2.3.1. Determinar o IP do Minikube

O IP do Minikube é usado para expor services do tipo NodePort e LoadBalancer. No caso de driver Docker, trata-se do IP da rede interna do container que simula o node. Precisamos desse IP para fazer a associação de DNS local. Aplique o comando a seguir:

```bash
minikube ip
```

### 2.3.2. Adicionar o ip no arquivo de hosts

Nesse desafio, temos dois ambientes (des e prd), os manifests de kubernetes (ver k8s/overlays/des e k8s/overlays/prd) definem os domínios:

- `des.minikube`
- `prd.minikube`

O ingress será responsável por direcionar requisições para esses domínios para os serviços correspondentes.
No entanto, para que a resolução de DNS local aconteça, precisamos associar esses domínios ao ip do minikube no arquivo de hosts.
Adicione o ip do minikube no arquivo de hosts (`/etc/hosts`). Abra o arquivo com o comando abaixo:

```bash
sudo nano /etc/hosts
```

Adicione os domínios:

```bash
<IP_DO_MINIKUBE>  des.minikube
<IP_DO_MINIKUBE>  prd.minikube
```

Por exemplo,

```bash
# supondo que minikube ip retorne 192.168.49.2
192.168.49.2   des.minikube
192.168.49.2   prd.minikube
```

Dessa forma, as requisições para http://des.minikube e http://prd.minikube são convertidas para o minikube ip e, com a informação de host, o Ingress roteará para os respectivos destinos.

## 2.4. SonarQube server

No pipeline local, uma das etapas é a análise estática de código usando **Sonarqube**. Portanto, é obrigatório subir uma instância de sonarqube localmente. Para isso, vamos fazer uso de imagem docker de sonarqube community (versão da comunidade), a saber **`sonarqube:9.9.8-community`**([Docker hub sonarqube](https://hub.docker.com/_/sonarqube/)).

### 2.4.1. Subir instância do Sonarqube

Para subir SonarQube localmente, é possível aplicar esse comando:

```bash
docker run -d --name sonarserver -p 9000:9000 sonarqube:9.9.8-community
```

Alternativamente, você pode usar o docker-compose.yaml disponível em **`./infra/sonar-server/docker-compose.yaml`**. Basta abrir o terminal, acessar o diretório (`cd infra/sonar-server`) e aplicar o comando a seguir:

```bash
docker compose -p sonarserver up -d

docker compose \
  -f infra/sonar-server/docker-compose.yaml \
  -p sonarserver up -d
```

A principal vantagem de usar o arquivo docker-compose.yaml disponível é que ele cria volumes para a persistência dos dados das análises.
Lembre-se de verificar se o container está ativo:

```bash
docker ps
```

Ao final do desenvolmento, o usuário pode derrubar o container por meio desse comando:

```bash
docker compose -p sonarserver down
```

### 2.4.2. Configurar usuário e obter token

Com o servidor do sonarqube disponível, acesse [http://localhost:9000](http://localhost:9000).
As credenciais são

```
usuario: admin
senha: admin
```

Pode ser solicitado a troca de senha após o primeiro login.
Siga esse passo a passo:

1. Clique em **Create Project**
1. Clique em **Manually**
1. No formulário apresentado, defina uma `project-key` e a branch default.
1. Clique em **Set Up**
1. Na página seguinte, clique em **Locally**
1. Clique no botão **Generate** para criar um token de autenticação (`project token`).

Após esses passos, você deve obter algo similar a isso:

```
Analyze "my-project-key": sqp_fb84a3bcfdaffa9bd62a91c2cbf9fca22e4fcad0
```

Nesse caso, `my-project-key` é a chave, e `sqp_fb84a3bcfdaffa9bd62a91c2cbf9fca22e4fcad0` é o token do projeto. Essas informações devem ser adicionadas em um arquivo `.env`, conforme explicado no próximo item.

Posteriormente, quando o pipeline for executado, uma das etapas faz analise de código e envia o relatório de cobertura para o Sonarqube, disponível em [http://localhost:9000](http://localhost:9000).

# 2.5. Configurar arquivo com variáveis de ambiente

Na raiz do projeto, há um arquivo nomeado `.env.example` que contém um modelo de todas as variáveis necessárias para executar a pipeline.
Crie uma cópia desse arquivo e, em seguida, renomei a cópia para `.env`. No `.gitignore` está listado o `.env`, portanto, não é um arquivo que será enviado para o repositório remoto. O conteúdo original do arquivo é parecido com este:

```bash
SONAR_SERVER=http://<sonar-host-server>:<port>
SONAR_PROJECT_KEY=<project-key>
SONAR_TOKEN=<token>
ALLOW_PRD_DEPLOYMENT=<boolean>
IMAGE_NAME=<image-name>
```

Substitua o valores entre `< >` pelo real valor da variável. Por exemplo, no item anterior você criou uma **project key** e um **project token**. Esses valores devem ser adicionados no `.env`. Em seguida, apresenta-se uma descrição resumida de cada variável:

- **`SONAR_SERVER` -** Host do servidor do sonar. É comum adotar `http://localhost:9000`
- **`SONAR_PROJECT_KEY` -** Project key definida no servidor do sonar
- **`SONAR_TOKEN` -** Project token definido no servidor do sonar, no formato **sqp_hash**
- **`ALLOW_PRD_DEPLOYMENT` -** Variável booleana que indica se deve ser feito o deploy em prd (caso não esteja definida, a pipeline usa valor `false` como padrão
- **`IMAGE_NAME` -** Nome da imagem, desconsiderando a tag (caso não esteja definida, a pipeline usa `quarkus-app`)

> **Atenção, insira as informações SEM aspas!**
> Para ilustrar um exemplo de `.env` devidamente preenchido, observe a seguir:

```bash
SONAR_SERVER=http://localhost:9000
SONAR_PROJECT_KEY=my-project-key
SONAR_TOKEN=sqp_fb84a3bcfdaffa9bd62a91c2cbf9fca22e4fcad0
ALLOW_PRD_DEPLOYMENT=true
IMAGE_NAME=quarkus-app
```

Com o ambiente corretamente configurado, a próxima etapa é conhecer e executar a pipeline.

---

[⬅️ Voltar para o README](../README.md#requirements#estrutura-da-documentação)

[⬅️ Anterior: 1. Requisitos](./01-requisitos.md)

[➡️ Próximo: 3. Etapas e Execução do Pipeline](./03-pipeline.md)
