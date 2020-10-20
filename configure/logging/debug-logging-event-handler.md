# How to enable debug logging for an event handler


1. Get the ID of the event handler function:
`Graph.query{it.V().hasLabel("EventHandler")}`

2. Get the ID of the correct event handler, there might be more in this output — I only have one. Correct ID in this case is: 39169420504614
Scope is in this case the QueryView:
`Graph.query{it.V(59013784209828)}`

3. Set the log level using the [StackState CLI](/setup/cli.md):
`sts serverlog setlevel 39169420504614 DEBUG`

4. Monitor the `stackstate.log` using the event handler ID.
`tail -f stackstate.log | grep 39169420504614`

