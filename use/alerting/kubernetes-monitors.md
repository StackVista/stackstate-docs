---
description: StackState Kubernetes Troubleshooting
---

# Monitors

## Overview

This section describes the out-of-the-box monitors delivered with StackState. Monitors delivered with the product are added constantly. Have a look under the Monitors section in the main menu to find the full list.

## Out of the box Kubernetes monitors

### Available service endpoints

It is important to ensure that your services are available and accessible to users. To monitor this, StackState has set up a check that verifies if a service has at least one endpoint available. Endpoints are network addresses that enable communication between different components in a distributed system, and they need to be available for the service to function properly.
If there is an occurrence of zero endpoints available within the last 10 minutes, the monitor will remain deviating, indicating that there may be an issue with the service that needs to be addressed.
Allows [Override Monitor arguments](/use/alerting/k8s-override-monitor-arguments.md)

### Cpu limits resourcequota

Users create resources (pods, services, etc.) in the namespace, and the quota system tracks usage to ensure it does not exceed hard resource limits for Cpu defined in a ResourceQuota. The monitor will alert when the total Cpu limits in the namespace gets to 90% or more of the established by the quota. Each `resourcequota` in the namespace produces a monitor health state.

### Cpu requests resourcequota
Users create resources (pods, services, etc.) in the namespace, and the quota system tracks usage to ensure it does not exceed hard resource requests for Cpu defined in a ResourceQuota. The monitor will alert when the total Cpu requests in the namespace gets to 90% or more of the established by the quota. Each `resourcequota` in the namespace produces a monitor health state.

### Daemonset desired replicas

It is important that the desired number of replicas for a Daemonset is being met. Daemonsets are used to manage a set of pods that need to run on all or a subset of nodes in a cluster, ensuring that a copy of the pod is running on each node that meets the specified criteria. This is useful for tasks such as logging, monitoring, and other cluster-level tasks that need to be executed on every node in the cluster. To monitor this, StackState has set up a check that verifies if the available replicas match the desired number of replicas. This check will only be applied to DaemonSets that have a desired number of replicas greater than zero. - If the number of available replicas is less than the desired number, the monitor will signal a DEVIATING health state, indicating that there may be an issue with the StatefulSet. - If the number of available replicas is zero, the monitor will signal a CRITICAL health state, indicating that the StatefulSet is not functioning at all. To understand the full monitor definition check the details.

### Deployment desired replicas

It is important that the desired number of replicas for a Deployments is being met. Deployments are used to manage the deployment and scaling of a set of identical Pods in a Kubernetes cluster. By ensuring that the desired number of replicas is running and available, Deployments can help maintain the availability and reliability of a Kubernetes application or service. To monitor this, StackState has set up a check that verifies if the available replicas match the desired number of replicas. This check will only be applied to Deployments that have a desired number of replicas greater than zero. - If the number of available replicas is less than the desired number, the monitor will signal a DEVIATING health state, indicating that there may be an issue with the Deployments. - If the number of available replicas is zero, the monitor will signal a CRITICAL health state, indicating that the StatefulSet is not functioning at all. To understand the full monitor definition check the details.


### HTTP - 5xx error ratio

HTTP responses with a status code in the 5xx range indicate server-side errors such as a misconfiguration, overload or internal server errors.
To ensure a good user experience, the percentage of 5xx responses should be less than 5% of the total HTTP responses for a Kubernetes (K8s) service.

### HTTP - response time - Q95 is above 3 seconds

It is important to keep an eye on the HTTP response times for a Kubernetes service. StackState monitors the 95th percentile response time, or Q95, which is a statistical measure indicating that 95% of the responses are faster than this time.
This is a useful measure for identifying outliers and slow requests that may negatively impact the user experience. If the Q95 response time is above 3 seconds during a specified time window, the monitor will produce a notification indicating a deviating state. 

### Kubernetes volume usage trend over 12 hours

