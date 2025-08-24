# =========== VARIAVEIS DE AMBIENTE ==============

# Importa variaveis presentes no arquivo
include .env

# Torna as variaveis disponiveis no Makefile e shell scripts chamados
export $(shell sed 's/=.*//' .env)

# Caso a variavel nao esteja definida, use false e exporta para comandos shell
ALLOW_PRD_DEPLOYMENT ?= false
export ALLOW_PRD_DEPLOYMENT

VERSION ?= $(shell mvn help:evaluate -Dexpression=project.version -q -DforceStdout 2>/dev/null || 0.0.0-SNAPSHOT)
COMMIT_SHA ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "beta")
DATE_WITH_SEC := $(shell date +%Y%m%d%H%M%S)
IMAGE_NAME ?= quarkus-app
IMAGE_NAME_WITH_TAG := $(IMAGE_NAME):$(VERSION)-$(COMMIT_SHA)-$(DATE_WITH_SEC)
IMAGE_NAME_WITH_LATEST_TAG := $(IMAGE_NAME):latest


# ======= ORDEM DE EXECUÇÃO DA PIPELINE ==========

.PHONY: pipeline build sonar trivy-scan minikube-check minikube-load \
		deploy-des verify-app-availability-des check-prd-permission deploy-prd verify-app-availability-prd clean

pipeline: build sonar trivy-scan minikube-check minikube-load \
		  deploy-des verify-app-availability-des check-prd-permission deploy-prd verify-app-availability-prd
	@echo "======================================================================================================="
	@echo "FIM DA PIPELINE"
	@echo "======================================================================================================="


# ========== ETAPAS Da PIPELINE ==================

# ETAPA 01: Faz o build da imagem docker com tags SemVer e latest
build:
	@./ci-scripts/build.sh $(IMAGE_NAME_WITH_TAG) $(IMAGE_NAME_WITH_LATEST_TAG)

# ETAPA 02: Faz analise estatica com sonar e envia relatorio para o sonar server
sonar:
	@./ci-scripts/sonar.sh $(SONAR_SERVER) $(SONAR_PROJECT_KEY) $(SONAR_TOKEN)

# ETAPA 03: Faz analise de vulnerabilidade na imagem e miss configuration de manifest k8s
trivy-scan:
	@./ci-scripts/trivy_scan.sh $(IMAGE_NAME_WITH_TAG)

# ETAPA 04: Verifica se minikube está ativo
minikube-check:
	@./ci-scripts/minikube_check.sh

# ETAPA 05: Carrega imagens no minikube
minikube-load:
	@./ci-scripts/minikube_load_img.sh $(IMAGE_NAME_WITH_TAG)
	@./ci-scripts/minikube_load_img.sh $(IMAGE_NAME_WITH_LATEST_TAG)

# ETAPA 06: Deploy no namespace de desenvolvimento
deploy-des:
	@./ci-scripts/deploy.sh des $(IMAGE_NAME_WITH_TAG)

# ETAPA 07: Testa se a aplicacao esta ativa no ambiente de desenvolvimento
verify-app-availability-des:
	@./ci-scripts/verify_app_availability.sh des

# ETAPA 08: Verifica se deve ser feito deploy em prd
check-prd-permission:
	@./ci-scripts/check_prd_perm.sh $(ALLOW_PRD_DEPLOYMENT)

# ETAPA 09: Deploy no ambiente de producao
deploy-prd:
	@./ci-scripts/deploy.sh prd $(IMAGE_NAME_WITH_TAG)

# ETAPA 10: Testa se a aplicacao esta ativa no ambiente de producao
verify-app-availability-prd:
	@./ci-scripts/verify_app_availability.sh prd

# limpeza de artefatos locais
clean:
	mvn clean
	docker rmi $(IMAGE_NAME_WITH_TAG) $(IMAGE_NAME_WITH_LATEST_TAG) || true
