---
description: StackState v6.0
---

# Verify the instrumentation is working

If the collector and the instrumentation setup has been successful data should be available in StackState within about a minute or two. 

You can check that StackState is receiving traces:

1. Open StackState in a browser
2. Find (one of) the pods that is instrumented
3. Select the pod to open the Highlights page
4. Open the trace perspective. If the pod is serving traffic it should now show traces

To check that StackState is receiving metrics:

1. Open StackState in a browser
2. Open the metrics explorer from the menu
3. Search for the metrics exposed by your application

If there are still no metrics after 5 minutes something is likely mis-configured. See [troubleshooting](../troubleshooting.md) for help.