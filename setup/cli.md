# StackState CLI

The StackState CLI can be used to configure StackState, work with data, and help with debugging problems. The CLI provides easy access to the functionality provided by the StackState API. The URLs and authentication credentials are configurable. Multiple configurations can be stored for access to different instances.

### Installation

#### Prerequisites

* Docker

#### Getting the CLI

The CLI can be downloaded from [https://download.stackstate.com](https://download.stackstate.com) using your license key.

The downloaded zip contains the following:

```text
.
+-- bin
|   +-- sts
+-- conf.d
|   +-- conf.yaml.example
|   +-- VERSION
+-- templates
    +-- topology
```

* `sts` is the CLI. Put sts on your path to use it anywhere on the command line.
* `conf.yaml.example` documents how to configure the url and credentials.
* `VERSION` the version of the CLI.
* `templates` these are topology templates in a format specific to the CLI.

#### Configuration

The StackState CLI searches for configuration in `conf.d/conf.yaml`. You need to create this file. In this file, the URLs to the sts APIs, their authentication \(if any\), and a client must be defined. You can copy the `conf.d/conf.example.yaml` file, and rename it to `conf.yaml` to get you started. Or copy the example below.

```yaml
instances:
 default:
   base_api:
     url: "https://localhost:7070"
     ## StackState authentication. This type of authentication is exclusive to the `base_api`.
     # auth:
     #   username: "validUsername"
     #   password: "safePassword"
     ## HTTP basic authentication.
     # basic_auth:
     #   username: "validUsername"
     #   password: "safePassword"
   receiver_api:
     url: "https://???:7077"
     ## HTTP basic authentication.
     #basic_auth:
       #username: "validUsername"
       #password: "safePassword"
   admin_api:
     url: "https://???:7071"
     ## HTTP basic authentication.
     #basic_auth:
       #username: "adminUsername"
       #password: "safePassword"

   ## The CLI uses a client configuration to identify who is sending to the StackState instance. The client
   ## is used to send topology and/or telemetry to the receiver API.
   ##
   ## Unless the `--client` argument is passed the CLI will pick the `default` instance as configured below.
   ## Other clients follow the exact same configuration pattern as the default client. You may simply copy-paste its config and modify whatever is needed.
   clients:
     default:
       api_key: "???"
       ## The name of the host that is passed to StackState when sending. Leave these values unchanged
       ## if you have no idea what to fill here.
       hostname: "hostname"
       internal_hostname: "internal_hostname"
```

The `conf.yaml` can hold multiple configurations. The example only holds a `default` instance. Other instances can be added on the same level as the default. To use a non default instance use `sts --instance <instance_name> ...`

```yaml
instances:
 default:
   base_api:
     ...
   clients:
     ...
 Preproduction:
   base_api:
     ...
   clients:
     ...
```

## Configuring StackState through the CLI

StackState's configuration is stored in StackState's graph database in so-called configuration nodes. These nodes can be inspected, imported and exported using the CLI. To see all types of configuration nodes run:

```text
sts graph list-types
```

You can use the `sts graph export` and `sts graph import` commands to export and import different types of configuration nodes from and to StackState. Nodes are stored in [StackState Templated Json](../develop/sts_template_language_intro/) format.

Here is an example to write all `check functions` to disk:

```text
sts graph list --ids CheckFunction | xargs sts graph export --ids > mycheckfunctions.stj
```

To import these check functions call:

```text
sts graph import < mycheckfunctions.stj
```

### Inspecting data with the CLI

#### Data flowing through topics

All data flowing through StackState\(e.g. topology, telemetry, traces, etc.\) flows through so-called topics. For debugging purposes these topics can be inspected using the CLI. This can come in handy when writing an integration for StackState to make sure that StackState is receiving the data correctly.

To see all topics run:

```text
sts topic list
```

Then use `sts topic show <topic>` to inspect any topic.

### Sending data with the CLI

You may not always want to try a new configuration on real data. First, you might want to see if it works correctly with predictable data. The CLI makes it easy to send some test topology or telemetry to StackState.

* For help on sending metrics: `sts metrics send -h`
* For help on sending events: `sts events send -h`
* For help on sending topology: `sts topology send -h` \(\).

#### Metrics

To send metrics the CLI provides `sts metrics send <MetricName> <OptionalNumberValue>` with some predefined settings. Running without any optional arguments sends one data point of the given value.

Using optional arguments provides a way to create historical data for a test metric.

`-p` gives the option to specify a time period. this can be done in weeks `<num>w`, days `<num>d`, hours `<num>h`, minutes `<num>m` and seconds `<num>s`. or any combination thereof. for example: `-p 4w2d6h30m15s`

`-b` provides a bandwidth between which the values will be generated. for example: `-b 100-250`

By default, a metrics pattern is random or when a value is provided a flatline. This can be changed by using a pattern argument. The options are `--linear` and `--baseline`.

* `--linear` creates a line between the values given for `-b`. plotted over the time given for `-p`.
* `--baseline` creates a daily usage curve. On Saturday and Sunday, the metric is much lower than on weekdays. The min and max of the curve are set by `-b` and the time period by `-p`.
* `--csv` reads a cvs file from the stdin and sends it to stacks state. The content of the csv file should be `timestamp,value`.

To see all available options, use `sts metrics send -h`.

#### Events

The CLI can send events using `sts events send <eventName>` It will send one event with the given name.

#### Topology

Please refer to `usage.md` provided with the CLI for detailed instructions.

### Scripting

It is possible to execute scripts using the CLI. Use `sts script` to execute a script via standard input. For example:

```text
echo "Topology.query(\"label IN ('stackpack:aws')\")" | sts-cli -i sts-test script execute
```

Do note that the script provided as input must use proper quoting.

#### License

The CLI can check your license validity `sts subscription show` and it can be used to update a license key when needed `sts subscription update new-license-key`, for example in case of expiration. Note that it is not necessary to do this via the CLI, when a license is about to expired or expired StackState will offer this option in the UI as well.

