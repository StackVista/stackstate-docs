---
description: StackState Kubernetes Troubleshooting
---

# Write a remediation guide to help users troubleshoot issues

## Overview

StackState provides [monitors out of the box](/use/alerting/k8s-monitors.md), which provide monitoring on common issues that can occur in a Kubernetes cluster. These monitors also contain out of the box remediation guides which are meant to guide users in accurately troubleshooting issues. They are created using the best practices and community knowledge. Follow the indications on this page to learn how to write an effective remediation guide yourself.

## Guidelines 
Provide step by step instructions to guide a user in solving the issue detected by this monitor.

Try to provide step by step instructions.

Make sure the most likely cause is the first instructions, end so on.

If possible include links to get to the conclusions as fast as possible.

Try to format the guide in a structures way using:

- bullet points
- numbering
- short sentences
- paragraphs
- inline formatted examples

Avoid boilerplate like a table of contents since users want to follow the instructions while reading as less a possible.

Avoid over explanation of why things are happening, provide the evidence and links to supporting documentation if possible so the guide is short and to the point.

- If there are open ends (there might be difference causes which are still unknown) provide guidance for escalation of the issue. E.g. provide the user with a support link/ number, etc.

## Example
`
When a Kubernetes container has errors, it can enter into a state called CrashLoopBackOff, where Kubernetes attempts to restart the container to resolve the issue.
The container will continue to restart until the problem is resolved.Take the following steps to diagnose the problem:

### Pod Events

Check the pod events to identify any explicit errors or warnings.
1. Go to the "Events" section in the middle of the [Pod highlight page](/#/components/\{{ componentUrnForUrl \}})
2. Check if there is are events like "BackOff", "FailedScheduling", "FailedAttachVolume" or "OOMKilled" in the Alert Category by clicking on 'Alerts'.
3. You can see the details of the event (click on the event) to give more information about the issue.
4. If the 'Show related event' option is enabled all events of resources related to this resource like a deployment will also show up and can give you a clue if any change on them is causing this issue. You can see this by checking if there is a correlation between the time of a deployment and a change of behaviour seen by the metrics and events of this pod.
For easy correlation you can use 'shift'-'click' to add markers to the different graph, log and event widgets.
    
### Container Logs
Check the container logs for any explicit errors or warnings
Inspect the [Logs](/#/components/\{{ componentUrnForUrl \}}#logs) of all the containers in this pod.
Search for hints in the logs by:
1.  Looking for changes in logging pattern, by looking at the number of logs per time unit (The histogram bars).
    In many cases the change in pattern will indicate what is going on.
    You can click-drag on the histogram bars to narrow the logs displayed to that time-frame.
2.  Searching for "Error" or "Fatal" in the search bar.
3.  Looking at the logs around the time that the monitor triggered
    
### Recent Changes
Look at the pod age in the "About" section on the [Pod highlight page](/#/components/\{{ componentUrnForUrl \}}) to identify any recent deployments that might have caused the issue
1. The "Age" is shown in the "About" section on the left side of the screen
2. If the "Age" and the time that the monitor was triggered are in close proximity then take a look at the most recent deployment by clicking on [Show last change](/#/components/\{{ componentUrnForUrl \}}#lastChange).
`

## Dynamic content

Ovidiu continues writing here

**Dynamic links**

Go to the [highlight page](/#/components/\{{ componentUrnForUrl \}})

Go to the [topology](/#/components/{{ componentUrnForUrl }}/topology

Go to the [events](/#/components/{{ componentUrnForUrl }}/events

Go to the [metrics](/#/components/{{ componentUrnForUrl }}/metrics

**Contextual actions**

Inspect the [logs](/#/components/\{{ componentUrnForUrl \}}#logs) of all the containers in this pod.

Show the [last change](/#/components/\{{ componentUrnForUrl \}}#lastChange)

Show the [status](/#/components/\{{ componentUrnForUrl \}}#status)

Show the [configuration](/#/components/\{{ componentUrnForUrl \}}#configuration)
