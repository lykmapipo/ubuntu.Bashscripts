.DEFAULT_GOAL := help

.PHONY: lint  ## Lint and format bash scripts
lint: lint/cleanups

.PHONY: lint/cleanups  ## Lint and format cleanup bash scripts
lint/cleanups:
	docker run --rm -i -v ./cleanups:/mnt/cleanups koalaman/shellcheck \
	./cleanups/*.sh
	docker run --rm -u $(id -u):$(id -g) -v ./cleanups:/mnt/cleanups \
	mvdan/shfmt:latest -w /mnt/cleanups

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
