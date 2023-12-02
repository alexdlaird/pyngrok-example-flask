def test_healthcheck(client):
    response = client.get("/healthcheck")
    assert b'{"server": "up"}' in response.data
