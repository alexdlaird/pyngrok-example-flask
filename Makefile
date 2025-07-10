.PHONY: env all nopyc clean install test build-docker run-docker test-docker

SHELL := /usr/bin/env bash
PYTHON_BIN ?= python
PROJECT_VENV ?= venv
TAG ?= latest

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
	docker build -t pyngrok-example-flask --build-arg "TAG=${TAG}" .

run-docker: env
	# Here we're mounting the container as read-only to fully validate pyngrok is not modifying
	# the filesystem during its startup, since we want to use the provisioned binary and config
	docker run --name pyngrok-example-flask --env-file .env -p 8000:8000 -d --read-only pyngrok-example-flask

stop-docker:
	docker stop pyngrok-example-flask

test-docker: build-docker run-docker
	@( \
		sleep 10; \
		curl --fail -o /dev/null http://localhost:8000/healthcheck; \
		docker logs pyngrok-example-flask; \
	)
	make stop-docker