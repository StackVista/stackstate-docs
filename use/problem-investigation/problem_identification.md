# Problem identification

## Overview

When a component or relation reports a DEVIATING (orange) or CRITICAL (red) state, StackState will identify this as a problem in your IT environment. As StackState is aware of the connections and dependencies between elements in the topology, related unhealthy state changes can be grouped together into a single problem with a single root cause. This is helpful because it will:
 
 - **Speed up problem investigation** - all unhealthy elements affected by a single root cause can be found in a dedicated sub-view.
 - **Reduce noise** - the evolution of the problem can be be tracked as a single entity, rather than a collection of individual, unhealthy elements.

## What is a StackState problem?

A problem in StackState is a collection of elements all with the same

- How does StackState class a "problem"
- One problem or two problems?
- problem ranking. time, severity


## See also

- [How to navigate through a problem in the StackState UI](/use/problem-investigation/problem_navigation.md)
- [Probable cause events](/use/problem-investigation/probable_causes.md)
- [Anomaly detection](/use/introduction-to-stackstate/anomaly-detection.md)
- [Send event notifications](/use/health-state-and-event-notifications/send-event-notifications.md)