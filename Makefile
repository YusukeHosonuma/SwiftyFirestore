EFAULT_GOAL := help
HELP_INDENT := "20"

# ref: https://postd.cc/auto-documented-makefile/
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-$(HELP_INDENT)s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Install requirement development tools to system and setup (not include Xcode 11.3)
	npm i
	npx firebase setup:emulators:firestore

.PHONY: open
open: ## Open Xcode 11.3
	open "/Applications/Xcode-11.3.app" SwiftyFirestore.xcworkspace

.PHONY: test
test: ## Run tests
	./Script/run-unit-test.sh

.PHONY: start-emulator
start-emulator: ## Start Firestore emulator
	npx firebase emulators:start --only firestore

.PHONY: lint
lint: ## cocoapods - lint podspec
	bundle exec pod lib lint

.PHONY: release
release: ## cocoapods - release
	bundle exec pod trunk push SHList.podspec

.PHONY: info
info: ## cocoapods - show trunk information
	bundle exec pod trunk info SHList

.PHONY: integration-test
integration-test: ## Integration test by Example app
	cd ./Example && \
	rm Podfile && \
	mv Podfile_IntegrationTest Podfile && \
	bundle exec pod update && \
	bundle exec fastlane test

#
# Development for Linux
#

.PHONY: linux
linux: ## Run and login docker container
	docker run --rm -it \
		--volume "$(CURDIR):/src" \
		--workdir "/src" \
		swift:5.1

.PHONY: linux-test
linux-test: ## Run tests on linux in docker
	docker run --rm \
		--volume "$(CURDIR):/src" \
		--workdir "/src" \
		swift:5.1 \
		swift test --enable-test-discovery
