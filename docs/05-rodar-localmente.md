[⬅️ Voltar para o README](../README.md#estrutura-da-documentação)

# 5. Execução local da aplicação Quarkus

Este é um minimal CRUD service, que expõe alguns endpoints sobre REST. Esta demo usa:

- RESTEasy para expor os REST endpoints
- REST-assured e JUnit 5 para testes dos endpoint

## 5.1. Requisitos para executar localmente

Caso não deseje executar a pipeline, nem montar um ambiente com cluster kubernetes local, ainda é possível visualizar a aplicação, executando-a localmente.
Para compilar e executar esta demo você precisará de:

- JDK 17+
- GraalVM

### 5.1.1. Configurando GraalVM e JDK 17+

Garanta que as variáveis de ambiente `GRAALVM_HOME` e `JAVA_HOME` foram definidas, e que um JDK 17+ comando `java` JDK 17+ está no **path**.

Veja [Building a Native Executable guide](https://quarkus.io/guides/building-native-image-guide) para configurar o seu ambiente.

## 5.2. Build do aplicativo

Inicie a compilação do Maven nos códigos-fonte verificados desta demonstração:

> ./mvnw package

### 5.2.1. Live coding com Quarkus

O plugin Maven Quarkus oferece um modo de desenvolvimento que suporta live coding. Para experimentar:

> ./mvnw quarkus:dev

Este comando deixará o Quarkus rodando em primeiro plano escutando na porta 8080.

1. Acessar o endpoint padrão: [http://127.0.0.1:8080](http://127.0.0.1:8080), o qual redireciona para a página do **Swagger** [http://127.0.0.1:8080/q/swagger-ui](http://127.0.0.1:8080/q/swagger-ui))

2. Visite `/hello` endpoint: [http://127.0.0.1:8080/hello](http://127.0.0.1:8080/hello)
   - Atualize a resposta em [src/main/java/org/acme/quickstart/GreetingResource.java](src/main/java/org/acme/quickstart/GreetingResource.java). Substitua `hello` por `hello there` no método `hello()`.
   - Atualize o navegador. Agora você deve ver `hello there`.
   - Desfaça a mudança, então o método retorna `hello` novamente.
   - Atualize o navegador. Agora você deve ver `hello`.

### 5.2.2. Rode Quarkus em JVM mode

Quando terminar de iterar no modo de desenvolvedor, você pode executar o aplicativo como um arquivo jar convencional.

Primeiro compile:

> ./mvnw package

Então execute:

> java -jar ./target/quarkus-app/quarkus-run.jar

Observe a velocidade de inicialização ou meça o consumo total de memória nativa.

### 5.2.3. Execute o Quarkus como um executável nativo

Você também pode criar um executável nativo a partir deste aplicativo sem fazer nenhuma alteração no código-fonte. Um executável nativo remove a dependência da JVM: tudo o que é necessário para executar o aplicativo na plataforma de destino está incluído no executável, permitindo que o aplicativo seja executado com o mínimo de sobrecarga de recursos.

Compilar um executável nativo leva um pouco mais de tempo, pois o GraalVM executa etapas adicionais para remover codepaths desnecessários. Use o perfil `native` para compilar um executável nativo:

> ./mvnw package -Dnative

Depois de tomar um café, você poderá executar este executável diretamente:

> ./target/getting-started-1.0.0-SNAPSHOT-runner

---

[⬅️ Voltar para o README](../README.md#estrutura-da-documentação)

[⬅️ Anterior: 4. Validação da Aplicação](./04-validacao.md)
