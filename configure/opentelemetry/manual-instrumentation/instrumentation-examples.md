---
description: StackState Self-hosted v5.0.x
---

# Manual instrumentation mappings for StackState

Below is a code snippet showing the basics required to send custom instrumentation
to StackState.

We are creating two components.

- RDS Database
- RDS Table

And we want a relationship between the database and table flowing down from the database to the table. This will allow
the health state propagates up to the database if something is wrong with the table.

This is where your best judgment will come into play; best would be to play around with the parent spans, child spans, etc., and see
what result do you receive on StackState.


{% tabs %}
{% tab title="JavaScript & NodeJS" %}

## Prerequisites
For NodeJS and Javascript, we are not explaining the setup to get to this point but rather the code example and libraries that was used.

You should install the following npm libraries using npm or yarn

- [@opentelemetry/api](https://www.npmjs.com/package/@opentelemetry/api)
- [@opentelemetry/sdk-trace-base](https://www.npmjs.com/package/@opentelemetry/sdk-trace-base)
- [@opentelemetry/exporter-trace-otlp-proto](https://www.npmjs.com/package/@opentelemetry/exporter-trace-otlp-proto)

## What the StackState Agent expects
The StackState Agent is expecting you to send the following keys in every single span:
- `trace.perspective.name`
- `service.name`
- `service.type`
- `service.identifier`
- `resource.name`

***The most important part to remember is*** that the StackState Agent only accept the data in a [Protobuf Format](https://developers.google.com/protocol-buffers), Our examples below will
use this format but if you do attempt to write something from scratch remember that this is a requirement.

In this NodeJS/JS example the protobuf export is the following line:

`import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-proto';`

## Code snippet

The code snippet below will implement a solution creating the above-mentioned components.

```javascript
// Base Imports for OpenTelemetry
import * as openTelemetryAPI from '@opentelemetry/api';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-proto';
import { BasicTracerProvider, BatchSpanProcessor, SimpleSpanProcessor } from '@opentelemetry/sdk-trace-base';

// Change this variable to point to your StackState Trace Agent followed by the port and path
// If you are using a env variable you can access the variable by using process.env.ENV_VARIABLE_NAME
const stsTraceAgentOpenTelemetryEndpoint = "http://localhost:8126/open-telemetry"

// The tracer identier to allow StackState to identifier this instrumentations.
// The name and version below should not be changed
const tracerIdentifier = {
    name: "@opentelemetry/instrumentation-stackstate",
    version: "1.0.0"
}

// Creating a trace provider and exporter
const provider = new BasicTracerProvider();
const otlpTraceExporter = new OTLPTraceExporter({ url: stsTraceAgentOpenTelemetryEndpoint })
const batchSpanProcessor = new BatchSpanProcessor(otlpTraceExporter)
provider.addSpanProcessor(batchSpanProcessor);

// Creating the tracer based on the identifier specified
const tracer = openTelemetryAPI.trace.getTracer(tracerIdentifier.name, tracerIdentifier.version);

// Creating a parent span. You need a identifier for this span inside the code
// we will use the value 'RDS Database' but this does not matter.
const parentSpan = tracer.startSpan('RDS Database', {
    root: true,
});

// Adding attributes to the parent span
parentSpan.setAttribute('trace.perspective.name', 'RDS Database: Hello World');
parentSpan.setAttribute('service.name', 'RDS Database');
parentSpan.setAttribute('service.type', 'Database');
parentSpan.setAttribute('service.identifier', 'rds:database:hello-world');
parentSpan.setAttribute('resource.name', 'AWS RDS');

// Creating a child span. You need a identifier for this span inside the code
// we will use the value 'RDS Table' but this does not matter.
const childSpan = tracer.startSpan(
    'RDS Table',
    undefined,
    openTelemetryAPI.trace.setSpan(openTelemetryAPI.context.active(), parentSpan)
);

// Adding attributes to the child span
childSpan.setAttribute('trace.perspective.name', 'RDS Table: Users');
childSpan.setAttribute('service.name', 'RDS Table');
childSpan.setAttribute('service.type', 'Database Tables');
childSpan.setAttribute('service.identifier', 'rds:database:table:users');
childSpan.setAttribute('resource.name', 'AWS RDS');

// Closing the spans in order
// You need to close the spans in the opposite order in which you opended them
// For example we started with the parent and then the child, thus we need to close the child first
// and then the parent span
childSpan.end();
parentSpan.end();

// NB: Optional Flush
// For example this is required in a Lambda environment to force the OLTP HTTP to post before the script ends.
provider.forceFlush().finally(() => {
    console.log('Successfully Force Flushed The OTEL Provider')
});
```
{% endtab %}
{% endtabs %}

