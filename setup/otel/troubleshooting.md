description: StackState Kubernetes Troubleshooting
---

# Troubelshooting Open Telemetry

TODO: write up in more detail
 - Instrumentation can send data to collector? URL correct, Network policies, etc..
 - Instrumentation is using correct port? 4317 for gRPC 4318 for HTTP. 
 - Some proxies and firewalls don't work well with gRPC (only supporting http and/or problems with long-lived gRPC connections), so try switching to http
   - Instrumentation -> collector
   - Collector -> StackState
 - Collector can send data to StackState? URL correct and accessible? Should be different endpoint than agent receiver
 - Collector has correct api key? No 403/401 responses logged?