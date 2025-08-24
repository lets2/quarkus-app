# Usa imagem apropriada para compilar
FROM maven:3.9-eclipse-temurin-17

# Define diretorio de trabalho para os comandos subsequentes
WORKDIR /app

# Copia codigo do projeto para dentro do container
COPY pom.xml ./pom.xml
COPY src ./src

# Executa o comando bash passado na invocacao
CMD ["bash"]