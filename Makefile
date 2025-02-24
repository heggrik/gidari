default:
	chmod +rwx scripts/*.sh
	go build cmd/gidari.go

# containers build the docker containers for performing integration tests.
.PHONY: containers
containers:
	scripts/build-storage.sh

# proto is a phony target that will generate the protobuf files.
.PHONY: proto
proto:
	protoc --proto_path=proto --go_out=proto proto/db.proto

# test runs all of the application tests locally.
.PHONY: tests
tests:
	go clean -testcache
	godotenv -f /etc/alpine-hodler/auth.env go test ./... -v

# ci are the integration tests in CI/CD.
.PHONY: ci
ci:
	go clean -testcache
	./scripts/run-ci-tests.sh

# lint runs the linter.
.PHONY: lint
lint:
	golangci-lint run --config .golangci.yml

# fmt runs the formatter.
.PHONY: fmt
fmt:
	gofumpt -l -w .
	golangci-lint run --fix

# add-license adds the license to all the top of all the .go files.
.PHONY: add-license
add-license:
	./scripts/add-license.sh
