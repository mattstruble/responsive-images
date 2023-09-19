.PHONY: install
install:
	python3 -m pip install --upgrade pip
	poetry install --no-root --all-extras
	poetry run pre-commit install --install-hooks


.PHONY: install-release
install-all:
	poetry install --no-root --no-dev

.PHONY: build
build:
	poetry build

.PHONY: publish
publish:
	poetry publish

.PHONY: update
update:
	poetry update
	poetry run pre-commit autoupdate

.PHONY: lint
lint:
	poetry run pre-commit run --all-files
