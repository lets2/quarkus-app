CLUSTER ?= des
NAMESPACE ?= $(CLUSTER)

.PHONY: start-cluster status-cluster deploy stop destroy 

start-cluster:
	@echo "🚀 Starting cluster $(CLUSTER)"
	minikube start -p $(CLUSTER) --cpus=2 --memory=4g --driver=docker
	minikube addons enable ingress -p $(CLUSTER)
	kubectl --context=$(CLUSTER) create namespace $(NAMESPACE) || true

status-cluster:
	minikube status -p $(CLUSTER)

list-cluster:
	minikube profile list
	
ip-cluster:
	minikube ip -p $(CLUSTER)

deploy: start-cluster
	kubectl --context=$(CLUSTER) apply -n $(NAMESPACE) -f k8s/base/
	kubectl --context=$(CLUSTER) apply -n $(NAMESPACE) -f k8s/overlays/$(CLUSTER)/

stop:
	minikube stop -p $(CLUSTER)

destroy:
	minikube delete -p $(CLUSTER)