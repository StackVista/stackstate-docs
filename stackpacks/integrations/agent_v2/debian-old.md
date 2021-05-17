# Debian

## Overview

The StackState Debian Agent provides the following functionality:
- Reporting hosts, processes and containers
- Reporting all network connections between processes / containers including network traffic telemetry
- Telemetry for hosts, processes and containers

### Installation

This integration is a part of the [Agent V2 StackPack](/#/stackpacks/stackstate-agent-v2/), to install this integration follow the instructions provided there.

## Supported configurations

The StackState Agent is supported on the following platforms:

| OS | Release | Arch | Network Tracer| Status | Notes|
|----|---------|--------|--------|--------|--------|
| Debian | Wheezy (7) | 64bit | - | - | Needs glibc upgrade to 2.17 |
| Debian | Jessie (8) | 64bit | - | OK | - |
| Debian | Stretch (9) | 64bit | OK | OK | - |

Need help? Please contact [StackState support](https://support.stackstate.com/hc/en-us).
