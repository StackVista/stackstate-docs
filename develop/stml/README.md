---
description: Build reports with StackState's markup language.
---

# StackState Markup Language \(STML\)

With StackState Markup Language \(STML\), you can create pretty formatted documents of StackState data. STML is a [markdown](https://en.wikipedia.org/wiki/Markdown) based language with extensions in the form of [HTML](https://en.wikipedia.org/wiki/HTML)-like tags.

## Rich text formatting using Markdown

STML is a valid superset of markdown. In other words, it is markdown plus extensions. That means that you can easily format documents with headings, bullet point lists, links and tables as you may be used to with the markdown format. For example the following valid STML document create a table of elements to buy with links to google:

```text
| To buy                              | Amount |
|------------------------------- -----|--------|
|[Apples](http://goolge.com/?q=apples)| 2      |
|[Pears](http://goolge.com/?q=pears)  | 5      |
```

## Tags

STML is markdown plus HTML-like tags. Tags are StackState specific extensions to markdown that render in some specific way. It could be a chart, visualization, pie chart, etc.

Each tag has its unique rendering, and a set of required and/or optional attributes.

Tags in STML are coded in the following format:

`<tag_name attribute1="literal" attribute2='{ "json": true }'>content</tag_name>`

Attributes can be passed as literal values using a double or single quote. Some values can contain [JSON](https://en.wikipedia.org/wiki/JSON) documents.

Not all tags display their content, but if they do, the content of a tag should be a valid STML.

See the [tag reference](tags.md) for an overview of all tags, their purpose and attributes.

## Passing script data to tags with STML variables

Attribute values can be set directly with literal values, but oftentimes, it may be desirable to use data that was computed in your script. Script data can be used within STML via the use of STML variables.

Here is an example of a script passing some metric data to the `data` attribute of the `auto-widget` tag. This script uses the `UI.showReport` function which uses STML to format a report.

```text
Telemetry
  .query("StackState Metrics", "name='system.load.norm' and host='host1'")
  .metricField("value")
  .start("-2h")
  .aggregation("99th percentile", "5m")
  .then { host1Load ->
    UI.showReport(
        "My report",
        // STML starts below
        """
        |# Host 1 load
        |
        | The last two hours of load on host1, aggregated per 5 minutes and by 99th percentile:
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

Notice that the third parameter of the `showReport` function is a map that is defined by `[ metrics: host1Load ]`. This map defines which variables are available to STML. In this case the variable `metrics` references the data `host1Load`.

The syntax for using such variables in STML is `{NAME}`, where NAME is the name of the variable containing the data. Thus, passing the `metrics` variable to the `data` variable using this syntax means that the `auto-widget` can use the metric to render a nice chart.

