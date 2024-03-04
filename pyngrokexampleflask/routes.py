__copyright__ = "Copyright (c) 2023-2024 Alex Laird"
__license__ = "MIT"

from flask import Blueprint

route_blueprint = Blueprint('route', __name__, )


@route_blueprint.route('/healthcheck', methods=['GET'])
def get_healthcheck():
    return '{"server": "up"}', 200
