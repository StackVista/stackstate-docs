#!/bin/bash

# Namespace to collect information
NAMESPACE="suse-observability"

# Check if kubectl is installed or not
if ! command -v kubectl &>/dev/null; then
   echo "kubectl is not installed. Please install it and try again."
   exit 1
fi

# Check if KUBECONFIG is set
if [[ -z "$KUBECONFIG" || ! -f "$KUBECONFIG" ]]; then
    echo "Error: KUBECONFIG is not set. Please ensure KUBECONFIG is set to the path of a valid kubeconfig file before running this script."
    echo "If kubeconfig is not set, use the command: export KUBECONFIG=PATH-TO-YOUR/kubeconfig. Exiting..."
 exit 1
fi

# Check if namespace exist or not
if ! kubectl get namespace "$NAMESPACE" &>/dev/null; then
    echo "Namespace '$NAMESPACE' does not exist. Exiting."
    exit 1
fi
# Directory to store logs
OUTPUT_DIR="${NAMESPACE}_logs_$(date +%Y%m%d%H%M%S)"
ARCHIVE_FILE="${OUTPUT_DIR}.tar.gz"
mkdir -p "$OUTPUT_DIR"

techo() {
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $*" | tee -a $OUTPUT_DIR/collector-output.log
}


techo "Collecting node details..."
kubectl get nodes -o wide > "$OUTPUT_DIR/nodes_status"
kubectl describe nodes > "$OUTPUT_DIR/nodes_describe"

# Function to collect yaml
collect_yaml_configs() {
    techo "Collecting YAML configurations..."

    mkdir -p "$OUTPUT_DIR/yaml"
    
    # Pods YAMLs
    kubectl -n "$NAMESPACE" get pod -o yaml> "$OUTPUT_DIR/yaml/pods.yaml"
    # StatefulSet YAMLs
    kubectl -n "$NAMESPACE" get statefulsets -o yaml > "$OUTPUT_DIR/yaml/statefulsets.yaml"
    # DaemonSet YAMLs
    kubectl -n "$NAMESPACE" get daemonsets -o yaml > "$OUTPUT_DIR/yaml/daemonsets.yaml"
    # Service YAMLs
    kubectl -n "$NAMESPACE" get services -o yaml > "$OUTPUT_DIR/yaml/services.yaml"
    # Deployment YAMLs
    kubectl -n "$NAMESPACE" get deployments -o yaml > "$OUTPUT_DIR/yaml/deployments.yaml"
    # ConfigMap YAMLs
    kubectl -n "$NAMESPACE" get configmaps -o yaml > "$OUTPUT_DIR/yaml/configmaps.yaml"
    # Cronjob YAMLs
    kubectl -n "$NAMESPACE" get cronjob -o yaml > "$OUTPUT_DIR/yaml/cronjob.yaml"
    # PV,PVC YAML
    kubectl -n "$NAMESPACE" get pv,pvc -o yaml  > "$OUTPUT_DIR/yaml/pv-pvc.yaml"
}

# Function to collect pod logs
collect_pod_logs() {
    techo "Collecting pod logs..."
    PODS=$(kubectl -n "$NAMESPACE" get pods -o jsonpath="{.items[*].metadata.name}")
    for pod in $PODS; do
        mkdir -p "$OUTPUT_DIR/pods/$pod"
        CONTAINERS=$(kubectl -n "$NAMESPACE" get pod "$pod" -o jsonpath="{.spec.containers[*].name}")
        for container in $CONTAINERS; do
            kubectl -n "$NAMESPACE" logs "$pod" -c "$container" > "$OUTPUT_DIR/pods/$pod/${container}.log" 2>&1
            kubectl -n "$NAMESPACE" logs "$pod" -c "$container" --previous > "$OUTPUT_DIR/pods/$pod/${container}_previous.log" 2>/dev/null
        done
    done
 }


# Collect general pod statuses
techo "Collecting pod statuses..."
kubectl -n "$NAMESPACE" get pods -o wide > "$OUTPUT_DIR/pods_status"

# Collect StatefulSets information
techo "Collecting StatefulSets information..."
kubectl -n "$NAMESPACE" get statefulsets -o wide > "$OUTPUT_DIR/statefulsets"
kubectl -n "$NAMESPACE" describe statefulsets > "$OUTPUT_DIR/statefulsets_describe"

# Collect DaemonSets information
techo "Collecting DaemonSets information..."
kubectl -n "$NAMESPACE" get daemonsets -o wide > "$OUTPUT_DIR/daemonsets"
kubectl -n "$NAMESPACE" describe daemonsets > "$OUTPUT_DIR/daemonsets_describe"

techo "Collecting Deployments information..."
kubectl -n "$NAMESPACE" get deployments -o wide > "$OUTPUT_DIR/deployments"

techo "Collecting services information..."
kubectl -n "$NAMESPACE" get services -o wide > "$OUTPUT_DIR/services"

techo "Collecting information about configmaps and secrets..."
kubectl -n "$NAMESPACE" get configmaps -o wide > "$OUTPUT_DIR/configmaps"
kubectl -n "$NAMESPACE" get secrets -o wide > "$OUTPUT_DIR/secrets"

techo "Collecting cronjob information..."
kubectl -n "$NAMESPACE" get cronjob -o wide > "$OUTPUT_DIR/cronjob"

techo "Collecting PV and PVC information"
kubectl -n "$NAMESPACE" get pv,pvc -o wide > "$OUTPUT_DIR/pv-pvc"

techo "Collecting events in $NAMESPACE ..."
kubectl -n "$NAMESPACE" get events --sort-by='.metadata.creationTimestamp' > "$OUTPUT_DIR/events"

archive_and_cleanup() {
    echo "Creating archive $ARCHIVE_FILE..."
    tar -czf "$ARCHIVE_FILE" "$OUTPUT_DIR"
    echo "Archive created."

    echo "Cleaning up the output directory..."
    rm -rf "$OUTPUT_DIR"
    echo "Output directory removed."
}
# Run the pod logs collection function
collect_pod_logs
collect_yaml_configs
archive_and_cleanup
echo "All information collected in the $ARCHIVE_FILE"
