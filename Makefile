CLUSTER_NAME := eso-test

install.cluster:
	kind create cluster --name $(CLUSTER_NAME)

install.global:
	helm upgrade --install global \
		oci://ghcr.io/external-secrets/charts/external-secrets \
			--version 0.11.0 \
			-n global-eso \
			--create-namespace \
			--values helm/global/values.yaml

install.local:
	helm upgrade --install local \
		oci://ghcr.io/external-secrets/charts/external-secrets \
			--version 0.11.0 \
			-n default \
			--values helm/local/values.yaml

install: install.cluster install.global install.local
	@echo "Install complete"

.PHONY: install.cluster install.global install.local install


wait:
	kubectl wait --for=condition=ready pod -l app.kubernetes.io/instance=global -n global-eso --timeout=300s
	kubectl wait --for=condition=ready pod -l app.kubernetes.io/instance=local -n default --timeout=300s

examples: wait
	kubectl apply -f examples/local/generated-secret.yaml -n default

.PHONY: wait examples
	

delete.cluster:
	kind delete cluster --name $(CLUSTER_NAME)

delete: delete.cluster
	@echo "Delete complete"

.PHONY: delete.cluster delete