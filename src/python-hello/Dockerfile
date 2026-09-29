# Matches the runtime image's Debian 12 / Python 3.11 so compiled wheels load.
FROM python:3.11-slim-bookworm AS build

COPY src/python-hello/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --target /opt/python-hello/packages -r /tmp/requirements.txt

# Debian's python3 ships without pip/setuptools, so only the app's packages end up in the SBOM.
FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /opt/python-hello/packages /opt/python-hello/packages
COPY src/python-hello/hello.py .
ENV PYTHONPATH=/opt/python-hello/packages
ENTRYPOINT ["python3", "hello.py"]
