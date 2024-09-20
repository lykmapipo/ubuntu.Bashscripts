.DEFAULT_GOAL := help

.PHONY: lint  ## Lint and format bash scripts
lint: lint/system lint/uninstall

.PHONY: lint/system  ## Lint and format system bash scripts
lint/system:
	docker run --rm -i -v ./system:/mnt/system koalaman/shellcheck \
	./system/*.sh
	docker run --rm -u $(id -u):$(id -g) -v ./system:/mnt/system \
	mvdan/shfmt:latest -w /mnt/system

.PHONY: lint/uninstall  ## Lint and format uninstall bash scripts
lint/uninstall:
	docker run --rm -i -v ./uninstall:/mnt/uninstall koalaman/shellcheck \
	./uninstall/*.sh
	docker run --rm -u $(id -u):$(id -g) -v ./uninstall:/mnt/uninstall \
	mvdan/shfmt:latest -w /mnt/uninstall

.PHONY: pull  ## Pull docker images i.e linter, formatters etc
pull: pull/linter

.PHONY: pull/linter  ## Pull linter docker images i.e shellcheck, shfmt etc
pull/linter:
	docker pull koalaman/shellcheck:latest
	docker pull mvdan/shfmt:latest

.PHONY: help  ## Display this message
help:
	@grep -E \
		'^.PHONY: .*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ".PHONY: |## "}; {printf "\033[36m%-19s\033[0m %s\n", $$2, $$3}'
