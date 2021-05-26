# CentOS

## Overview

The StackState Agent can be installed on CentOS. It runs checks that collect data from external systems and push this to StackState using the [StackState Agent StackPack](/stackpacks/integrations/agent.md).

The Agent is open source and available on github at [https://github.com/StackVista/stackstate-agent](https://github.com/StackVista/stackstate-agent).

## Setup 

### Prerequisites

The following versions are supported:

| OS | Release | Arch | Network Tracer| Status | Notes|
|----|---------|--------|--------|--------|--------|
| CentOS | 6 | 64bit | - | OK | Since version 2.0.2 |
| CentOS | 7 | 64bit | - | OK | - |

### Install



### Configure

The Agent can be configured to run checks that integrate with external systems. 

Configuration files for checks are located in the directory:

```
/etc/stackstate-agent/conf.d/
```

### Upgrade


## Commands



## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=agent).

## Uninstall


## Release notes


## See also

* [StackState Agent StackPack](/stackpacks/integrations/agent.md)