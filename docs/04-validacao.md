[⬅️ Voltar para o README](../README.md#requirements#estrutura-da-documentação)

# 4. Validação da Aplicação

Conforme explicado anteriormente, esse é o comando que dispara a pipeline

```bash
make pipeline
```

Caso ela seja executada com sucesso, ao final do processo teremos a aplicação disponível nos ambientes de desenvolvimento e produção (se a "aprovação manual" indicar que deve ser feito em prd também).

## 4.1. Testar endpoints

Acessar a raiz do domínio redireciona para o endpoint do Swagger. Além disso, também foi habilitado um endpoint de health check, conforme mostrado a seguir:

- **Swagger UI**:
  ```
  http://des.minikube/q/swagger-ui
  http://prd.minikube/q/swagger-ui
  ```
- **Healthcheck**:

  ```bash
  curl http://des.minikube/q/health
  curl http://prd.minikube/q/health
  ```

- Fique à vontade para exploras outros endpoints:

  ```bash
  curl http://des.minikube/hello
  curl http://prd.minikube/hello
  ```

## 4.2. Verificar o status dos pods

Para visualizar os pods de des e prd, aplica-se, respectivamente, os comandos a seguir:

```bash
kubectl get -n des pods
kubectl get -n prd pods
```

A saída deve ser parecida com:

```bash
NAME READY STATUS RESTARTS AGE
quarkus-app-des-78c4888cf7-wfxj4 1/1 Running 0 97s
```

## 4.2. Verificar logs da aplicação

Sabendo o nome do pod, podemos consultar os logs:

```bash
kubectl logs -n des quarkus-app-des-<hash>
kubectl logs -n prd quarkus-app-prd-<hash>
```

## 4.3. Verificação de versão da imagem

```bash
kubectl describe pod -n des | grep Image:
```

Um exemplo de retorno esperado é mostrado a seguir:

```bash
Image:          quarkus-app:1.1.0-SNAPSHOT-fd76ba1
```

---

[⬅️ Voltar para o README](../README.md#requirements#estrutura-da-documentação)

[⬅️ Anterior: 3. Etapas e Execução da Pipeline](./03-pipeline.md)

[➡️ Próximo: 5. Execução local da aplicação Quarkus](./05-rodar-localmente.md)
