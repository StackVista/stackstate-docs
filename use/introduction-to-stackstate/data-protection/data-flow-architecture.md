{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

# Data flow architecture

StackState process incoming data. Mainly via the agents, but instead of the agent it can also be other tools that send data to the receiver. StackState processes this data and makes it available via an API/UI to its users. All components involved in processing and storing the data are depicted in the below diagram.

![Data flow](/.gitbook/assets/data-protection-data-flow.svg)
 
Next to data flowing in and out of the data storing components (Kafka, StackGraph and Elasticsearch) all those components are distributed systems themselves, meaning that there is also data in-flight between the different parts (sub-components) of those components. See the next chapter for a detailed discussion of the components and data flowing between them.

StackState authentication can use external systems for authenticating like LDAP and OIDC. For a standard installation however StackState has standard users configured in its configuration file.

Finally, not in the diagram, are plugins of StackState. They are used to pull (instead of push) metrics and/or events from external data sources for which configuration is stored in StackGraph. This includes credentials and authentication tokens.

## See also

* [Data per component](/use/introduction-to-stackstate/data-protection/data-per-component.md)
* [Data protection features for SaaS](/use/introduction-to-stackstate/data-protection/saas.md)
* [Data protection features for self-hosted StackState](/use/introduction-to-stackstate/data-protection/self-hosted.md)