It is important to monitor the usage of Persistent Volume Claims (PVCs) in your Kubernetes cluster. PVCs are used to store data that needs to persist beyond the lifetime of a container, and it's crucial to ensure that they have enough space to store the data. To track this, StackState has set up a check that uses linear prediction to forecast the Kubernetes volume usage trend over a 12-hour period. If the trend indicates that the PVCs will run out of space within this time frame, you will receive a notification, allowing you to take action to prevent data loss or downtime.

### Kubernetes volume usage trend over 4 days

It is important to monitor the usage of Persistent Volume Claims (PVCs) in your Kubernetes cluster over time. PVCs are used to store data that needs to persist beyond the lifetime of a container, and it's crucial to ensure that they have enough space to store the data.
To track this, StackState set up a check that uses linear prediction to forecast the Kubernetes volume usage trend over a 4-day period. If the trend indicates that the PVCs will run out of space within this time frame, you will receive a notification, allowing you to take action to prevent data loss or downtime.

### Memory limits resourcequota
Users create resources (pods, services, etc.) in the namespace, and the quota system tracks usage to ensure it does not exceed hard resource limits for memory defined in a ResourceQuota. The monitor will alert when the total memory limits in the namespace gets to 90% or more of the established by the quota. Each `resourcequota` in the namespace produces a monitor health state.

### Memory requests resourcequota
Users create resources (pods, services, etc.) in the namespace, and the quota system tracks usage to ensure it does not exceed hard resource requests for memory defined in a ResourceQuota. The monitor will alert when the total memory requests in the namespace gets to 90% or more of the established by the quota. Each `resourcequota` in the namespace produces a monitor health state.

### Node Disk Pressure

Node disk pressure refers to a situation where the disks connected to a node experience excessive strain. While encountering node disk pressure is unlikely due to Kubernetes' built-in preventive measures, it can still occur sporadically. There are two primary reasons why node disk pressure may arise. The first reason relates to Kubernetes failing to clean up unused images. Under normal circumstances, Kubernetes regularly checks for and deletes any images that are not in use. Therefore, this is an uncommon cause of node disk pressure, but it should be acknowledged. The more probable issue involves the accumulation of logs. In Kubernetes, logs are typically saved in two scenarios: when containers are running and when the most recently exited container's logs are retained for troubleshooting purposes. This approach aims to strike a balance between preserving important logs and discarding unnecessary ones over time. However, if a long-running container generates an extensive volume of logs, they may accumulate to the point where they overload the node disk's capacity. To understand the full monitor definition check the details.
Allows [Override Monitor arguments](/use/alerting/k8s-override-monitor-arguments.md)

### Node Memory Pressure

Node memory pressure refers to a situation where the memory resources on a Kubernetes node are excessively strained. While encountering node memory pressure is uncommon due to Kubernetes' built-in resource management mechanisms, it can still occur under specific circumstances. There are two primary reasons why node memory pressure may arise. The first reason is related to misconfigured or insufficient resource requests and limits for containers running on the node. Kubernetes relies on resource requests and limits to allocate and manage resources effectively. If containers are not accurately configured with their memory requirements, they may consume more memory than expected, leading to node memory pressure. The second reason involves the presence of memory-intensive applications or processes. Certain workloads or applications may have higher memory demands, resulting in increased memory utilization on the node. If multiple pods or containers with substantial memory requirements are scheduled on the same node without proper resource allocation, it can cause memory pressure. To mitigate node memory pressure, it is crucial to review and adjust resource requests and limits for containers, ensuring they align with the actual memory needs of the applications. Monitoring and optimizing memory usage within the applications themselves can also help reduce memory consumption. Additionally, consider horizontal pod autoscaling to dynamically scale the number of pods based on memory utilization. Regular monitoring, analysis of memory-related metrics, and proactive allocation of memory resources can help maintain a healthy memory state on Kubernetes nodes. It's essential to understand the specific requirements of your workloads and adjust resource allocation accordingly to prevent memory pressure and ensure optimal performance.
Allows [Override Monitor arguments](/use/alerting/k8s-override-monitor-arguments.md)

### Node PID Pressure

