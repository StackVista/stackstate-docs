---
description: Get started with sending events to StackState from an external system.
---


# External Events tutorial

This tutorial shows you how to send events from external systems to StackState.

StackState creates a real-time map over your IT landscape and tracks all changes that occur. These changes are visible as events in the [Events Perspective](/use/views/events_perspective.md).

This tutorial shows how you can submit external events to StackState.

## Setup

[This repository](https://github.com/StackVista/custom-events-tutorial) contains a sample project with a [Puppet](https://puppet.com/) report processor that sends events to StackState. A [report processor](https://puppet.com/docs/puppet/7.0/reporting_about.html) in Puppet processes a report of a Puppet configuration run.

In our example, the report processor will send an event to StackState that is related to the host Puppet runs on.

The project uses [Vagrant](https://www.vagrantup.com/) to provision a virtual machine with puppet and the sample report processor installed.

Clone the repository to your laptop to get started.

## Preparing StackState

Before you get started, StackState must be configured to handle the data we will be sending from the sample project. The project sends data in a format that is consumed by the built-in **Agent v2 StackPack**. After installing this StackPack, StackState will know how to interpret the sample data.

The virtual machine in the sample project already has the StackState agent installed.

## Preparing the tutorial

First, boot the virtual machine using Vagrant:

```text
vagrant up
```

Vagrant will download a virtual machine image and start and provision a virtual machine. When it is finished, you can log into the machine using the command:

```text
vagrant ssh
```

The rest of this tutorial assumes you run the sample as the `root` user. Use the following command to change to `root` in your virtual machine:

```text
sudo su -
```

Before running the example, you need to configure the sample project with your StackState instance URL and API key.

```text
export STS_API_KEY=my-api-key
export STS_STS_URL=https://stackstate.acme.com/stsAgent
```

That's it, you are now ready to run the sample.

## Running the example

The sample project is shipped with a single `run.sh` script that does the following:

* checks for the presence of the `STS_STS_URL` and `STS_API_KEY` environment variables
* places the environment variables in the correct configuration files
* installs the StackState agent if it isn't already installed
* starts the StackState agent if it isn't already started
* invokes Puppet to make some configuration changes to the virtual machine

Now, go ahead and trigger the script:

```text
./run.sh
```

Once the Puppet run is finished, the report processor is invoked and formats a JSON message that it sends to StackState. You can see the code [here]().

In StackState's Event Perspective, this is what the event looks like:

![](/.gitbook/assets/example-event-perspective.png)

## Submitting external events directly

If you don't have access to Vagrant, you can also submit the JSON to StackState directly using the following command:

```text
TS=`date +%s`; cat event.json | sed -e "s/##TIMESTAMP##/$TS/" | curl -H "Content-Type: application/json" -X POST -d @- ${STS_STS_URL}/intake/\?api_key\=${STS_API_KEY}
```

**NOTE**: if you execute this command locally instead of on the virtual machine, make sure you have the environment variables set properly.

For these events to appear in StackState, the component representing the virtual machine must be present with the identifier `urn:host:/localhost.localdomain`.

## Terminating the virtual machine

If you are done running the example, exit the shell and use the following command to terminate the virtual machine:

```text
vagrant destroy
```

## Cleaning your StackState instance

When you are done with this tutorial, you can remove the configuration from your StackState instance as follows:

* Uninstall the **Agent v2 StackPack**. This will remove the configuration and data received \(topology\) from StackState.
