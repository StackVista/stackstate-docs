# Data protection

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

The StackState platform aggregates and processes data from many different data sources and stores the results in its own data stores. To be able to collect the data  some form of authentication is usually required in the form of a shared secret.

The pages in this section describe how the data is secured both in flight and at rest.

StackState has different ways in which it can be deployed and for those different deployments different data protection features are applicable.

First we discuss how the data flows through StackState and where it is stored. Next we discuss how the different components protected their data. The infrastructure running StackState is expected to provide a certain set of data protection features, which we discuss last.

{% page-ref page="/use/introduction-to-stackstate/data-protection/data-flow-architecture.md" %}

{% page-ref page="/use/introduction-to-stackstate/data-protection/data-per-component.md" %}

{% page-ref page="/use/introduction-to-stackstate/data-protection/saas.md" %}

{% page-ref page="/use/introduction-to-stackstate/data-protection/self-hosted.md" %}
