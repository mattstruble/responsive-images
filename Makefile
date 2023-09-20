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
	docker build . -t responsive:test --target test

.PHONY: run
run: build
	docker run --rm -it responsive:test

.PHONY: update
update:
	poetry update
	poetry run pre-commit autoupdate

.PHONY: lint
lint:
	poetry run pre-commit run --all-files