Node PID pressure occurs when the available process identification (PID) resources on a Kubernetes node are excessively strained. The first reason is related to misconfigured or insufficient resource requests and limits for containers running on the node. Kubernetes relies on accurate resource requests and limits to effectively allocate and manage resources. If containers are not configured correctly with their PID requirements, they may consume more PIDs than expected, resulting in node PID pressure. The second reason is the presence of PID-intensive applications or processes. Some workloads or applications have higher demands for process identification, leading to increased PID utilization on the node. If multiple pods or containers with significant PID requirements are scheduled on the same node without proper resource allocation, it can cause PID pressure. To address node PID pressure, it is important to review and adjust resource requests and limits for containers to ensure they align with the actual PID needs of the applications. Monitoring and optimizing PID usage within the applications themselves can also help reduce PID consumption. Additionally, considering horizontal pod autoscaling can dynamically scale the number of pods based on PID utilization. Regular monitoring, analysis of PID-related metrics, and proactive allocation of PID resources are crucial for maintaining a healthy state of PID usage on Kubernetes nodes. It is essential to understand the specific requirements of your workloads and adjust resource allocation accordingly to prevent PID pressure and ensure optimal performance.
Allows [Override Monitor arguments](/use/alerting/k8s-override-monitor-arguments.md)

### Node Readiness

Check if the Node is up and running as expected.
Allows [Override Monitor arguments](/use/alerting/k8s-override-monitor-arguments.md)

### Out of memory for containers

It is important to ensure that the containers running in your Kubernetes cluster have enough memory to function properly. Out-of-memory (OOM) conditions can cause containers to crash or become unresponsive, leading to restarts and potential data loss.
To monitor for these conditions, StackState set up a check that detects and reports OOM events in the containers running in the cluster. This check will help you identify any containers that are running out of memory and allow you to take action to prevent issues before they occur.
Allows [Override Monitor arguments](/use/alerting/k8s-override-monitor-arguments.md)

### Pod Ready State  

Checks if a Pod that has been scheduled is running and ready to receive traffic within the expected amount of time.

### Pod span duration

Monitors the duration of the server and consumer spans. When the 95th percentile of the duration is greater than the threshold (default 5000ms) the monitor has a Deviating state. This monitor supports overriding settings via [monitor argument overrides](/use/alerting/k8s-override-monitor-arguments.md).

### Pod span error ratio

Monitors the percentage of the server and consumer spans that have an error status. If the percentage of error spans exceeds the threshold (default 5) the monitor has a Deviating state. This monitor supports overriding settings via [monitor argument overrides](/use/alerting/k8s-override-monitor-arguments.md).

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

### Service span duration

Monitors the duration of the server and consumer spans. When the 95th percentile of the duration is greater than the threshold (default 5000ms) the monitor has a Deviating state. This monitor supports overriding settings via [monitor argument overrides](/use/alerting/k8s-override-monitor-arguments.md).

### Service span error ratio

Percentage of server and consumer spans that are in an error state for a Kubernetes service. This monitor supports overriding settings via [monitor argument overrides](/use/alerting/k8s-override-monitor-arguments.md).
      
### Statefulset desired replicas

It is important that the desired number of replicas for a StatefulSet is being met. StatefulSets are used to manage stateful applications and require a specific number of replicas to function properly.

To monitor this, StackState has set up a check that verifies if the available replicas match the desired number of replicas. This check will only be applied to StatefulSets that have a desired number of replicas greater than zero.

- If the number of available replicas is less than the desired number, the monitor will signal a DEVIATING health state, indicating that there may be an issue with the StatefulSet.
- If the number of available replicas is zero, the monitor will signal a CRITICAL health state, indicating that the StatefulSet is not functioning at all.


### Unschedulable Node

If you encounter a "NodeNotSchedulable" event in Kubernetes, it means that the Kubernetes scheduler was unable to place a pod on a specific node due to some constraints or issues with the node. This event occurs when the scheduler cannot find a suitable node to run the pod according to its resource requirements and other constraints.

## See also

* [Monitors](/use/alerting/k8s-monitors.md)
