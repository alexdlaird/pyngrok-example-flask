import os

import pytest

from pyngrokexampleflask.server import create_app


@pytest.fixture()
def app():
    os.environ["USE_NGROK"] = "True"
    app = create_app()
    app.config.update({
        "TESTING": True,
    })

    yield app


@pytest.fixture()
def app_no_ngrok():
    os.environ["USE_NGROK"] = "False"
    app_no_ngrok = create_app()
    app_no_ngrok.config.update({
        "TESTING": True,
    })

    yield app_no_ngrok


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def client_no_ngrok(app_no_ngrok):
    return app_no_ngrok.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()


@pytest.fixture()
def runner_no_ngrok(app_no_ngrok):
    return app_no_ngrok.test_cli_runner()
