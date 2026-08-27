FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src
COPY src/SbomSubmissionExample/SbomSubmissionExample.csproj src/SbomSubmissionExample/
RUN dotnet restore src/SbomSubmissionExample/SbomSubmissionExample.csproj

COPY . .
RUN dotnet publish src/SbomSubmissionExample/SbomSubmissionExample.csproj \
    --configuration Release \
    --no-restore \
    --output /app/publish

FROM mcr.microsoft.com/dotnet/runtime:8.0

WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "SbomSubmissionExample.dll"]