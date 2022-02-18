---
description: StackState Self-hosted v4.6.x
---

# DotNet APM

## Overview

To begin tracing applications written in any language, first make sure to have the StackState Agent installed and configured. The .NET Tracer runs in-process to instrument your applications and sends traces from your application to the StackState Agent.

DotNet APM is a [StackState curated integration](/stackpacks/integrations/about_integrations.md#stackstate-curated-integrations).

### Traces installation

To enable tracing and sending it to Stackstate Trace Agent, you need to follow the below steps to get started.

To start instrumentation for your dot net application, add the `Datadog.Trace` [NuGet package](https://www.nuget.org/packages/Datadog.Trace) to your application.

This can be done using in number of ways:

* Using Package Manager

```text
Install-Package Datadog.Trace -Version 1.13.2
```

* using net cli

```text
dotnet add package Datadog.Trace --version 1.13.2
```

* reference in solution file

```text
<PackageReference Include="Datadog.Trace" Version="1.13.2" />
```

In your code, you can access the global tracer through the `Datadog.Trace.Tracer.Instance` property to create new spans.

### Configuration

There are multiple ways to configure the .NET Tracer:

* in .NET code
* setting environment variables
* editing the application’s `app.config`/`web.config` file \(.NET Framework only\)

To configure the Tracer in application code, create a `TracerSettings` from the default configuration sources. Set properties on this `TracerSettings` instance before passing it to a `Tracer` constructor. For example:

```text
    using Datadog.Trace;

    // read default configuration sources (env vars, web.config, datadog.json)
    var settings = TracerSettings.FromDefaultSources();

    // change some settings
    settings.ServiceName = "MyService";
    settings.AgentUri = new Uri("http://localhost:8126/");

    // disable the AdoNet integration
    settings.Integrations["AdoNet"].Enabled = false;

    // create a new Tracer using these settings
    var tracer = new Tracer(settings);

    // set the global tracer
    Tracer.Instance = tracer;
```

**Note:** Settings must be set on `TracerSettings` _before_ creating the `Tracer`. Changes made to `TracerSettings` properies after the `Tracer` is created are ignored.

To configure the Tracer using environment variables, set the variables before launching the instrumented application. For example:

```text
    rem Set environment variables
    SET DD_TRACE_AGENT_URL=http://localhost:8126
    SET DD_SERVICE_NAME=MyService
    SET DD_ADONET_ENABLED=false

    rem Launch application
    example.exe
```

**Note:** To set environment variables for a Windows Service, use the multi-string key `HKLM\System\CurrentControlSet\Services\{service name}\Environment` in the Windows Registry.

To configure the Tracer using an `app.config` or `web.config` file, use the `<appSettings>` section. For example:

```text
    <configuration>
      <appSettings>
        <add key="DD_TRACE_AGENT_URL" value="http://localhost:8126"/>
        <add key="DD_SERVICE_NAME" value="SampleMVC4Application"/>
        <add key="DD_ADONET_ENABLED" value="false"/>
      </appSettings>
    </configuration>
```

Those two steps \(referencing assembly, configuring endpoint\) is enough for stackstate-agent to start consuming traces info.

### Configuration Variables

The following tables list the supported configuration variables. Use the first name \(e.g. `DD_TRACE_AGENT_URL`\) when setting environment variables or configuration files. The second name, if present \(e.g. `AgentUri`\), indicates the name the `TracerSettings` property to use when changing settings in the code.

The first table below lists configuration variables available.

| Setting Name | Description |
| :--- | :--- |
| `DD_TRACE_AGENT_URL`, `AgentUri` | Sets the URL endpoint where traces are sent. Overrides `DD_AGENT_HOST` and  `DD_TRACE_AGENT_PORT` if set. Default value is `http://<DD_AGENT_HOST>:<DD_TRACE_AGENT_PORT>`. |
| `DD_AGENT_HOST` | Sets the host where traces are sent \(the host running the Agent\). Can be a hostname or an IP address. Ignored if `DD_TRACE_AGENT_URL` is set. Default is value `localhost`. |
| `DD_TRACE_AGENT_PORT` | Sets the port where traces are sent \(the port where the Agent is listening for  connections\). Ignored if `DD_TRACE_AGENT_URL` is set. Default value is `8126`. |
| `DD_ENV` `Environment` | If specified, adds the `env` tag with the specified value to all generated spans. |
| `DD_SERVICE_NAME` `ServiceName` | If specified, sets the default service name. Otherwise, the .NET Tracer tries to determine service name automatically from application name \(e.g. IIS application name,  process entry assembly, or process name\). |
| `DD_TRACE_GLOBAL_FLAGS` `GlobalTags` | If specified, adds all of the specified tags to all generated spans. |

#### Automatic instrumentation \(experimental\)

To use experimental automatic instrumentation on Windows, install the .NET Tracer on the host using the MSI installer for Windows.

After installing the .NET Tracer, restart applications and IIS service so they can read the new environment variables.

If your application runs in IIS, tracing information will be collected immediately after the service restart.

For Dotnet Windows applications not running in IIS, set these two environment variables before starting your application to enable automatic instrumentation:

| NAME | VALUE |
| :--- | :--- |
| COR\_ENABLE\_PROFILING | 1 |
| COR\_PROFILER | {846F5F1C-F9AE-4B07-969E-05C26BC060D8} |

For example, environment variables can be set in the cmd file used to start your application:

```text
rem Set environment variables
SET COR_ENABLE_PROFILING=1
SET COR_PROFILER={846F5F1C-F9AE-4B07-969E-05C26BC060D8}

rem Start application
example.exe
```

To set environment variables for a Windows Service, use the multi-string key

`HKLM\System\CurrentControlSet\Services\{service name}\Environment` in the Windows Registry.

Note: The .NET runtime tries to load a profiler into any .NET process that is started with these environment variables. You should limit instrumentation only to the applications that need to be traced. We do not recommend setting these environment variables globally as this causes all .NET processes on the host to load the profiler.

If host has datadog so-called automatic instrumentation installed, following settings can be used.

| Setting Name | Description |
| :--- | :--- |
| `DD_TRACE_ENABLED` `TraceEnabled` | Enables or disables all automatic instrumentation. Setting the environment variable to `false` completely disables the CLR profiler. For other configuration methods, the CLR profiler is still loaded, but traces will not be generated. Valid values are: `true` \(default\) or `false`. |
| `DD_TRACE_DEBUG` | Enables or disables debug logs in the Tracer. Valid values are: `true` or `false` \(default\). Setting this as an environment variable also enabled debug logs in the CLR Profiler. |
| `DD_TRACE_LOG_PATH` | Sets the path for the CLR profiler’s log file. Default: `%ProgramData%\Datadog .NET Tracer\logs\dotnet-profiler.log` |
| `DD_DISABLED_INTEGRATIONS` `DisabledIntegrationNames` | Sets a list of integrations to disable. All other integrations remain enabled. If not set, all integrations are enabled. Supports multiple values separated with semicolons. |

#### Frameworks supported out of the box

| Framework or library | NuGet package | Integration Name |
| :--- | :--- | :--- |
| ASP.NET \(including Web Forms\) | built-in | `AspNet` |
| ASP.NET MVC | `Microsoft.AspNet.Mvc` 4.0+ | `AspNetMvc` |
| ASP.NET Web API 2 | `Microsoft.AspNet.WebApi` 5.1+ | `AspNetWebApi2` |
| WCF \(server\) | built-in | `Wcf` |
| ADO.NET | built-in | `AdoNet` |
| HttpClient / HttpClientHandler | built-in | `HttpMessageHandler` |
| WebClient / WebRequest | built-in | `WebRequest` |
| Redis \(StackExchange client\) | `StackExchange.Redis` 1.0.187+ | `StackExchangeRedis` |
| Redis \(ServiceStack client\) | `ServiceStack.Redis` 4.0.48+ | `ServiceStackRedis` |
| Elasticsearch | `Elasticsearch.Net` 5.3.0+ | `ElasticsearchNet` |
| MongoDB | `MongoDB.Driver.Core` 2.1.0+ | `MongoDb` |

