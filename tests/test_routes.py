import os
import unittest


@unittest.skipIf("NGROK_AUTHTOKEN" not in os.environ, "NGROK_AUTHTOKEN environment variable not set")
def test_healthcheck(client):
    response = client.get("/healthcheck")
    assert b'{"server": "up"}' in response.data


def test_healthcheck_no_ngrok(client_no_ngrok):
    response = client_no_ngrok.get("/healthcheck")
    assert b'{"server": "up"}' in response.data
