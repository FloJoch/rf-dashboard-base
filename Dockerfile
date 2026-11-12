# Basis-Image fuer Robot Framework Dashboard (Server-Modus) mit PostgreSQL-Treiber
FROM registry.access.redhat.com/ubi9/python-312

ARG RFD_VERSION=2.5.0

LABEL org.opencontainers.image.title="rf-dashboard-base" \
      org.opencontainers.image.description="UBI9 Python 3.12 mit robotframework-dashboard[server] und psycopg2-binary" \
      org.opencontainers.image.licenses="MIT"

USER 0

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN pip install \
        "robotframework-dashboard[server]==${RFD_VERSION}" \
        psycopg2-binary \
    && robotdashboard --help > /dev/null

USER 1001
