# Changelog

Changes made to the docs site. Please try to keep up-to-date.

```commandline
## Branch name

[optional link to PR]()

* list stac-12345
* of stac-12346
* changes stac-12347
```

## phase-out-kots (22-07-2022)

[https://github.com/StackVista/stackstate-docs/pull/1099](https://github.com/StackVista/stackstate-docs/pull/1099)

- remove KOTS info

## v50-soc2-info (21-02-2022)

[https://github.com/StackVista/stackstate-docs/pull/1107](https://github.com/StackVista/stackstate-docs/pull/1107)

- SOC2/3 info link
- new docs front page

## v50-monitor-fixes (20-07-2022)

[https://github.com/StackVista/stackstate-docs/pull/1102](https://github.com/StackVista/stackstate-docs/pull/1102)

- small fixes to improve monitor docs

## v50-integration-extra-info (18-07-2022)

[https://github.com/StackVista/stackstate-docs/pull/1097](https://github.com/StackVista/stackstate-docs/pull/1097)

- Adjust info about metrics data retrieved on docker agent page

## STAC-17052-agent-debug-info (14-07-2022)

[https://github.com/StackVista/stackstate-docs/pull/1090](https://github.com/StackVista/stackstate-docs/pull/1090)

- Add debug info to agent pages (docker/linux/windows/k8s/openshift) - includes options to set log level


## v50-otel-for-saas (13-07-2022)

[https://github.com/StackVista/stackstate-docs/pull/1084](https://github.com/StackVista/stackstate-docs/pull/1084)

- Shuffle and edit OTEL info
- Make OTEL info available for SaaS docs

## agent-2-17-1 (11-07-2022)

[https://github.com/StackVista/stackstate-docs/pull/1081](https://github.com/StackVista/stackstate-docs/pull/1081)

- bump agent versions for 2.17.1 release



## v50-small-changes

### 21-07-2022

[https://github.com/StackVista/stackstate-docs/pull/1104](https://github.com/StackVista/stackstate-docs/pull/1104)

- Clearer info on configuring propagation functions in template

### 11-07-2022

[https://github.com/StackVista/stackstate-docs/pull/1077](https://github.com/StackVista/stackstate-docs/pull/1077)

Ravan hit some problems with the "end metrics over http" instructions. Discussed with Remco and Hasselbach.

- The endpoint that should be used is correct:
  - Linux: 
    - default - `http://<hostname>:7077/stsAgent`
    - with customer-defined reverse proxy: `<reverse-proxy-url>/<path-used-to-map-port-7077>/stsAgent`
  - Kubernetes:
    - `<ingress-url>/receiver/stsAgent`
  - The curl example only included the Linux endpoint - updated to make clearer
  - There is an additional endpoint `<ingress-url>/receiver/stsAgent/api/v1/series` that accepts a different payload format. This is not to be used, it is there only for backwards compatibility to accept datadog data.

Mo was looking for extra info about the Docker integration

- Added list of metrics retrieved by the Docker Agent for containers. Info comes from Zandre van Heerden