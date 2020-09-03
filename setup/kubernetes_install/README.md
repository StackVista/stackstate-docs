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
