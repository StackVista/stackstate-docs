# Installing StackState on Kubernetes

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

For upgrading the same command can be used as for the [first time installation](install_stackstate.md). Be sure to check the release notes and any optional upgrade notes before running the upgrade.

## Backups

Several mechanisms can be used for backups. When running in EKS or AKS the easiest setup is to periodically make snapshots of all the volumes attached to the StackState processes \(i.e. in the same namespace\). A tool that can automate this for you is [Velero](https://velero.io/).

Next to this StackState has the ability to export its configuration. This configuration can then be imported again at a later time, in a clean StackState instance or it can be used as a starting point to setup a new StackState environment. The most convenient way to create an export and later ipmort it again is to use the [StackState CLI](../../cli.md) import and export commands.

Exporting is as simple as running `sts-cli graph export stackstate_settings.stj`. Importing of an export can be done with the cli as well but is only adviced on an empty StackState \(a new deployment\). If it is not empty it will very likely fail. To import run this command `cat stackstate_settings.stj | sts-cli graph import`.
