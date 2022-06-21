---
description: StackState Self-hosted v5.0.x
---

# Manual instrumentation mappings for StackState

Below is a code snippet showing the basics required to send custom instrumentation
to StackState.

We are creating a Lambda parent span and then adding an RDS request as a child span.

This is where you best judgement will come in play, best would be to play around with the parent spans, child spans etc and see
what result you receive on StackState.


{% tabs %}
{% tab title="JavaScript & NodeJS" %}

### Prerequisites
Install the following npm modules:

- [@opentelemetry/api](https://www.npmjs.com/package/@opentelemetry/api)
- [@opentelemetry/sdk-trace-base](https://www.npmjs.com/package/@opentelemetry/sdk-trace-base)
- [@opentelemetry/exporter-trace-otlp-proto](https://www.npmjs.com/package/@opentelemetry/exporter-trace-otlp-proto)

### Code snippet

```javascript
// Base Imports for OpenTelemetry
import * as openTelemetryAPI from '@opentelemetry/api';
import { BasicTracerProvider, BatchSpanProcessor, SimpleSpanProcessor } from '@opentelemetry/sdk-trace-base';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-proto';

// Change this variable to point to your StackState Trace Agent followed by the port and path
// If you are using a env variable you can access the variable by using process.env.ENV_VARIABLE_NAME
const stsTraceAgentOpenTelemetryEndpoint = "http://localhost:8126/open-telemetry"

// The tracer identier that works with StackState
const tracerIdentifier = {
  name: "@opentelemetry/instrumentation-stackstate",
  version: "1.0.0"
}

// Creating a trace provider, and a OLTP Exporter endpoint
const provider = new BasicTracerProvider();
const otlpTraceExporter = new OTLPTraceExporter({ url: stsTraceAgentOpenTelemetryEndpoint })
const batchSpanProcessor = new BatchSpanProcessor(otlpTraceExporter)
provider.addSpanProcessor(batchSpanProcessor);

// Creating the tracer based on the identifier specified
const tracer = openTelemetryAPI.trace.getTracer(tracerIdentifier.name, tracerIdentifier.version);

// Creating a parent span
const parentSpan = tracer.startSpan('lambda', {
  root: true,
});

// Adding attributes to the parent span
parentSpan.setAttribute('trace.perspective.name', 'Lambda: Trace Perspective');
parentSpan.setAttribute('service.name', 'Lambda: Service Name');
parentSpan.setAttribute('service.type', 'Lambda: Service Type');
parentSpan.setAttribute('service.identifier', 'Lambda: Service Identifier');
parentSpan.setAttribute('resource.name', 'Lambda: Resource Name');

// Creating a child span
const childSpan = tracer.startSpan(
  'sqs',
  undefined,
  openTelemetryAPI.trace.setSpan(openTelemetryAPI.context.active(), parentSpan)
);

// Adding attributes to the child span
childSpan.setAttribute('trace.perspective.name', 'SQS: Trace Perspective');
childSpan.setAttribute('service.name', 'SQS: Service Name');
childSpan.setAttribute('service.type', 'SQS: Service Type');
childSpan.setAttribute('service.identifier', 'SQS: Identifier');
childSpan.setAttribute('resource.name', 'SQS: Resource Name');

// Closing the spans in order
// You need to close the spans in the opposite order in which you opended them
// For example we started with the parent and then the child, thus we need to close the child first
childSpan.end();
parentSpan.end();

// Optional Flush, Is required in a Lambda environment to force the OLTP http post before the script ends.
provider.forceFlush().finally(() => {
    console.log('Successfully Force Flushed The OTEL Provider')
});
```
{% endtab %}


{% tab title="GoLang" %}
TODO: Still in progress needs testing

```shell
go get go.opentelemetry.io/otel \
       go.opentelemetry.io/otel/trace \
       go.opentelemetry.io/otel/sdk \
       go.opentelemetry.io/otel/exporters/otlp/otlptrace \
       go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp \
       go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp
```

```go
package app

import (
	"context"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp"
	"log"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/sdk/resource"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.10.0"
	"go.opentelemetry.io/otel/trace"
)

var tracer trace.Tracer

func newExporter(ctx context.Context) (*otlptrace.Exporter, error) {
	client := otlptracehttp.NewClient()
	return otlptrace.New(ctx, client)
}

func newTraceProvider(exp sdktrace.SpanExporter) *sdktrace.TracerProvider {
	// Ensure default SDK resources and the required service name are set.
	r, err := resource.Merge(
		resource.Default(),
		resource.NewWithAttributes(
			semconv.SchemaURL,
			semconv.ServiceNameKey.String("ExampleService"),
		),
	)

	if err != nil {
		panic(err)
	}

	return sdktrace.NewTracerProvider(
		sdktrace.WithBatcher(exp),
		sdktrace.WithResource(r),
	)
}

func main() {
	ctx := context.Background()

	exp, err := newExporter(ctx)
	if err != nil {
		log.Fatalf("failed to initialize exporter: %v", err)
	}

	// Create a new tracer provider with a batch span processor and the given exporter.
	tp := newTraceProvider(exp)

	// Handle shutdown properly so nothing leaks.
	defer func() { _ = tp.Shutdown(ctx) }()

	otel.SetTracerProvider(tp)

	// Finally, set the tracer that can be used for this package.
	tracer = tp.Tracer("@opentelemetry/instrumentation-stackstate", trace.WithInstrumentationVersion("1.0.0"))

	ctx, parentSpan := tracer.Start(ctx, "lambda")
	parentSpan.SetAttributes(attribute.String("trace.perspective.name", "Lambda: Trace Perspective"))
	parentSpan.SetAttributes(attribute.String("service.name", "Lambda: Service Name"))
	parentSpan.SetAttributes(attribute.String("service.type", "Lambda: Service Type"))
	parentSpan.SetAttributes(attribute.String("service.identifier", "Lambda: Service Identifier"))
	parentSpan.SetAttributes(attribute.String("resource.name", "Lambda: Resource Name"))
	defer parentSpan.End()

	ctx, childSpan := tracer.Start(ctx, "sqs")
	childSpan.SetAttributes(attribute.String("trace.perspective.name", "SQS: Trace Perspective"))
	childSpan.SetAttributes(attribute.String("service.name", "SQS: Service Name"))
	childSpan.SetAttributes(attribute.String("service.type", "SQS: Service Type"))
	childSpan.SetAttributes(attribute.String("service.identifier", "SQS: Service Identifier"))
	childSpan.SetAttributes(attribute.String("resource.name", "SQS: Resource Name"))
	defer childSpan.End()

	err = tp.ForceFlush(ctx)
	if err != nil {
		return
	}
}

```
{% endtab %}
{% endtabs %}

