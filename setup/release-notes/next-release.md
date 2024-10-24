---
description: SUSE Observability Self-hosted
---

# v2.1.0 - xx/xx/2024

## Release Notes StackState version ... Helm Chart version 2.1.0

### New Features & Enhancements:
* Introduce a command-line accessible backup mechanism for the configuration of SUSE Observability. This replaces the previous export/import backup method, improving reliability of the restoration process.
* We only support Helm 3.13.1 and above. This was already the case but it was not enforced yet. Now it is.
* Added Node events and Persistent Volume Events on Cluster Resources.
* OpenTelemetry support is enabled by default.

### Bug Fixes:
* Fix StackGraph backups for mono deployments.\r\nSupport global storage class for StackGraph.
* Fix for major performance issue. The performance issue was introduced while switching to suse-observability which included an Hbase upgrade.

### Breaking Changes:
* Renamed auth-schema of OpenTelemetry Collector to `SuseObservability`

### Agent updates
* Fix sidecar injector for Suse-Observability
* Added the ability to install the Agent via a form in the Rancher App Catalog
* Fix bug that process agent could not start on Rockylinux is fixed.

### Agent breaking changes
* When migrating python checks from stackstate 5.0/6.0 to SUSE Observability, python schematics related code needs to be changed to pydantic".
