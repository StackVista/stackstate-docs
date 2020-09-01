# How to set up traces

This how-to describes the steps to set up traces that can be viewed in the StackState Traces perspective.

For traces to be available in StackState, the [StackState Agent V2 StackPack](../stackpacks/integrations/agent/) must be installed with one or more tracing integrations configured.

## Install StackState Agent V2

The StackState Agent V2 StackPack enables integration with external systems to receive trace data. You can check if it is installed on the StackPacks page in StackState. If it is not installed, follow the installation instructions on [StackState Agent V2 StackPack](../stackpacks/integrations/agent/).

## Configure tracing integrations

When the StackState Agent V2 StackPack is installed, you can configure integrations to receive trace data from external systems. The following StackState Agent V2 integrations can be configured to populate the Traces perspective:

- **Java APM** provides tracing support for Java JVM based systems.
[Java APM configuration](../java-apm/)

- **DotNet APM** - enables instrumentation for dotNET applications and sends traces back to StackState.
[DotNet APM configuration](../dotnet-apm/)

- **Traefik** - adds topology and telemetry information from Traefik.
[Traefik configuration](../traefik/)

- **AWS X-ray** - collects tracing information from the in-built AWS distributed tracing system.
[AWS X-ray configuration](../aws-x-ray/)

Full configuration details for each available StackState Agent V2 integration are also provided in the StackPacks section of the StackState GUI.
