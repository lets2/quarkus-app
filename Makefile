# Variaveis
ALLOW_PRD_DEPLOYMENT := false
VERSION ?= $(shell mvn help:evaluate -Dexpression=project.version -q -DforceStdout 2>/dev/null || 0.0.0-SNAPSHOT)
COMMIT_SHA ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "beta")
IMAGE_NAME := quarkus-app
IMAGE_NAME_WITH_TAG := $(IMAGE_NAME):$(VERSION)-$(COMMIT_SHA)
IMAGE_NAME_WITH_LATEST_TAG := $(IMAGE_NAME):latest

.PHONY: pipeline build minikube-check minikube-load \
		deploy-des verify-app-availability-des check-prd-permission deploy-prd verify-app-availability-prd clean

# Pipeline completa
pipeline: build minikube-check minikube-load \
		  deploy-des verify-app-availability-des check-prd-permission deploy-prd verify-app-availability-prd

# ========== ETAPAS DO PIPELINE ==================

# ETAPA 01: Faz o build da imagem docker com tags SemVer e latest
build:
	@./ci-scripts/build.sh $(IMAGE_NAME_WITH_TAG) $(IMAGE_NAME_WITH_LATEST_TAG)

# ETAPA 02: Verifica se minikube está ativo
minikube-check:
	@./ci-scripts/minikube_check.sh

# ETAPA 03: Carrega imagens no minikube
minikube-load:
	@./ci-scripts/minikube_load_img.sh $(IMAGE_NAME_WITH_TAG)
	@./ci-scripts/minikube_load_img.sh $(IMAGE_NAME_WITH_LATEST_TAG)

# ETAPA 04: Deploy no namespace de desenvolvimento
deploy-des:
	@./ci-scripts/deploy.sh des $(IMAGE_NAME_WITH_TAG)

# ETAPA 05: Testa se a aplicacao esta ativa no ambiente de desenvolvimento
verify-app-availability-des:
	@./ci-scripts/verify_app_availability.sh des

# ETAPA 06: Verifica se deve ser feito deploy em prd
check-prd-permission:
	@./ci-scripts/check_prd_perm.sh $(ALLOW_PRD_DEPLOYMENT)

# ETAPA 07: Deploy no ambiente de producao
deploy-prd:
	@./ci-scripts/deploy.sh prd $(IMAGE_NAME_WITH_TAG)

# ETAPA 08: Testa se a aplicacao esta ativa no ambiente de producao
verify-app-availability-prd:
	@./ci-scripts/verify_app_availability.sh prd

# limpeza de artefatos locais
clean:
	mvn clean
	docker rmi $(IMAGE_NAME_WITH_TAG) $(IMAGE_NAME_WITH_LATEST_TAG) || true
