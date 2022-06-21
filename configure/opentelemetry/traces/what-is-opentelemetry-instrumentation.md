---
description: StackState Self-hosted v5.0.x
---

# What is a OpenTelemetry instrumentation
To understand what OpenTelemetry instrumentation is, we first need to understand the concept of distributed tracing.

## What is Distributed Tracing
Distributed tracing is a way of tracking code or application requests as it flows through the system as a whole.
Things like latency, errors and success statuses and more, can be tracked and monitored.
All the events and data mentioned above will be captured and grouped within multiple spans making up a trace. (Trace is made up out of multiple spans)


## What is a span inside a distributed trace
A span is used to represent each unit of work that has been done within the lifespan of the trace.
A request's whole lifecycle, from creation to fulfillment, is represented by a trace.
The image below illustrates a single trace made up of several spans



**Concepts inside a span**

- **Parent span**
  - A parent span, also referred to as a root span, contains the end-to-end latency of an entire request.
    For example if we execute a Lambda script, The script execution will be created as the parent span. All the other
    things monitored inside the execution of this Lambda will be seen as children spans.

- **Child span**
  - A child span is started by a parent span and might involve calling a function, the database, another service, etc.
    A child span in the aforementioned example may be a function that determines if the item is accessible or not.
    Child spans offer insight on every element of a request.

## How does a child span link to a parent span
A parent span will contain an id for example id-001, when a child span is created it will
contain a key-value pair that states the following, parent-span: id-001 and will contain its own unique
span id for example id-002. One thing that makes the structure unique is that this can be a chain of infinite
children for example the next child can have a parent-id of a previous child making it nested even deeper.
For example:

```js
Span {
  spanId: 001
},
Span {
  spanId: 002
  parentSpan: 001
},
Span {
  spanId: 003
  parentSpan: 002
},
Span {
  spanId: 004
  parentSpan: 003
}
...
```

In the above example all 4 spans are linked, with the parentSpan id.


## What does a span consist off
Each span has a context that specifically defines the request it is a part of.
Request, error, and duration information from Spans can be utilized to troubleshoot performance and availability problems.

To give your actions additional context, you may also include span characteristics.
Key-value pairs called span attributes can be used to give more context to a span about the particular action it records.

## What is an OpenTelemetry instrumentation
When OpenTelemetry captures spans it will fall under an instrumentation. This will be the
library identifier that was used to capture the span information for example instrumentation-http for 
HTTP status and the instrumentation-aws-sdk for recoding AWS calls will generate span in two different instrumentations.
When you create your manual instrumentation the span data you capture will fall under the trace provider name you supplied.

## How does OpenTelemetry instrumentations fit into a distributed trace
As we mentioned above a trace contains multiple spans for example:

```text
Trace [
    Span #1 AWS-SDK Lambda Script Execution
    Span #2 AWS-SDK S3
    Span #3    HTTP S3 Request   <Parent Id: Span #2>
    Span #4    HTTP S3 Response  <Parent Id: Span #2>
]
```

As you can see from the above we have HTTP and AWS-SDK calls mixed into one list.
With using OpenTelemetry it introduces the instrumentation layer, allowing users to use public 
OpenTelemetry libraries to capture data, and or create your own instrumentations using the 
OpenTelemetry API.

Below is an example of how the trace grouping looks and how OpenTelemetry captures data:

```text
Trace [
    AWS-SDK Instrumentation [
        Span #1 AWS-SDK Lambda Script Execution
        Span #2 AWS-SDK S3
    ]
    HTTP Instrumentation [
        Span #3 HTTP S3 Request   <Parent Id: Span #2>
        Span #4 HTTP S3 Response  <Parent Id: Span #2>
    ]
]
```

As you can see the separate types of spans has been grouped under what the library is called that extracted the data.

## OpenTelemetry support in StackState
StackState currently supports two types of instrumentations.

- An ***out-of-the-box*** solution specifically for AWS using a Lambda layer for all your ***NodeJS*** functions. 
  - Visit the [AWS OpenTelemetry integrations page](/stackpacks/integrations/aws/opentelemetry-nodejs.md) for more information regarding the [supported AWS services](/stackpacks/integrations/aws/opentelemetry-nodejs.md#supported-services) and how to install and use this Lambda layer.
- **Manual instrumentation** using the [OpenTelemetry API](https://opentelemetry.io/docs/instrumentation/)
  - This gives you the ability to create and display a custom component with a health state within StackState using the [OpenTelemetry API](https://opentelemetry.io/docs/instrumentation/).
  - To learn more about how to implement a manual instrumentation specifically for StackState, head over to the [manual instrumentation mappings for StackState](/configure/opentelemetry/traces/manual-instrumentation-mappings-for-stackstate.md) section











