# SBOM Submission Example

This repository contains a small .NET console app used to demonstrate container SBOM generation, SBOM-link attestations, and dependency submission with public GitHub Actions.

The app has direct NuGet dependencies that bring in transitive dependencies:

- `Humanizer`
- `Microsoft.Extensions.Hosting`
- `Newtonsoft.Json`
- `Serilog.Extensions.Hosting`
- `Serilog.Sinks.Console`

The workflow in `.github/workflows/dependency-submission.yml` mirrors the pattern used in larger service repositories:

1. Build and push a container image to GitHub Container Registry.
2. Generate an SPDX JSON SBOM from the pushed image with `anchore/sbom-action`.
3. Publish `sbom.spdx.json` as a run-specific GitHub release asset.
4. Create a custom attestation that links the container image digest to the SBOM release asset.
5. Verify the attestation, download the linked SBOM, verify its SHA-256 hash, and submit it to GitHub's dependency graph.

Run it manually from **Actions > Dependency Submission > Run workflow**.

The separate `.github/workflows/trivy-sbom.yml` workflow builds the container locally and generates `trivy-sbom.spdx.json` with Trivy. It uploads the file as a workflow artifact and does not publish or submit the SBOM. Run it manually from **Actions > Generate Trivy SBOM > Run workflow**.