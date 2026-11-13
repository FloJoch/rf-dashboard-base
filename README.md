# rf-dashboard-base

Basis-Image mit `robotframework-dashboard[server]` und `psycopg2-binary` auf Grundlage von UBI9 / Python 3.12.

Das Image enthält nur öffentliche Pakete aus PyPI. Projektspezifische Dateien (z. B. eine eigene Datenbankklasse) werden in einem darauf aufbauenden Image ergänzt.

## Build

Der Build läuft über GitHub Actions:

- bei jedem Push auf `main` mit der Standardversion
- manuell über **Actions → build → Run workflow**, dort lässt sich die Version angeben

Ergebnis:

```
ghcr.io/<owner>/rf-dashboard-base:<version>
ghcr.io/<owner>/rf-dashboard-base:latest
docker.io/<dockerhub-user>/rf-dashboard-base:<version>
docker.io/<dockerhub-user>/rf-dashboard-base:latest
```

## Docker Hub

Für den Push auf Docker Hub im GitHub-Repo unter **Settings → Secrets and variables → Actions** anlegen:

- Variable `DOCKERHUB_USERNAME`: Docker-Hub-Benutzername
- Secret `DOCKERHUB_TOKEN`: Access Token aus Docker Hub (**Account settings → Personal access tokens**, Berechtigung *Read & Write*)

Das Repository `rf-dashboard-base` wird beim ersten Push automatisch angelegt (öffentlich, sofern in Docker Hub nicht anders eingestellt).

## Sichtbarkeit

Nach dem ersten Build unter **Packages → rf-dashboard-base → Package settings → Change visibility** auf **Public** stellen, damit das Image ohne Anmeldung gezogen werden kann.

## Lokal bauen

```
docker build --build-arg RFD_VERSION=2.5.0 -t rf-dashboard-base:2.5.0 .
```

## Verwendung

```dockerfile
FROM ghcr.io/<owner>/rf-dashboard-base:2.5.0

USER 0
WORKDIR /app
COPY postgres_db.py /app/postgres_db.py
RUN mkdir -p /app/robot_logs \
    && chgrp -R 0 /app \
    && chmod -R g=u /app
USER 1001

ENV RFD_PORT=8543
EXPOSE 8543
CMD ["sh", "-c", "exec robotdashboard --server \"0.0.0.0:${RFD_PORT}${RFD_AUTH:+:${RFD_AUTH}}\" --databaseclass postgres_db.py --uselogs true"]
```
