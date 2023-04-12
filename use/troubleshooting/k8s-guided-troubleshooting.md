---
description: StackState for Kubernetes troubleshooting
---
# What is guided troubleshooting?

## Overview

Guided troubleshooting with StackState is a powerful approach to accelerate issue resolution by offering targeted, actionable insights throughout the troubleshooting process. By leveraging advanced algorithms, StackState provides troubleshooting hints, visual assistance, and step-by-step guidance tailored to your specific environment. This not only streamlines the process of identifying and resolving issues but also empowers Site Reliability Engineers (SREs) to better support their development teams.

By utilizing StackState's guided remediation, engineers can ensure consistent, high-quality services, and share their expertise with other team members. Furthermore, our remediation guides can be easily extended or modified to adapt to your unique environment, making them an invaluable tool for maintaining service reliability and performance.

Pre-configured monitors that look at the right things and issue alerts at the right time are enriched with clear hints to enable engineers to remediate the issues. This guidance helps every engineer immediately understand what needs to happen in order to remediate. In addition, after the issue is solved, this information will support the process of a blameless post-mortem to determine what needs to be improved.

## Remediating issues with guided troubleshooting

To remediate quickly StackState has a clear problem report and remediation guide packaged in a single screen. It contains the following items:
1. A brief description to explain to people who are less familiar with what it actually is.
2. Some facts on this problem such as Health State, triggered time and a reason if present.
3. The supporting metric indicates how the issue evolved over time.
4. Often, issues don’t happen in isolation. Sometimes they cause other issues, or the real problem is caused by a different component. StackState keeps track of how all components are related and warns you about related issues.
5. The remediation guide itself guides you through the problem resolution step by step.

![](../../.gitbook/assets/k8s/guided-troubleshooting.png)