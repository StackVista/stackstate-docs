---
description: Rancher Observability
---

# Notifications

Notifications in Rancher Observability are the way to notify third-party applications when a [monitor](../k8s-monitors.md) in Rancher Observability fires. Notifications intergrate with third-party applications like incident management tools (like PagerDuty or Opsgenie), ticketing systems (like JIRA, ServiceNow), or other collaboration platforms (like Slack). Other tools might refer to notifications as alerts.

Notifications are triggered by health state changes of monitors on Rancher Observability components. Via the configured notification channels the health, component and monitor information is sent to these external systems.
