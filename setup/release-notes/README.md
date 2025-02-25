---
description: SUSE Observability Self-hosted
---

# Release Notes

Check the release notes for the latest features, enhancements, and bug fixes in SUSE Observability.

# Release Strategy

## Overview

This section outlines the release strategy for SUSE Observability, including its core components:

- SUSE Observability Platform (Helm Chart)
- SUSE Observability Agents (Helm Chart)
- SUSE Observability Rancher UI Extension

The goal of this strategy is to ensure users always have access to the latest features, security updates, and
compatibility across all components.

## Release Cadence

Each component follows a rolling release model, with no fixed cadence:

- SUSE Observability Platform: Regularly updated to introduce new features, enhancements, and stability improvements.
- SUSE Observability Agents: Released as frequently as necessary, especially for security patches and performance optimizations.
- SUSE Observability Rancher UI Extension: Updated alongside major platform releases (Rancher and SUSE Observability) to maintain compatibility and user experience.

## Compatibility Guidelines

- The latest SUSE Observability Agent is always recommended, as it includes critical security fixes and performance improvements.
- The latest Agent is compatible with all supported versions of the SUSE Observability Platform.
- Users should ensure they are running the recommended version of the SUSE Observability Rancher UI Extension
  corresponding to their Platform version.

## Upgrade Recommendations

### SUSE Observability Agents

- Always upgrade to the latest version to benefit from security fixes and performance enhancements.
- Agents are designed to be backward-compatible with all supported Platform versions.
- Review release notes for an overview of changes made before upgrading.

### SUSE Observability Platform

- Upgrade to newer versions as they become available to gain access to new features and stability improvements.
- Review release notes for potential breaking changes before upgrading.

### SUSE Observability Rancher UI Extension

- Ensure the UI extension version matches the recommended version for your Rancher deployment.
    - See the UI extension and Rancher compatibility matrix [here](../../k8s-suse-rancher-prime.md#suse-observability-rancher-ui-extension-compatibility-matrix).
- Upgrades and compatibility are typically aligned with Rancher and SUSE Observability platform releases.

## Support Policy

- Latest SUSE Observability Agent versions are fully supported.
- Previous SUSE Observability Platform versions receive support for a defined period, typically covering the latest release and the two most recent patch versions. Upgrading to the latest version is strongly encouraged.
- Security patches will be prioritized for the latest releases of all components.

For questions or upgrade guidance, please reach out to our support team.
