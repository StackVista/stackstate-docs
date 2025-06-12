---
description: SUSE Observability Affinity Configuration
---

# Affinity Values Configuration

The Suse Observability Values chart generates affinity configurations that can be used by the main SUSE Observability chart to control pod scheduling behavior. The affinity values help optimize resource utilization and ensure high availability by controlling where pods are scheduled.

## Available Configuration Options

### Node Affinity

Node affinity is used to schedule pods to specific nodes or instance groups, such as EC2 nodes deployed to the same availability zone.

```yaml
affinity:
  # Node Affinity settings - applied to all components when configured
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: topology.kubernetes.io/zone
          operator: In
          values:
          - us-west-2a
```

### Pod Anti-Affinity

Pod anti-affinity is used to schedule replicas of data services to different nodes to ensure high availability. By default, the scheduling is required (hard anti-affinity).

```yaml
affinity:
  podAntiAffinity:
    # Enable required pod anti-affinity (true = hard, false = soft)
    requiredDuringSchedulingIgnoredDuringExecution: true
    # Topology key for pod anti-affinity
    topologyKey: "kubernetes.io/hostname"
```

## Behavior

### Node Affinity
- **When configured**: Applied to all data service components
- **Components affected**: clickhouse, elasticsearch, hbase, kafka, zookeeper, victoria-metrics, stackstate, opentelemetry-collector

### Pod Anti-Affinity
- **When configured**: Only applied when `sizing.profile` ends with `-ha` (High Availability profiles)
- **HA Profiles**: `150-ha`, `250-ha`, `500-ha`, `4000-ha`
- **Components affected**: All stateful data services including clickhouse, kafka, zookeeper, victoria-metrics, hbase components, elasticsearch

## Example Configurations

### Basic Node Affinity (Same Availability Zone) + Pod Anti-Affinity for HA Deployment
```yaml
affinity:
  # Schedule all pods to nodes in the same AZ
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: topology.kubernetes.io/zone
          operator: In
          values:
          - us-west-2a
  
  # Ensure replicas are distributed across different nodes
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution: true
    topologyKey: "kubernetes.io/hostname"
```

## Usage

### Step 1: Create Your Affinity Values File

Create a separate values file with your desired affinity configuration. For example, save the following as `suse-observability-values-values.yaml`:

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: topology.kubernetes.io/zone
          operator: In
          values:
          - us-west-2a
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution: true
    topologyKey: "kubernetes.io/hostname"
```

### Step 2: Generate Affinity Template Values

Run the following command to generate the affinity values template:

```text
export VALUES_DIR=.
helm template \
  --set license='<your license>' \
  --set baseUrl='<suse-observability-base-url>' \
  --set sizing.profile='<sizing.profile>' \
  --values suse-observability-values-values.yaml \
  suse-observability-values \
  suse-observability/suse-observability-values --output-dir $VALUES_DIR
```

### Step 3: Use Generated Values in Helm Installation

Include the generated affinity values in your Helm installation:

```bash
helm upgrade \
  --install \
  --namespace suse-observability \
  --values $VALUES_DIR/suse-observability-values/templates/baseConfig_values.yaml \
  --values $VALUES_DIR/suse-observability-values/templates/sizing_values.yaml \
  --values $VALUES_DIR/suse-observability-values/templates/affinity_values.yaml \
  suse-observability \
  suse-observability/suse-observability
```
