# Autonomous Anomaly Detector \(BETA\)

## What is the Autonomous Anomaly Detector StackPack?

{% hint style="info" %}
The Autonomous Anomaly Detector add-on is in **BETA**.
{% endhint %}

Anomaly detection identifies incidents in your fast-changing IT environment and provides insights into their root cause. This directs the attention of IT operators to the root cause of incidents.

Installing the Autonomous Anomaly Detector StackPack will enable the Autonomous Anomaly Detector \(AAD\). The AAD analyzes metric streams in search of any anomalous behavior based on its past. Upon detecting an anomaly, the AAD will mark the stream under inspection with an annotation that is easily visible in the StackState interface. An Anomaly Event for the incident will also be generated and stored, this can be inspected at a later date on the Events Perspective.

The AAD requires zero configuration. It is fully autonomous in selecting the metric streams it will apply anomaly detection to and the appropriate machine learning algorithms to use for each.

## How does the AAD decide what to work on?

The AAD scales to large environments by autonomously prioritizing metric streams based on its knowledge of the 4T data model and user feedback. Streams with the highest priority will be examined first. The prioritization of streams is computed by an algorithm that learns to maximize the probability of preventing an IT issue. To operate in large environments, attention must be allocated where it matters the most. The AAD achieves this based on its knowledge of streams that are intrinsically important \(such as KPIs and SLAs\), ongoing and historical issues, relations between streams and other relevant factors.

The stream selection algorithm works as follows:

* Components in Views that have the most stars are selected.
* From those components, only high priority metric streams are selected. See [how to set the priority for a stream](../../configure/telemetry/how_to_use_the_priority_field_for_components.md).
* Metric streams with a configured baseline will not be selected. See [anomaly detection with baselines](../../use/health-state-and-event-notifications/anomaly-detection-with-baselines.md).

You cannot directly control the stream selected, but you can steer the selection by starring Views and setting the priority of streams to `high`.

## How fast are anomalies detected?

The AAD ensures that prioritized metric streams are checked for anomalies in a timely fashion. Anomalies occurring in the highest prioritized metric streams are detected within about 5 minutes.

## How do I know what the AAD is working on?

The status UI of the AAD Kubernetes service provides various metrics and indicators, including details of what it is currently doing.

## Installation

### Prerequisites

The AAD StackPack can only be installed within a [Kubernetes setup](../../setup/installation/kubernetes_install/). Please make sure that this is supported by your StackState installation.

If you are not sure that you have a Kubernetes setup or would you like to know more, contact [StackState support](https://support.stackstate.com/hc/en-us).

### Install the Autonomous Anomaly Detector \(AAD\) StackPack

To install the AAD StackPack, simply press the install button. No other actions need to be taken.

## Uninstall the Autonomous Anomaly Detector \(AAD\) StackPack

To uninstall the AAD StackPack, simply press the uninstall button. No other actions need to be taken.

## Troubleshooting

The status UI provides details on the technical state of the AAD Kubernetes service. You can use it to retrieve information about scheduling progress, possible errors, the ML models selected and job statistics.

To access the status UI, one can run kubectl proxy.
```text
kubectl proxy  
```
The UI will be accessible by URL:
```text
http://localhost:8001/api/v1/namespaces/<namespace>/services/http:<release-name>-anomaly-detection:8090/proxy/
```
Optionally to access the status UI, the AAD service ingress can be configured for the anomaly-detection deployment \(for the details see [AAD Standalone Deployment](../../setup/installation/kubernetes_install/aad_standalone.md)\).

Common questions that can be answered in the status UI:

**Is the AAD Kubernetes service running?**  
If the status UI is accessible: The service is running.  
If the status UI is not available: Either the service is not running, or the Ingress has not been configured \(See the install section\).

**Can the AAD Kubernetes service reach StackState?**  
Check the status UI sections **Top errors** and **Last stream polling results**. Errors here usually indicate connection problems.

**Has the AAD Kubernetes service selected streams for anomaly detection?**  
The status UI section **Anomaly Detection Summary** shows the total time of all registered streams, if no streams are selected it will be zero.

**Is the AAD Kubernetes service detecting anomalies?**  
The status UI section **Top Anomalous Streams** shows the streams with the highest number of anomalies. No streams in this section means that no anomalies have been detected. The status UI section **Anomaly Detection Summary** shows other relevant metrics, such as total time of all registered streams, total checked time and total time of all anomalies detected.

**Is the AAD Kubernetes service scheduling streams?**  
The status UI tab **Job Progress** shows a ranked list of streams with scheduling progress, including the last time each stream was scheduled.

## Release Notes

Release notes for the [AAD StackPack](aad.md#aad-stackpack) and the [AAD Kubernetes service](aad.md#aad-kubernetes-service) are available below.

### AAD StackPack

#### AAD StackPack v0.7 BETA \(19-02-2021\)

* Autonomous Anomaly Detector service GA.

#### AAD StackPack v0.6 BETA \(13-10-2020\)

* Documentation fixes and minor maintenance work.

#### AAD StackPack v0.2.2 BETA \(04-09-2020\)

* Releasing Autonomous Anomaly Detector service BETA.

### AAD Kubernetes service

#### AAD Kubernetes service v4.3.0-pre.1 BETA

**Helm chart version**: 4.3.0-pre.1  
**Image tag**: 4.3.0-pre.1  
**Release date**: 2021-01-14

Changes in this version:

* Detecting long anomalies and level changes.

#### AAD Kubernetes service v4.2.0 BETA

**Helm chart version**: 4.1.27  
**Image tag**: 4.2.0-release  
**Release date**: 2020-12-11

Changes in this version:

* Performance, stability and other bug fixes.

#### AAD Kubernetes service v4.1.2 BETA

**Helm chart version**: 4.1.24  
**Image tag**: 4.1.2-release  
**Release date**: 2020-11-27

Changes in this version:

* Improved stream selection and ranking. Stream selection is able to handle timeouts gracefully. Stream ranking applies heuristic based stream prioritization.

#### AAD Kubernetes service v4.1.1 BETA

**Helm chart version**: 4.1.18  
**Image tag**: 4.1.1-release  
**Release date**: 2020-10-09

Changes in this version:

* Upgraded various ML libraries.
* Added support for username/password authentication.
* Improved model selection efficiency.
* Fixed various minor bugs.

#### AAD Kubernetes service v4.1.0 BETA

**Helm chart version**: 4.1.15  
**Image tag**: 4.1.0-release  
**Release date**: 2020-09-04

Changes in this version:

* Releasing Autonomous Anomaly Detector service BETA.
