.PHONY: install
install:
	pip install --update pip
	poetry install --no-root --no-dev

.PHONY: install-dev
install-dev:
	poetry install --no-root --extras=dev

.PHONY: install-all
install-all:
	poetry install --no-root --all-extras

.PHONY: build
build:
	poetry build

.PHONY: publish
publish:
	poetry publish

.PHONY: lint
lint:
	set -euxo pipefail

	poetry run ruff .
	poetry run black .
	poetry run pyright

	poetry run radon mi --min B .
	poetry run radon cc --min C .

	poetry run codespell .
