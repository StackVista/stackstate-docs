---
description: Data protection features for self-hosted StackState
---

# Self-hosted StackState

## Self-hosted Kubernetes installation

Many different Kubernetes flavors can be used to deploy StackState on Kubernetes, however, the cluster is always responsible for providing the disks \(volumes\) and networking to StackState.

### Storage

For managed Kubernetes clusters like Amazon EKS, Azure EKS and Google’s Kubernetes Engine, it is typically trivial to enable disk encryption. For other clusters this is very dependent on the exact setup. In any case it is strongly advised to always enable disk encryption and make regular backups. The SaaS section above can be used as an example.

### Networking

For networking, it is suggested to use a similar configuration as described for SaaS. Most specifically disallowing any network traffic from other namespaces and using an ingress controller that handles TLS termination inside the cluster.

### Authentication

The default deployment of StackState ships with users and passwords defined in the configuration file of StackState. Passwords are stored as an \(insecure\) md5 hash.

## Self-hosted Linux installation

### Storage

The Linux installation relies on disks being available to the \(virtual\) machines running StackState. Disk encryption must be setup by the customer for the disks/volumes in use by StackState.

Periodic backups of the underlying filesystems should be made. Additionally, backups of configuration can be made via StackState’s API and StackGraph offers a backup mechanism as well.

### Networking

The StackState processes themselves don’t restrict network access. The \(virtual\) machines running StackState must run in a network that is only accessible to users that need to install, upgrade or maintain the StackState installation.

TLS encryption is not supported directly in StackState. User access to StackState and data flowing into StackState’s receiver must be protected with TLS by running a reverse proxy that does the TLS termination. This reverse proxy must be the only way to connect to StackState for anything not inside the same restricted network.

### Authentication

The default deployment of StackState ships with users and passwords defined in the configuration file of StackState. Passwords are stored as an \(insecure\) md5 hash.

Customers must consider integrating with their standard company-wide authentication mechanism using LDAP or OIDC. This offers both better security and a better user experience.

## See also

* [Data flow architecture](data-flow-architecture.md)
* [Data per component](data-per-component.md)
* [Data protection features for SaaS](saas.md)

