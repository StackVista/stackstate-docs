# Data per component

## Kafka

Kafka is used as a short-term storage and stores both topology and telemetry data. The stored data is not encrypted, instead it relies on the underlying disks to be encrypted.

Kafka is not configured with authentication but instead relies on limited accessibility of its API’s. See the deployment types in the next chapter on how this is guaranteed.

Data flowing in/out of Kafka is not encrypted in any form, neither is data flowing between Kafka nodes. StackState relies on limited network accessibility to prevent unauthorized access to the data.

{% hint style="info" %}
* Kafka does not support encrypting data at rest, though there are plans to implement full end-to-end encryption: [https://cwiki.apache.org/confluence/display/KAFKA/KIP-317%3A+Add+end-to-end+data+encryption+functionality+to+Apache+Kafka](https://cwiki.apache.org/confluence/display/KAFKA/KIP-317%3A+Add+end-to-end+data+encryption+functionality+to+Apache+Kafka)
* Kafka does support TLS encryption and authentication for both data flowing in/out of Kafka and for communication between its nodes.
{% endhint %}

## StackGraph

StackGraph stores both topology data and configuration. It uses HBase as the underlying database which uses HDFS to store its data. HDFS finally uses actual disks provided to Stackstate.

The stored data is not encrypted on any level, instead it relies on the underlying disks to be encrypted.

Data flowing in/out of StackGraph \(HBase\) is not encrypted in any form, neither is the data internally between the HBase and HDFS nodes. Access to the api’s of HBase is not secured with authentication, instead StackState relies on the network not being accessible to unauthorized users and applications. For HDFS authentication is enabled and required.

{% hint style="info" %}
* HBase does have support for authentication and authorization
* HDFS authentication can be improved by using Kerberos instead of username based only
* HDFS supports end-to-end encryption
* HBase supports encryption of data in-flight data as well, though it requires usage of Kerberos for authentication:[https://hbase.apache.org/book.html\#\_client\_side\_configuration\_for\_secure\_operation](https://hbase.apache.org/book.html#_client_side_configuration_for_secure_operation)
{% endhint %}

## Elasticsearch

Elasticsearch stores telemetry data \(i.e. metrics and events\). The stored data is not encrypted by Elasticsearch nor before storing it in Elasticsearch, instead StackState relies on encryption of the underlying storage system for securing the data.

Elasticsearch is not configured with authentication but instead relies on limited accessiblity of its API’s.

Data flowing in/out of Elasticsearch is not encrypted in any form, neither is data flowing between Elasticsearch nodes. StackState relies on limited network accessibility to prevent unauthorized access to the data.

{% hint style="info" %}
* Elasticsearch does not support encryption for stored data
* Elasticsearch does have support for authentication and TLS encryption of data flowing in/out of Elasticsearch and between its nodes.
{% endhint %}

## Agent/Receiver

The receiver is the component that accepts data coming from the StackState agent or any other data source that is pushing data to StackState. Authentication of the requests to the receiver is done via a so-called apiKey which acts as an authentication token.

TLS encryption of the receiver connections must be handled by the infrastructure \(see Infrastructure dependencies\) and is essential to keep the data protected.

Agents run on customer systems \(virtual machines etc..\) gather data and push it to StackState. When installing they are configured with the apiKey of the receiver and the public, TLS encrypted, HTTP endpoint of the receiver. They will use this to push data to StackState in a secure manner.

Agents often need credentials to connect to third-party systems to gather data. To store these credentials in a safe way the agent has a secret storage system that can be used, or it can make use of existing secret storage systems.

## StackState API / UI

The API and UI of StackState is hosted as part of the StackState deployment. They are protected by authentication \(username/password or auth tokens\) and authorization using fine-grained role-based access controls. StackState does keep track of changes \(it is using StackGraph, a versioned graph database\), however it does not include user information \(who did what\) and as such does not maintain an audit trail.

The connection is not encrypted, this is expected to be done by the infrastructure running StackState. See the deployment types in the next chapter for details.

The API doesn’t store any data itself. The UI uses cookies and the browsers local storage to store a limited amount of data. This is protected with the standard protection mechanisms browsers offer to only allow access to this data when visiting the StackState URL and no other websites.

## StackState plugins

StackState plugins fetch data from external systems and are configured to do so by the user or administrator of StackState. How that data is protected depends on the external system’s support for authentication/authorization and network encryption.

The advice is to configure StackState to only fetch data over TLS encrypted connections using a dedicated StackState account or role on the external system that has limited access rights \(I.e. only access to the data StackState needs\).

## Secret storage

StackState needs secrets \(auth tokens, credentials\) to connect to external systems to gather data. These secrets are configured via StackState’s UI and/or API and stored, in plain text, in StackGraph. They can also be retrieved in plain text via the API.

Configuration and retrieval of these secrets is restricted to users with authorization, by default only administrators. Next to this extra restriction the data protection discussed under StackGraph and Infrastructure dependencies apply as well.

## Other services

StackState’s services communicate only indirectly with each other, I.e. via Kafka, StackGraph or Elasticsearch. Therefore, no other data protection features are applicable.

## See also

* [Data flow architecture](data-flow-architecture.md)
* [Data protection features for SaaS](saas.md)
* [Data protection features for self-hosted StackState](self-hosted.md)

