---
title: Splunk Event Integration
kind: documentation
---

## Overview

The StackState Agent can be configured to execute Splunk saved searches and provide the results as generic events to the StackState receiver API. It will dispatch the saved searches periodically, specifying last event timestamp to start with up until now.

The StackState Agent expects the results of the saved searches to be according to the Events Query Format, which is described below.
It requires the `_time` format, and has the following optional fields: `event_type`, `msg_title`, `message_text` and `source_type_name`.
If there are other fields present in the result, they will be mapped to tags, where the column name is the key, and the content the value.
The Agent will filter out Splunk default fields (except `_time`), like e.g. `_raw`, see the [Splunk documentation](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) for more information about default fields.

The agent check prevents sending duplicate events over multiple check runs.  The received saved search records have to be uniquely identified for comparison.
By default, a record's identity is composed of Splunk's default fields `_bkt` and `_cd`.
The default behavior can be changed for each saved search by setting the `unique_key_fields` in the check's configuration.
Please note that the specified `unique_key_fields` fields become mandatory for each record.
In case the records can not be uniquely identified by a combination of fields then the whole record can be used by setting `unique_key_fields` to `[]`, i.e. empty list.

### Events Query Format

<table class="table">
<tr><td><strong>_time*</strong></td><td>long</td><td>Data collection timestamp, millis since epoch</td></tr>
<tr><td><strong>event_type</strong></td><td>string</td><td>Event type, e,g, server_created</td></tr>
<tr><td><strong>msg_title</strong></td><td>string</td><td>Message title</td></tr>
<tr><td><strong>msg_text</strong></td><td>string</td><td>Message text</td></tr>
<tr><td><strong>source_type_name</strong></td><td>string</td><td>Source type name</td></tr>
</table>

\* Required columns

## Example

Example Splunk query:

```
index=monitor alias_hostname=*
| eval status = upper(status)
| search status=CRITICAL OR status=error OR status=warning OR status=OK
| table _time hostname status description
```

## Configuration

1.  Edit your conf.d/splunk_events.yaml file.
2.  Restart the agent

{{< insert-example-links >}}
