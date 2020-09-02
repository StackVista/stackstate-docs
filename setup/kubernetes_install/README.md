# Installing StackState on Kubernetes



### Further customizations

On the readme of the [chart](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate) the possible customizations are documented. For example it is possible to customize the `tolerations` and `nodeSelectors` for each of the components.

### Changing configuration

For Stackstate server the Helm chart has a value to drop in custom configuration, this is especially convenient for customizing authentication. An example to set a different "forgot password link" \(for the StackState login page\):

```text
stackstate:
  components:
    server:
      config: |
        stackstate.api.authentication.forgotPasswordLink = "https://www.stackstate.com/forgotPassword.html"
```

The configuration from this value will be available to StackState as its configuration file in [HOCON](https://github.com/lightbend/config/blob/master/HOCON.md) format. This is the advised way to override the default configuration that StackState ships with.

For all of the StackState services \(`receiver`, `k2es-*`, `correlation`, `server`\) it is possible to change settings via environment variables. For `server` these will override even the customizations done via the `config` value. The environment variables can be provided via the helm chart, both for secret settings \(passwords for example\) and normal values. Here an example that changes both the default password and again the "forgot password link". To convert it to an environment variable `.` are replaced by `_` and a prefix `CONFIG_FORCE_` is added. Now it can be set via `values.yaml`:

```text
stackstate:
  components:
    server:
      extraEnv:
        # Use 'secret' instead of open for things that should be stored as a secret
        open:
          CONFIG_FORCE_stackstate_api_authentication_forgotPasswordLink: "https://www.stackstate.com/forgotPassword.html"
```

For details on the naming of all the different services in the StackState Helm chart see its [readme](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/README.md). For another examle have a look at the next section about authentication settings.

### Configuring authentication and authorization

The supported authentication mechanisms for StackState are discussed [here](../authentication.md) in more detail. To keep using configuration file based authentication but change the users here is an example to have 2 users, `admin-demo` and `guest-demo`, with the 2 default roles available, the md5 hash still needs to be generated and put in the example.

```text
stackstate:
  components:
    server:
      config: |
        stackstate.api.authentication.authServer.stackstateAuthServer {
          logins = [
            { username = "admin-demo", password: "<md5-hash>", roles = ["stackstate-admin"] }
            { username = "guest-demo", password: "<md5-hash>", roles = ["stackstate-guest"] }
          ]
        }
```

Here the custom config file is used for configuration, to do this with environment variables would be very cumbersome. This same approach can be used to, for example, to switch to LDAP based authentication as discussed in the authentication docs.

## Upgrading

For upgrading the same command can be used as for the [first time installation](./). Do check the release notes and any optional upgrade notes before running the upgrade.

## Backups

Several mechanisms can be used for backups. When running in EKS or AKS the easiest setup is to periodically make snapshots of all the volumes attached to the StackState processes \(i.e. in the same namespace\). A tool that can automate this for you is [Velero](https://velero.io/).

Next to this StackState has the ability to export its configuration. This configuration can then be imported again at a later time, in a clean StackState instance or it can be used as a starting point to setup a new StackState environment. The most convenient way to create an export and later ipmort it again is to use the [StackState CLI](../../cli.md) import and export commands.

Exporting is as simple as running `sts-cli graph export stackstate_settings.stj`. Importing of an export can be done with the cli as well but is only adviced on an empty StackState \(a new deployment\). If it is not empty it will very likely fail. To import run this command `cat stackstate_settings.stj | sts-cli graph import`.

## Development / test environment deployments

The standard deployment is a production ready setup with many processes running multiple replicas. For development and testing it can be desirable to run StackState with lower resource requirements. For that purpose several example `values.yaml` files are provided in the [helm chart repository](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation/examples):

* `test_values.yaml` that sets the replica count for all services to 1, this effectively reduces the number of required nodes from 6 to 3.
* `micro_test_values.yaml` goes even further and also reduces the memory footprint of most services, thereby making it possible to run StackState within about 16GB of memory.

Note that the generated `values.yaml` should also still be included on the helm command line, e.g.:

```text
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --values test_values.yaml \
stackstate \
stackstate/stackstate
```

_WARNING:_ Both the test and micro test deployment are not suitable for bigger workloads and are not supported for production usage.
