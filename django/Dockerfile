# Working Dockerfile for a Django Project #

# Multistage Dockerfile 
FROM python:3.10 as builder
ENV PIP_NO_CACHE_DIR=1
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install --user -r requirements.txt && pip install --user pycurl

FROM python:3.10-slim-bullseye AS final
ENV PATH=/root/.local/bin:$PATH
WORKDIR /app
RUN useradd -r -u 1000 -d /app -s /sbin/nologin -c "Docker image user" dspin
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  libcurl4 libnghttp2-14 librtmp1 libssh2-1 libpsl5 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
COPY --chown=dspin:dspin --from=builder /root/.local /root/.local
COPY --chown=dspin:dspin . .

# ## Slim Dockerfile
# FROM python:3.10-slim-bullseye
# ENV PIP_NO_CACHE_DIR=1
# WORKDIR /app
# RUN useradd -r -u 1000 -d /app -s /sbin/nologin -c "Docker image user" dspin
# RUN apt-get update &&  apt-get -y install libcurl4 libnghttp2-14 librtmp1 libssh2-1 libpsl5
# COPY --chown=dspin:dspin requirements.txt requirements.txt
# RUN pip install -r requirements.txt && rm requirements.txt
# COPY --chown=dspin:dspin . .
# CMD [ "uvicorn", "config.asgi:application", "--host", "0.0.0.0", "--port", "8000" ]
