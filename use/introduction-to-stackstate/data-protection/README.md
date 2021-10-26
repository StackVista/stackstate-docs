# Data protection features

The StackState platform aggregates and processes data from many different data sources and stores the results in its own data stores. To be able to collect the data some form of authentication is usually required in the form of a shared secret.

The pages in this section describe how the data is secured both in flight and at rest.

StackState has different ways in which it can be deployed and for those different deployments different data protection features are applicable.

First we discuss how the data flows through StackState and where it is stored. Next we discuss how the different components protected their data. The infrastructure running StackState is expected to provide a certain set of data protection features, which we discuss last.

{% page-ref page="data-flow-architecture.md" %}

{% page-ref page="data-per-component.md" %}

{% page-ref page="saas.md" %}

{% page-ref page="self-hosted.md" %}

