---
description: StackState Kubernetes Troubleshooting
---

# Monitors

## Overview

This section describes the out of the box monitors delivered with StackState. Monitors delivered with the product are added constantly. Have a look under the Monitors section in the main menu to find the full list.

## Out of the box Kubernetes monitors

### Available service endpoints 

It is important to ensure that your services are available and accessible to users. To monitor this, StackState has set up a check that verifies if a service has at least one endpoint available. Endpoints are network addresses that enable communication between different components in a distributed system, and they need to be available for the service to function properly.
If there is an occurrence of zero endpoints available within the last 10 minutes, the monitor will remain in a deviating state, indicating that there may be an issue with the service that needs to be addressed.

### HTTP - 5xx error ratio

HTTP responses with a status code in the 5xx range indicate server-side errors such as a misconfiguration, overload or internal server errors.
To ensure a good user experience, the percentage of 5xx responses should be less than 5% of the total HTTP responses for a Kubernetes (K8s) service.

### HTTP - response time - Q95 is above 3 seconds

It is important to keep an eye on the HTTP response times for a Kubernetes service. StackState monitors the 95th percentile response time, or Q95, which is a statistical measure indicating that 95% of the responses are faster than this time.
This is a useful measure for identifying outliers and slow requests that may negatively impact the user experience. If the Q95 response time is above 3 seconds during a specified time window, the monitor will produce a notification indicating a deviating state. 

### Kubernetes volume usage trend over 12 hours

It is important to monitor the usage of Persistent Volume Claims (PVCs) in your Kubernetes cluster. PVCs are used to store data that needs to persist beyond the lifetime of a container, and it's crucial to ensure that they have enough space to store the data.To track this, StackState has set up a check that uses linear prediction to forecast the Kubernetes volume usage trend over a 12-hour period. If the trend indicates that the PVCs will run out of space within this time frame, you will receive a notification, allowing you to take action to prevent data loss or downtime.

### Kubernetes volume usage trend over 4 days

It is important to monitor the usage of Persistent Volume Claims (PVCs) in your Kubernetes cluster over time. PVCs are used to store data that needs to persist beyond the lifetime of a container, and it's crucial to ensure that they have enough space to store the data.
To track this, StackState set up a check that uses linear prediction to forecast the Kubernetes volume usage trend over a 4-day period. If the trend indicates that the PVCs will run out of space within this time frame, you will receive a notification, allowing you to take action to prevent data loss or downtime.

### Out of memory for containers

It is important to ensure that the containers running in your Kubernetes cluster have enough memory to function properly. Out of memory (OOM) conditions can cause containers to crash or become unresponsive, leading to restarts and potential data loss.
To monitor for these conditions, StackState set up a check that detects and reports OOM events in the containers running in the cluster. This check will help you identify any containers that are running out of memory and allow you to take action to prevent issues before they occur.

### Pod Readiness 

Checks if a Pod that has been scheduled is running and ready to receive traffic within the expected amount of time.

### Pods in Waiting State

If a pod is within a waiting state and contains a reason of CreateContainerConfigError, CreateContainerError, CrashLoopBackOff, or ImagePullBackOff it will be seen as deviating.

### Replicaset desired replicas

It is important to ensure that the desired number of replicas for your ReplicaSet (and Deployment) is being met. ReplicaSets and Deployments are used to manage the number of replicas of a particular pod in a Kubernetes cluster.

To monitor this, StackState has set up a check that verifies if the available replicas match the desired number of replicas. This check will only be applied to ReplicaSets and Deployments that have a desired number of replicas greater than zero.

- If the number of available replicas is less than the desired number, the monitor will signal a DEVIATING health state, indicating that there may be an issue with the ReplicaSet or Deployment.
- If the number of available replicas is zero, the monitor will signal a CRITICAL health state, indicating that the ReplicaSet or Deployment is not functioning at all.

Additionally, the health state of the ReplicaSet will propagate to the Deployment for more comprehensive monitoring.

### Restarts for containers

It is important to monitor the restarts for each container in a Kubernetes cluster. Containers can restart for a variety of reasons, including issues with the application or the infrastructure.
To ensure that the application is running smoothly, StackState has set up a monitor that tracks the number of container restarts over a 10-minute period. If there are more than 3 restarts during this time frame, the container's health state will be set to DEVIATING, indicating that there may be an issue that needs to be investigated.

### Statefulset desired replicas

It is important that the desired number of replicas for a StatefulSet is being met. StatefulSets are used to manage stateful applications and require a specific number of replicas to function properly.

To monitor this, StackState has set up a check that verifies if the available replicas match the desired number of replicas. This check will only be applied to StatefulSets that have a desired number of replicas greater than zero.

- If the number of available replicas is less than the desired number, the monitor will signal a DEVIATING health state, indicating that there may be an issue with the StatefulSet.
- If the number of available replicas is zero, the monitor will signal a CRITICAL health state, indicating that the StatefulSet is not functioning at all.


## See also

* [Monitors](use/alerting/k8s-monitors.md)
