### Prerequisites

- [Rancher Observability Agent V2](/#/stackpacks/stackstate-agent-v2/) installed on a machine that can connect to both ServiceNow (via HTTPS) and Rancher Observability.
- A running ServiceNow instance.
- A ServiceNow user with access to the ServiceNow REST API endopints described below.

**NOTE** - There is no support for Proxy and Certificate Configuration right now.

### REST API endpoints

The ServiceNow user configured in Rancher Observability Agent V2 must have access to read the ServiceNow `TABLE` API. The specific table names and endpoints used in the Rancher Observability integration are described below. All named REST API endpoints use the HTTPS protocol for communication.

| Table Name | REST API Endpoint | 
|:---|:---|
| change_request | `/api/now/table/change_request` |
| cmdb_ci  |  `/api/now/table/cmdb_ci` |
| cmdb_rel_type  |  `/api/now/table/cmdb_rel_type` |
| cmdb_rel_ci  |  `/api/now/table/cmdb_rel_ci` |

Refer to the ServiceNow product documentation for details on [how to configure a ServiceNow user and assign roles](https://l.stackstate.com/ui-servicenow-configure-user).

### Data retrieved

#### Events

The ServiceNow check retrieves the following events data from ServiceNow:

- Change requests

#### Metrics

The ServiceNow check doesn't retrieve any metrics data.

#### Tags

All tags defined in ServiceNow will be retrieved and added to the associated components and relations in Rancher Observability.
The ServiceNow integration also understands [common tags](https://docs.stackstate.com/configure/topology/tagging) and applies these to topology in Rancher Observability.

#### Topology

The ServiceNow check retrieves the following topology data from the ServiceNow CMDB:

- Components
- Relations

#### Traces

The ServiceNow check doesn't retrieve any traces data.

### Open source

The code for the Rancher Observability ServiceNow check is open source and [available on GitHub](https://l.stackstate.com/ui-servicenow-github-agent-check).