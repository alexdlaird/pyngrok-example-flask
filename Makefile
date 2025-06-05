.PHONY: env all nopyc clean install test build-docker run-docker

SHELL := /usr/bin/env bash
PYTHON_BIN ?= python
PROJECT_VENV ?= venv

all: test

env:
	touch .env

venv:
	$(PYTHON_BIN) -m pip install virtualenv --user
	$(PYTHON_BIN) -m virtualenv $(PROJECT_VENV)

install: venv
	@( \
		source $(PROJECT_VENV)/bin/activate; \
		python -m pip install -r requirements.txt -r requirements-dev.txt; \
	)

nopyc:
	find . -name '*.pyc' | xargs rm -f || true
	find . -name __pycache__ | xargs rm -rf || true

clean: nopyc
	rm -rf _build dist *.egg-info $(PROJECT_VENV)

test: install
	@( \
		source $(PROJECT_VENV)/bin/activate; \
		pytest -v; \
	)

build-docker:
	docker build -t pyngrok-example-flask .

run-docker: env
	# Here we're mounting the container as read-only to fully validate java-ngrok is not modifying
	# the filesystem during its startup, since we want to use the provisioned binary and config
	docker run --env-file .env -p 8000:8000 --read-only -it pyngrok-example-flask
