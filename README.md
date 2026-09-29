# SBOM Submission Example

This repository is a small monorepo used to demonstrate container SBOM generation, SBOM-link attestations, and dependency submission with public GitHub Actions. Each service has its own Dockerfile and container image:

- `src/SbomSubmissionExample`: a .NET console app with direct NuGet dependencies that bring in transitive dependencies:
  - `Humanizer`
  - `Microsoft.Extensions.Hosting`
  - `Newtonsoft.Json`
  - `Serilog.Extensions.Hosting`
  - `Serilog.Sinks.Console`
- `src/python-hello`: a Python script with a direct `requests` dependency that brings in transitive dependencies.

The workflow in `.github/workflows/dependency-submission.yml` mirrors the pattern used in larger service repositories. For each service, it runs these steps in a matrix:

1. Build and push the service's container image to GitHub Container Registry.
2. Generate an SPDX JSON SBOM from the pushed image with `anchore/sbom-action`.
3. Publish `sbom.spdx.json` as a run-specific GitHub release asset.
4. Create a custom attestation that links the container image digest to the SBOM release asset.
5. Normalize the generated SPDX dependency relationships, then verify the attestation, download the linked SBOM, verify its SHA-256 hash, and submit it to GitHub's dependency graph under the service's manifest file (`SbomSubmissionExample.csproj` or `requirements.txt`).

Run it manually from **Actions > Dependency Submission > Run workflow**.
