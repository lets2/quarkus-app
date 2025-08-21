# --------------------------------------------------------------------------
# ----------- STAGE 1: Faz o build da aplicação ----------------------------
# --------------------------------------------------------------------------

# Usa imagem apropriada para compilar
FROM maven:3.9-eclipse-temurin-17 AS build

# Define diretorio de trabalho para os comandos subsequentes
WORKDIR /app

# Copia apenas os arquivos do projeto que sao necessarios para o build
COPY pom.xml .
COPY src ./src

# Faz o build usando tipo otimizado e pula testes
RUN mvn -B -e -DskipTests package -Dquarkus.package.type=fast-jar

# --------------------------------------------------------------------------
# ----------- STAGE 2: Usa o build do stage anterior para rodar aplicação --
# --------------------------------------------------------------------------

# Usa imagem propria para o ambiente de execucao
FROM eclipse-temurin:17-jre

# Define variaveis de ambiente para o tipo de unicode e restricao de cpu e memoria, para evitar out of memory
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+UseContainerSupport \
               -Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"

# Cria usuario nao root e cria pasta em /opt para a aplicacao com owner appuser
RUN useradd -u 42000 -r -g users -s /sbin/nologin appuser && \
mkdir -p /opt/app-greeting && chown -R appuser:users /opt/app-greeting

# Define usuario nao root para rodar aplicacao
USER appuser


# Define diretorio de trabalho para os comandos subsequentes
WORKDIR /opt/app-greeting

# Copia do stage anterior os artefatos gerado no build
COPY --from=build /app/target/quarkus-app/ ./

EXPOSE 8080

# Monitora saude da aplicacao no container
HEALTHCHECK --interval=10s --timeout=2s --start-period=15s --retries=5 \
  CMD wget -qO- http://127.0.0.1:8080/q/health/ready || exit 1

# Inicia a aplicação  
ENTRYPOINT ["java","-jar","quarkus-run.jar"]
