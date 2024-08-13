---
description: Rancher Observability v6.0
---

# Troubleshooting custom metric charts

## Overview

* [The metric chart doesn't show on the Highlights page of a component](#the-metric-chart-doesnt-show-on-the-highlights-page-of-a-component)
* [The metric chart doesn't show on the metrics perspective of a component](#the-metric-chart-doesnt-show-on-the-metrics-perspective-of-a-component)
* [The metric chart on a component remains empty ("no data")](#the-metric-chart-on-a-component-remains-empty-no-data)

## The metric chart doesn't show on the Highlights page of a component

At the moment it is not possible to customize the metric charts that are shown on a components Highlights page. The charts for custom metric bindings will be shown in the Metrics perspective only.

## The metric chart doesn't show on the metrics perspective of a component

The `scope` query on a metric binding is used to determine whether a component shows the metric binding. If a component doesn't show a metric binding check that the topology query in the scope matches the component. 

First check that the component indeed has the expected labels and/or component type on the component highlights page, name and type are at the top, the labels are in the "About" section. Make sure there are no spelling mistakes in label names or values.

Check that the scope query has the correct syntax:

1. Open the explore view, via Views in the menu and the blue "Explore" button on the right. Or directly via the URL: `https://<your-stackstate-instance>/#/views/explore`
2. Open the filters and select `switch to STQL`
3. Now copy/paste the query from the scope into the STQL field and run the query

The overview now shows all components that match the query and that will get the chart.

## The metric chart on a component remains empty ("no data")

For the metric chart that has no data while data was expected open the inspector (the icon on the top-right corner of the chart). Toggle the "Show query" button to show the queries.

Make sure the query doesn't contain any of the parameters anymore (i.e. all values like `${tags.cluster-name}` or `${name}`) have been replaced with the values for the component. If some parameters were left behind in the query the labels were not available on this component. So cross-check the names used (in this example `cluster-name`) against the labels available on the component. Also make sure there are no typos in the names.

If all parameters are filled in there may be an issue with the PromQL query. To investigate that copy the PromQL query and open the Metrics explorer (via the main menu of Rancher Observability). Paste the query into the metric explorer and run it. This should still give an empty result.

Either the metric doesn't exist, it doesn't have one of the labels or the label does exist but there are no time series matching the value. The fastest method to resolve this is to rewrite the query to only its metric name and run that, if there are results the metric exists (so no typos). The table result can also be used to verify that all the labels that are used exist. Make sure there are no typos here either.

If there are results, but just not for a specific value of a label (for example for the `pod_name` label) the query is ok but there is no time series for this specific metric for this specific component. Things to check in this case:

* Is the data collected for this component (either via the Rancher Observability agent or some other means)?
* Is the component even reporting the metric?

How to do this depends on how data collection is configured.