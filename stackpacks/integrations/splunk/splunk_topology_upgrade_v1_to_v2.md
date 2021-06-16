---
description: StackState core integration
---

# Splunk topology upgrade V1 to V2

## Overview

The Splunk topology integration can now also run through [StackState Agent V2](/stackpacks/integrations/agent.md). If you are starting from scratch, read how to set up [Splunk topology V2](/stackpacks/integrations/splunk/splunk_topology_v2.md). If you have [Splunk topology V1](/stackpacks/integrations/splunk/splunk_topology.md) running on the [API-Integrations Agent](/stackpacks/integrations/api-integration.md), this guide will help you migrate to the new StackState Agent V2.

## Upgrade steps

1. Install [StackState Agent V2](/stackpacks/integrations/agent.md) in a location that can connect to both StackState and Splunk.
2. Stop the API-Integration Agent
3. Move the Splunk topology API-Integration configuration file to the newly installed StackState Agent V2.
   ```
   mv /etc/sts-agent/conf.d/splunk_topology.yaml /etc/stackstate-agent/conf.d/splunk_topology.d/conf.yaml
   ```
4. Edit `/etc/stackstate-agent/conf.d/splunk_topology.d/conf.yaml` and replace all occurrence of:
   - `default_polling_interval_seconds` to `min_collection_interval`
   - `polling_interval_seconds` to `min_collection_interval`
5. Save the file.
6. Restart StackState Agent V2 to apply the configuration changes.
7. If you have other integrations configured on API_integration agent, start it.
