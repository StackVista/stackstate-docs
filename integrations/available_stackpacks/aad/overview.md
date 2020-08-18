---
title: Overview
kind: documentation
---

## What is the Autonomous Anomaly Detector StackPack?

Anomaly detection helps to find incidents in your fast-changing IT environment and provides insight into the Root Cause. It also directs the attention of IT operators to interesting parts of the IT environment.

Installing this StackPack will enable the Autonomous Anomaly Detector which analyzes various data streams in search of any anomalous behaviour. Upon detecting an anomaly, the Anomaly Detector will mark the stream under inspection with an annotation that is easily visible on the StackState interface. Furthermore, an Anomaly Event will be generated for this incident that can be inspected at a later date on the Events Perspective.

Autonomous Anomaly Detection scales to large environments by prioritizing streams based on its knowledge of the IT environment. The streams with the highest priority will then be examined first. This priority of streams is computed by a machine learning algorithm that learns to maximize the probability that it will prevent an IT issue. It does this based on which streams are intrinsically important such as KPIs and SLAs, the ongoing and historical issues and the relations between streams among other factors. This way Autonomous Anomaly Detection can operate in large environments by allocating the attention where it matters the most.

Please consult the [Autonomous Anomaly Detector documentation](https://l.stackstate.com/stackpack-aad-docs-link) for more information.

## Configuration

StackState's Autonomous Anomaly Detection doesn't need manual configuration. It automatically finds the right machine learning algorithm for each data stream using AutoML. This is a collection of anomaly detection algorithms, the semantics of the data, correlations among data streams, user feedback, and historical IT incidents. Autonomous Anomaly Detection tries different ways to detect anomalies and finds the one that detects the most meaningful anomalies making sure it doesn't have false positives.

## Prerequisites

The Autonomous Anomaly Detector StackPack can only be installed within a Kubernetes setup. Please make sure that your StackState installation does support it.
Please [contact support](https://www.stackstate.com/company/contact/) if you are not sure that is the case or if you would like to know more.
