---
description: StackState Self-hosted v5.1.x 
---

# STML Tags

## Tag: `auto-widget`

Data queried on the [analytics](../../../use/stackstate-ui/analytics.md) page can often times show a preview. Data of some known format, such as telemetry or topology, will therefore _automatically_ be shown in a chart of topology visualization. This tag renders data exactly the way the analytics preview of the analytics would render data.

It looks at the shape of the `data`, and if it's of some recognizable type \(determined by inspecting the `_type`\) it automatically renders the data in an appropriate format.

**Attributes:**

* `data` - any type of json data.

**Examples:**

This is an example of a script that uses the `auto-widget` to render a telemetry chart:

{% code lineNumbers="true" %}
```groovy
Telemetry
  .promql("quantile_over_time(0.99, system_load_norm_1{sts_host='host1'})")
  .start("-2h")
  .step("5m")
  .then { host1Load ->
    UI.showReport(
        "My report",
        // STML starts below
        """
        |# Host 1 load
        |
        | The last two hours of load on host1, aggregated per 5 minutes and by 99th percentile looks like:
        |
        |<auto-widget data={metrics}></auto-widget>
        |
        | Thank you for watching!
        |""".stripMargin(),
        // end of STML
        [ metrics: host1Load ]
    )
  }
```
{% endcode %}

## Tag: `heatmap`

Shows a table of size `rows x columns` with color coded `CLEAR`, `DEVIATING`, and `CRITICAL` states. This is useful for showing multiple states over time or in combinations.

**Attributes:**

* `rows` - array of the labels placed on the rows. The number of rows is determined by the size of the array.
* `cols` - array of the labels placed on the columns. The number of cells is determined by the size of the array.
* `cells` - two-dimensional array of state elements. Each element in the two-dimensional array can either be `CLEAR` \(green\), `DEVIATING` \(warning\) or `CRITICAL` \(red\).

**Examples:**

The following heatmap renders a table of 2x2 with all three colors.

```text
<heatmap cols='["col1", "col2"]' rows='["row1", "row2"]' cells='[["CLEAR", "DEVIATING"], ["DEVIATING", "CRITICAL"]]'></heatmap>
```

