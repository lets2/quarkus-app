[⬅️ Voltar para o README](../README.md#estrutura-da-documentação)

# 5. Execução local da aplicação Quarkus

Este é um minimal CRUD service, que expõe alguns endpoints sobre REST. Esta demo usa:

- RESTEasy para expor os REST endpoints
- REST-assured e JUnit 5 para testes dos endpoint

## 5.1. Requisitos para executar localmente

Caso não deseje executar a pipeline, nem montar um ambiente com clusters kubernetes local, ainda é possível visualizar a aplicação, executando-a localmente.
Para compilar e executar esta demo você precisará de:

- JDK 17+
- GraalVM
- Docker (caso deseje usar imagem de container)

### 5.1.1. Usando Docker para subir a aplicação

A partir da raiz do projeto, aplique esse comando para fazer um build da imagem de container:

```bash
docker build -t quarkus-app-sem-k8s:1.2.0-SNAPSHOT .
```

Para criar um container que vai manter a aplicação funcionando, aplique o comando a seguir:

```bash
docker run -d --name quarkus-app-sem-k8s -p 8080:8080 quarkus-app-sem-k8s:1.2.0-SNAPSHOT
```

A flag `-p` mapeia a porta 8080 do sistema hospedeiro (sua máquina) para a 8080 dentro do container. Portanto, você pode acessar [http://localhost:8080](http://localhost:8080) para vizualizar a aplicação.

![Aplicação disponivel localmente](./assets/img10-app-localhost.png)

Para interromper a aplicação, remover o container e apagar a imagem de container, aplique esses comandos em sequência:

```bash
docker stop quarkus-app-sem-k8s
docker rm quarkus-app-sem-k8s
docker rmi quarkus-app-sem-k8s:1.2.0-SNAPSHOT

```

### 5.2. Configurando GraalVM e JDK 17+ para execução local usando dependências da máquina host

Garanta que as variáveis de ambiente `GRAALVM_HOME` e `JAVA_HOME` foram definidas, e que um JDK 17+ comando `java` JDK 17+ está no **path**.

Veja [Building a Native Executable guide](https://quarkus.io/guides/building-native-image-guide) para configurar o seu ambiente.

## 5.3. Build do aplicativo

Inicie a compilação do Maven nos códigos-fonte verificados desta demonstração:

> ./mvnw package

### 5.3.1. Live coding com Quarkus

O plugin Maven Quarkus oferece um modo de desenvolvimento que suporta live coding. Para experimentar:

> ./mvnw quarkus:dev

Este comando deixará o Quarkus rodando em primeiro plano escutando na porta 8080.

1. Acessar o endpoint padrão: [http://127.0.0.1:8080](http://127.0.0.1:8080), o qual redireciona para a página do **Swagger** [http://127.0.0.1:8080/q/swagger-ui](http://127.0.0.1:8080/q/swagger-ui))

2. Visite `/hello` endpoint: [http://127.0.0.1:8080/hello](http://127.0.0.1:8080/hello)
   - Atualize a resposta em [src/main/java/org/acme/quickstart/GreetingResource.java](src/main/java/org/acme/quickstart/GreetingResource.java). Substitua `hello` por `hello there` no método `hello()`.
   - Atualize o navegador. Agora você deve ver `hello there`.
   - Desfaça a mudança, então o método retorna `hello` novamente.
   - Atualize o navegador. Agora você deve ver `hello`.

### 5.3.2. Rode Quarkus em JVM mode

Quando terminar de iterar no modo de desenvolvedor, você pode executar o aplicativo como um arquivo jar convencional.

Primeiro compile:

> ./mvnw package

Então execute:

> java -jar ./target/quarkus-app/quarkus-run.jar

Observe a velocidade de inicialização ou meça o consumo total de memória nativa.

### 5.3.3. Criar e executar um JAR otimizado

Você pode usar o maven+JDK instalados na sua máquina hospedeira para compilar a aplicação em um JAR otimizado, conforme o comando abaixo:

> mvn clean package -Dquarkus.package.type=fast-jar

Para rodar, aplique:

> java -jar target/quarkus-app/quarkus-run.jar

A aplicação otimizada fica disponível em [http://localhost:8080](http://localhost:8080).

### 5.3.4. Execute o Quarkus como um executável nativo

Você também pode criar um executável nativo a partir deste aplicativo sem fazer nenhuma alteração no código-fonte. Um executável nativo remove a dependência da JVM: tudo o que é necessário para executar o aplicativo na plataforma de destino está incluído no executável, permitindo que o aplicativo seja executado com o mínimo de sobrecarga de recursos.

Compilar um executável nativo leva um pouco mais de tempo, pois o GraalVM executa etapas adicionais para remover codepaths desnecessários. Use o perfil `native` para compilar um executável nativo:

> ./mvnw package -Dnative

Depois de tomar um café, você poderá executar este executável diretamente:

> ./target/quarkus-app-1.0.0-SNAPSHOT-runner

---

[⬅️ Voltar para o README](../README.md#estrutura-da-documentação)

[⬅️ Anterior: 4. Validação da Aplicação](./04-validacao.md)
