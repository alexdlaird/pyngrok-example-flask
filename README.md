[![Build](https://img.shields.io/github/actions/workflow/status/alexdlaird/pyngrok-example-flask/build.yml)](https://github.com/alexdlaird/pyngrok-example-flask/actions/workflows/build.yml)
![GitHub License](https://img.shields.io/github/license/alexdlaird/pyngrok-example-flask)

# pyngrok Example - Flask

This is an example project that shows how to easily integrate [`pyngrok`](https://github.com/alexdlaird/pyngrok)
with [Flask](https://flask.palletsprojects.com/en/stable/), as [summarized in the docs](https://pyngrok.readthedocs.io/en/latest/integrations.html#flask). It also includes a `Dockerfile` to show how to
[containerize `pyngrok`](https://pyngrok.readthedocs.io/en/latest/integrations.html#docker).

## Running

To run the example locally, install its dependencies, then start the server with `USE_NGROK` set to open a tunnel.
The tunnel's public URL is printed when the server starts.

```sh
make install
USE_NGROK=True NGROK_AUTHTOKEN=$NGROK_AUTHTOKEN venv/bin/python -m pyngrokexampleflask.server
```

To instead run it in a container built from the [`pyngrok` Docker image](https://hub.docker.com/r/alexdlaird/pyngrok),
use:

```sh
make build-docker
NGROK_AUTHTOKEN=$NGROK_AUTHTOKEN make run-docker
docker logs pyngrok-example-flask
```

To run the tests, use `make test`. Tests that open a tunnel are skipped if `NGROK_AUTHTOKEN` isn't set.