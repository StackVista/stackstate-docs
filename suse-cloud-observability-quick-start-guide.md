---
description: SUSE Cloud Observability
---

# SUSE Cloud Observability quick start guide

## Overview

After purchasing SUSE Cloud Observability from the Cloud Provider Marketplace, your SUSE Cloud Observability environment is provisioned.

You will receive an email from SUSE Cloud Observability with the required login details and links to your environment. This quick start guide will help you get started and get your own data into your SUSE Cloud Observability deployment.

## Getting Started - First Steps

1. Setup a password
2. Login to your SUSE Cloud Observability Instance
3. Install SUSE Observability agent to your cluster
4. Change your personal account details

### Setup a password

The email from SUSE Cloud Observability contains a unique link which allows you to set your initial password on the account.  This must be performed before you can login and configure the observability environment.

### Accessing your SUSE Observability Environment

Login in to your SUSE Cloud Observability environment by clicking on the unique link in the email you received from SUSE Cloud Observability.  Entering your password will take you to the configuration screen in order to add clusters.

### Install SUSE Observability agent to your cluster

SUSE Cloud Observability uses StackPacks in order to make it easier to configure your downstream clusters and get data into the observability environment.

Initially you should be taken to the following screen, to get here, in the SUSE Observability UI, open the main menu by clicking in the top left of the screen and go to `StackPacks` > `Kubernetes`.

![SUSE Cloud Observability - StackPacks](/.gitbook/assets/integrating_first_cluster_stackpacks.png)

Once you are in the Kubernetes StackPack screen, it is very simple to add a cluster to the observability environment.

Enter a name for the cluster you wish to observe, it does not have to match the cluster name used in 'kubeconfig'.

The Kubernetes cluster name must start and end with a lower case letter or digit and can consist of only lower case letters, digits, dots and dashes (. -)

Enter the name and click the `Install` button.  This should take you to the following screen with the cluster flagged as 'Waiting for data'

![SUSE Cloud Observability - Adding A Cluster](/.gitbook/assets/integrating_first_cluster_eks.png)

Click on the cluster name, this will expand this section and reveal a series of information including prerequisits and commands which can be used on your existing clusters to add them to your observability environment.

Review the information and ensure you have the correct permissions to your Kubernetes environment, ensure you are running a supported version of Kubernetes.

These commands are unique to your observability deployment and include the required API Keys and URLs.  Select the approriate commands for your cluster, there are sections for EKS, RKE, generic Kubnernetes cluster and many more.

These commands will install the SUSE Cloud Obervability agents and connect the cluster to your SUSE Cloud Observability environment.

You can use the commands directly from the UI or you can deploy to your downstream clusters by following the commands provided in the 'Deploy the StackState Agent and Cluster Agent' section in the [quick-start guide](k8s-quick-start-guide.md)

![SUSE Cloud Observability - Post Install](/.gitbook/assets/integrating_first_cluster_eks_after_agent_install.png)

After the the cluster has been connected, there should be a green tick in the SUSE Cloud Observability UI.

At this point you can begin exploring your data.

### Change your personal account details

Step 4 from your email is to update your personal information.  Click the unique link from the email and add your basic personal details as needed.  You can also setup 2FA authentication from this section if required.

### Explore your data

To start exploring your data, open the main menu by clicking in the top left of the screen and go to `Kubernetes` to reveal a list of observable items.

![SUSE Cloud Observability - Exploring Your Data](/.gitbook/assets/accessing_views_1.png)

Select 'Clusters' from the infrastructure section which should show a list of monitored clusters, select your cluster to reveal one of the many built in views.

![SUSE Cloud Observability - Cluster View](/.gitbook/assets/accessing_views_2.png)

At this point you can start exploring the data for your cluster or add more clusters from which to gather data. 

For further information on how to use SUSE Cloud Observability, including creating custom views please see the standard documentation.


### SUSE Cloud Observability Limitations

Note that SUSE Cloud Observability does not provide out of the box RED signals (Rate, Errors and Duration), only the Rate signal is shown.  This feature is available with SUSE Rancher Prime.
Customers that need these signals to have a complete Observability solution should contact SUSE to discuss SUSE Rancher Prime, alternatively this data can be collected using the OpenTelemetry collectors.

## Additional Information

For further information, including prerequisites and supported Kubernetes versions for your platform, please refer to the [quick start guide](./k8s-quick-start-guide.md).

---

