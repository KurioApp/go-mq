SOURCES := $(shell find . -name '*.go' -type f -not -path './vendor/*'  -not -path '*/mocks/*')

GCP_PROJECT ?= kurio-dev
GCP_TOPIC ?= dev.gomq.test
GCP_SUBSCRIPTION ?= dev.gomq.test.sub1
GCP_PUBSUB_EMULATOR ?= localhost:8538

# Dependencies Management
.PHONY: prepare-dev
prepare-dev: lint-prepare vendor

.PHONY: vendor
vendor: go.mod go.sum
	@echo "Installing depedency"
	@go get ./...

# Linter
.PHONY: lint-prepare
lint-prepare:
	@echo "Installing golangci-lint"
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

.PHONY: lint
lint:
	golangci-lint run ./...

.PHONY: pubsub-up
pubsub-up:
	docker-compose up -d pubsub

.PHONY: pubsub-down
pubsub-down:
	docker-compose stop pubsub

# Testing
.PHONY: test
test:
	@go test -short $(TEST_OPTS) ./...

.PHONY: test-pubsub
test-pubsub:
	@go test -v $(TEST_OPTS) ./pubsub -gcp.project-id "$(GCP_PROJECT)" -gcp.topic-id "$(GCP_TOPIC)" -gcp.subscription-id "$(GCP_SUBSCRIPTION)" -gcp.pubsub-emulator "$(GCP_PUBSUB_EMULATOR)"
