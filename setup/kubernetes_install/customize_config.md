# Customize StackState configuration

The readme of the [StackState Helm chart](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate) documents all possible customizations. For example, it is possible to customize the `tolerations` and `nodeSelectors` for each of the components.

## Change configuration

For StackState server, the Helm chart has a value to drop in custom configuration, this is especially convenient for customizing authentication. An example to set a different "forgot password link" \(for the StackState login page\):

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
