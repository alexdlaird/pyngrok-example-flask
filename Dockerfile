ARG TAG=latest

FROM alexdlaird/pyngrok:$TAG AS build

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"

WORKDIR /app

COPY requirements.txt .

RUN python3 -m pip install --no-cache-dir virtualenv
# Since /venv/bin is the first thing on the PATH, once we've installed in to /venv, all subsequent
# usage of python will use the one installed in /venv
RUN python3 -m virtualenv /venv
RUN python -m pip install --no-cache-dir -r requirements.txt pyngrok

######################################################################

FROM alexdlaird/pyngrok:$TAG AS pyngrok_example_flask

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"
ENV USE_NGROK=True

WORKDIR /app

COPY pyngrokexampleflask pyngrokexampleflask
COPY --from=build /venv /venv

EXPOSE 8000

CMD ["python", "-m", "pyngrokexampleflask.server"]
