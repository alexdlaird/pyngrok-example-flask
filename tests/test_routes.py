__copyright__ = "Copyright (c) 2023-2024 Alex Laird"
__license__ = "MIT"

import os
import unittest

from pyngrok import conf, process


@unittest.skipIf(not os.environ.get("NGROK_AUTHTOKEN"), "NGROK_AUTHTOKEN environment variable not set")
def test_healthcheck(client):
    response = client.get("/healthcheck")
    assert b'{"server": "up"}' in response.data
    assert "ngrok" in client.application.config["BASE_URL"]
    assert process.is_process_running(conf.get_default().ngrok_path)


def test_healthcheck_no_ngrok(client_no_ngrok):
    response = client_no_ngrok.get("/healthcheck")
    assert b'{"server": "up"}' in response.data
    assert "ngrok" not in client_no_ngrok.application.config["BASE_URL"]
