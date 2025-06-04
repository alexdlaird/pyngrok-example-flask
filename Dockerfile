FROM alexdlaird/pyngrok AS build

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"

WORKDIR /app

COPY requirements.txt .

RUN python3 -m pip install --no-cache-dir virtualenv
RUN python -m virtualenv /venv
RUN python -m pip install --no-cache-dir -r requirements.txt pyngrok

######################################################################

FROM alexdlaird/pyngrok AS pyngrok_example_flask

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"
ENV USE_NGROK=True
ENV FLASK_APP=pyngrokexampleflask/server.py

WORKDIR /app

COPY pyngrokexampleflask pyngrokexampleflask
COPY --from=build /venv /venv

EXPOSE 5000

CMD ["/venv/bin/flask", "run"]
