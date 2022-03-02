# OpenTelemetry

## Overview

OpenTelemetry is a set of APIs, SDKs, tooling and integrations that are designed for the creation and management of telemetry data such as traces, metrics, and logs. The OpenTelemetry documentation is intended to broadly cover key terms, concepts, and instructions on how to use OpenTelemetry in your software

## Why you need OpenTelemetry and what it can do

In cloud-native technology stacks, distributed and polyglot architectures are the norm. Distributed architectures introduce a variety of operational challenges including how to solve availability and performance issues quickly. These challenges have led to the rise of observability.

Telemetry data is needed to power observability products. Traditionally, telemetry data has been provided by either open-source projects or commercial vendors. With a lack of standardization, the net result is the lack of data portability and the burden on the user to maintain the instrumentation.

The OpenTelemetry project solves these problems by providing a single, vendor-agnostic solution. The project has broad industry support and adoption from cloud providers, vendors and end users.

OpenTelemetry provides you with:

- A single, vendor-agnostic instrumentation library per language with support for both automatic and manual instrumentation.
- A single collector binary that can be deployed in a variety of ways including as an agent or gateway.
- An end-to-end implementation to generate, emit, collect, process and export telemetry data.
- Full control of your data with the ability to send data to multiple destinations in parallel through configuration.
- Open-standard semantic conventions to ensure vendor-agnostic data collection
- The ability to support multiple context propagation formats in parallel to assist with migrating as standards evolve.
- A path forward no matter where you are on your observability journey. With support for a variety of open-source and commercial protocols, format and context propagation mechanisms as well as providing shims to the OpenTracing and OpenCensus projects, it is easy to adopt OpenTelemetry.

## See also
