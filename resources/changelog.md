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

## v50-small-changes

### 08-07-22

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