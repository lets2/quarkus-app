# Variaveis
# TIMESTAMP := $(shell date +'%Y%m%d-%H%M%S')
ALLOW_PRD_DEPLOYMENT := false
# VERSION ?= $(shell cat version.txt)
VERSION ?= $(shell mvn help:evaluate -Dexpression=project.version -q -DforceStdout 2>/dev/null || 0.0.0-SNAPSHOT)

COMMIT_SHA ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "beta")
IMAGE_NAME := quarkus-app
IMAGE_NAME_WITH_TAG := $(IMAGE_NAME):$(VERSION)-$(COMMIT_SHA)
IMAGE_NAME_WITH_LATEST_TAG := $(IMAGE_NAME):latest

.PHONY: pipeline build test docker-build minikube-check minikube-load \
		deploy-des verify-app-availability-des check-prd-permission deploy-prd verify-app-availability-prd clean

# Pipeline completa
pipeline: build test docker-build minikube-check minikube-load \
		  deploy-des verify-app-availability-des check-prd-permission deploy-prd verify-app-availability-prd

# ========== ETAPAS DO PIPELINE ==================

# ETAPA 01: Compila sem rodar os testes 
build:
	@./scripts/build.sh

# ETAPA 02: Executa os testes
test:
	@./scripts/test.sh

# ETAPA 03: Faz o build da imagem docker com tags SemVer e latest
docker-build:
	@./scripts/docker_build.sh $(IMAGE_NAME_WITH_TAG) $(IMAGE_NAME_WITH_LATEST_TAG)

# ETAPA 04: Verifica se minikube está ativo
minikube-check:
	@./scripts/minikube_check.sh

# ETAPA 05: Carrega imagens no minikube
minikube-load:
	@./scripts/minikube_load_img.sh $(IMAGE_NAME_WITH_TAG)
	@./scripts/minikube_load_img.sh $(IMAGE_NAME_WITH_LATEST_TAG)

# ETAPA 06: Deploy no namespace de desenvolvimento
deploy-des:
	@./scripts/deploy.sh des $(IMAGE_NAME_WITH_TAG)

# ETAPA 07: Testa se a aplicacao esta ativa no ambiente de desenvolvimento
verify-app-availability-des:
	@./scripts/verify_app_availability.sh des

# ETAPA 08: Verifica se deve ser feito deploy em prd
check-prd-permission:
	@./scripts/check_prd_perm.sh $(ALLOW_PRD_DEPLOYMENT)

# ETAPA 09: Deploy no ambiente de producao
deploy-prd:
	@./scripts/deploy.sh prd $(IMAGE_NAME_WITH_TAG)

# ETAPA 10: Testa se a aplicacao esta ativa no ambiente de producao
verify-app-availability-prd:
	@./scripts/verify_app_availability.sh prd

# limpeza de artefatos locais
clean:
	mvn clean
	docker rmi $(IMAGE_NAME_WITH_TAG) $(IMAGE_NAME_WITH_LATEST_TAG) || true
