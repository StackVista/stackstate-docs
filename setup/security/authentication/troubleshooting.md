---
description: SUSE Observability Self-hosted
---

# Troubleshooting authentication and authorization

When authentication or authorization fails it usually is due to a mismatch in the configuration of the provider and SUSE Observability. To make troubleshooting easier it is possible to enable debug logging on SUSE Observability for authentication and authorization specifically.

{% hint style="warning" %}
Disable the debug logging again as soon as your are done with troubleshooting, because it is very likely debug logging contains secrets and/or personal information.
{% endhint %}

To enable debug logging copy/paste the following yaml snippet into a `debug-auth.yaml` file.

```yaml
stackstate:
  components:
    server:
      additionalLogging: |
        <logger name="org.pac4j.core.engine" level="DEBUG"/>
        <logger name="org.pac4j.oidc.profile.creator" level="DEBUG"/>
        <logger name="org.pac4j.oidc.credentials.authenticator" level="DEBUG"/>
    api:
      additionalLogging: |
        <logger name="org.pac4j.core.engine" level="DEBUG"/>
        <logger name="org.pac4j.oidc.profile.creator" level="DEBUG"/>
        <logger name="org.pac4j.oidc.credentials.authenticator" level="DEBUG"/>
```

Now run the `helm upgrade` command you used before but include this one extra yaml file (so `helm upgrade .... --values debug-auth.yaml`) to enable debug logging. No pods will be restarting, the logging configuration changes will be loaded automatically after about 30 seconds.

To disable the debug logging run the `helm upgrade ....` command again but omit the `--values debug-auth.yaml`. After 30 seconds the updated logging configuration is loaded and the debug logging stops.
