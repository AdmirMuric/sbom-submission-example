FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src
COPY src/SbomSubmissionExample/SbomSubmissionExample.csproj src/SbomSubmissionExample/
RUN dotnet restore src/SbomSubmissionExample/SbomSubmissionExample.csproj

COPY . .
RUN dotnet publish src/SbomSubmissionExample/SbomSubmissionExample.csproj \
    --configuration Release \
    --no-restore \
    --output /app/publish

# Matches the runtime image's Debian 12 / Python 3.11 so compiled wheels load.
FROM python:3.11-slim-bookworm AS python-build

COPY src/python-hello/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --target /opt/python-hello/packages -r /tmp/requirements.txt

FROM mcr.microsoft.com/dotnet/runtime:8.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=python-build /opt/python-hello/packages /opt/python-hello/packages
COPY src/python-hello/hello.py /opt/python-hello/hello.py
ENV PYTHONPATH=/opt/python-hello/packages

WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "SbomSubmissionExample.dll"]