__copyright__ = "Copyright (c) 2023-2024 Alex Laird"
__license__ = "MIT"

import os
import sys

from flask import Flask

from pyngrokexampleflask.routes import route_blueprint


def init_webhooks(base_url):
    # ... Implement updates necessary so inbound traffic uses the public-facing ngrok URL
    pass


def create_app():
    app = Flask(__name__)

    # Initialize your ngrok settings into Flask
    app.config.from_mapping(
        BASE_URL="http://localhost:8000",
        USE_NGROK=os.environ.get("USE_NGROK", "False") == "True" and os.environ.get("WERKZEUG_RUN_MAIN") != "true"
    )

    if app.config["USE_NGROK"]:
        # Only import pyngrok and install if we're actually going to use it
        from pyngrok import ngrok

        # Get the dev server port (defaults to 8000, can be overridden with `--port`
        # when starting the server
        port = sys.argv[sys.argv.index("--port") + 1] if "--port" in sys.argv else "8000"

        # Open a ngrok tunnel to the dev server
        public_url = ngrok.connect(port).public_url
        print(f" * ngrok tunnel \"{public_url}\" -> \"http://127.0.0.1:{port}\"")

        # Update any base URLs or webhooks to use the public ngrok URL
        app.config["BASE_URL"] = public_url
        init_webhooks(public_url)

    # ... Implement Blueprints and the rest of your app
    app.register_blueprint(route_blueprint)

    return app


if __name__ == '__main__':
    create_app().run(host='0.0.0.0', port=8000)
