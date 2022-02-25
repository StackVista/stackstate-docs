---
description: Data protection features for SaaS
---

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Storage

The SaaS is deployed on AWS EKS clusters (I.e. running on Kubernetes). Disks (volumes) are provided by AWS, EBS (Elastic Block Storage) and are encrypted by default.

The SaaS version of StackState runs with a minimum of 3 nodes for each data storing component and stores the data in at least 2 of those 3 nodes (I.e. 1 “original” and 1 copy). EBS storage by default will not fail if a single (physical) drive fails, but they are limited to a single AWS availability zone.

Backups are made daily (using a tool called Velero) of all volumes used to store data, so that includes Kafka, Elasticsearch and StackGraph data. They are stored in AWS S3 which replicates the data into multiple availability zones. Backups are kept for X days.

When a customer stops using StackState the services specifically running for the customer will be stopped and their volumes deleted from the Kubernetes cluster and with that automatically from AWS. At the same time all backups will be deleted

## Networking
Networking is setup per Kubernetes cluster, with possibly multiple customers running in the same cluster. Each cluster runs in its own private network (AWS VPC). Outgoing traffic can access the internet. Incoming traffic is restricted by firewall rules in the VPC (security groups in AWS) and only allow traffic over TLS encrypted connections to enter the cluster and only to the ingress controller.

Incoming traffic is only allowed via TLS encrypted connections, the TLS connection is terminated inside the cluster in an ingress controller. TLS versions accepted are 1.2 and 1.3, the certificates use Eliptic curve encryption (“ecdsa”) with a key size of 384 bits with and a lifetime of 90 days.

Each customer runs in his own Kubernetes namespace, Kubernetes networking (Calico) is used to restrict access to all the StackState components in such a way that they only accept connections from the namespace they are in. Direct network traffic between namespaces is not possible. All network traffic into and out of the namespace need to go via the load balancer and ingress controller.

![SaaS networking](/.gitbook/assets/data-protection-saas-networking.svg) 

## Authentication
Authentication is configured via OIDC with Keycloak as the authentication provider. It stores user passwords + salt as a PBKDF2 has with 20000 iterations.

## See also

* [Data flow architecture](/use/introduction-to-stackstate/data-protection/data-flow-architecture.md)
* [Data per component](/use/introduction-to-stackstate/data-protection/data-per-component.md)
* [Data protection features for self-hosted StackState](/use/introduction-to-stackstate/data-protection/self-hosted.md)
