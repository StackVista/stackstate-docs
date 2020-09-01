# How to set up traces

This how-to describes the steps to set up traces that can be viewed in the StackState Traces perspective.

For traces to be available in StackState, the [StackState Agent V2 StackPack](../stackpacks/integrations/agent.md) must be installed with one or more tracing integrations configured.

## Install StackState Agent V2

The StackState Agent V2 StackPack enables integration with external systems to receive trace data. You can check if it is installed on the StackPacks page in StackState. If it is not installed, follow the installation instructions on [StackState Agent V2 StackPack](../stackpacks/integrations/agent.md).

## Configure tracing integrations

When the StackState Agent V2 StackPack is installed, you can configure integrations to receive trace data from external systems. The following StackState Agent V2 integrations can be configured to populate the Traces perspective:

- **Java APM** - [Configure Java APM](../stackpacks/integrations/java-apm.md) to support tracing for Java JVM based systems.

- **DotNet APM** - [Configure DotNet APM](../stackpacks/integrations/dotnet-apm.md) to enable instrumentation for dotNET applications and send traces back to StackState.

- **Traefik** - [Configure Traefik](../stackpacks/integrations/traefik.md) to include topology and telemetry information from Traefik.

- **AWS X-ray** - [Configure AWS X-ray](../stackpacks/integrations/aws-x-ray.md) to collect tracing information from the in-built AWS distributed tracing system.<br>

Full configuration details for each available StackState Agent V2 integration are also provided in the StackPacks section of the StackState GUI.
