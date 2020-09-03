# Basic and Advanced filters

???
* filter pane has filters for topology, events and traces. How do these work with each perspective? ALSO how do you do non-topology advanced filtering?
* Will filtering limits be applied to topology filters run in each perspective? (or just topology perspective output)
*
???




By design, there is only one topology per StackState instance to make sure any part of the topology can always be connected to any other part. The topology is, of course, segmented in many different ways depending on your environment. You can narrow down on the part of the topology you are interested in filtering.

## Basic filters

The main way of filtering the topology is by using the basic filter panel, accessed using the _filter_ icon.

From here, you can use the basic filter panel to filter the topology on certain properties. If you select a particular property, the topology view will be updated to show only the topology that matches the selected value. Selecting multiple properties narrows down your search \(ie, it combines them using an `AND` operator\). Selecting multiple values for a single property expands your search \(ie, it combines them using an `OR` operator\).

Using the basic filter panel you can select a subset of your topology based on the following properties:

* layers
* domains
* environments
* types
* health state
* tags / labels

Layers, domains, and environments are a way to organize your topology. The health state reflects how the component is functioning. Use tags / labels to make it easy to navigate your topology.

### Filter settings

**Show Components** adds one or more specific components to the topology selection. You can **search** for the component by name.

## Advanced filters
