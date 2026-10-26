ARG TAG=latest

FROM alexdlaird/pyngrok:$TAG AS build

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"

WORKDIR /app

COPY requirements.txt .

# Since /venv/bin is the first thing on the PATH, once we've installed into /venv, all subsequent
# usage of python will use the one installed in /venv. System site packages are included so the
# venv uses the pyngrok (and the ngrok binary it provisioned) that already come with the base image
RUN python3 -m venv --system-site-packages /venv
RUN python -m pip install --no-cache-dir -r requirements.txt

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
