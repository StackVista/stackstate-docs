---
title: Self-signed certificates
kind: Documentation
---

# Self-signed certificates

StackState has several points of interaction with external systems, for example event handlers can call out to webhooks in other systems while plugins can retrieve data from external systems like Splunk or Elasticsearch. With the default configuration, StackState will not be able to communicate with these systems when they are secured with TLS using a self-signed certificate or a certificate that is not by default trusted by the JVM.

To mitigate this StackState allows configuration of a custom trust store.

## Creating a custom trust store

To convert an existing TLS certificate file to the format that is needed by StackState, you'll need to use the keytool tool and the cacerts file that both are included in the Java Virtual Machine installation. You can run this on any machine, regardless of the type of operating system.

You also need to have the certificate available, if you don't have that, [retrieve it via the browser](#retrieve-certificate-via-the-browser).

With the JVM installed and the certificate saved as a file `site.cert` you can create a new trust store by taking the JVM's trust store and adding the extra certificate.

1. Copy the `cacerts` file from `$JAVA_HOME/lib/security/cacerts` to `custom_cacerts` with `$JAVA_HOME` the location of your Java installation. This environment variable is normally set by the Java installation.
2. Add the extra certificate(s) with 
   ```bash
   keytool -import -keystore custom_cacerts -alias <a-name-for-the-certificate>  -file site.cert
   ```
   The alias needs to be a unique alias for the certificate, for example the domain name itself without any dots. Keytool will ask for a password. The password usually is `changeit`, the JVM default.

The `custom_cacerts` store file will now include the `site.cert` certificate. You can verify that by searching for the alias in the output of

```bash
keytool -list -keystore custom_cacerts
```

## Using the custom trust store

### Kubernetes
For Kubernetes installations the trust store and the password can be specified as values. Since the store is a file it can only be specified from the helm command line. We specify the password value in the same way, but it could also be provided via a `values.yaml` file.

```bash
helm upgrade \
  --install \
  --namespace stackstate \
  --values values.yaml \
  --set-file 'stackstate.java.trustStore'=custom_cacerts \
  --set 'stackstate.java.trustStorePassword'=changeit \
stackstate \
stackstate/stackstate
```

{% hint style="info" %}
**Note:**
* The first run of the helm upgrade command will result in pods restarting, which may cause a short interruption of availability.
* Include these arguments on every `helm upgrade` run.
* The password and trust store are stored as a Kubernetes secret.
{% endhint %}

### Linux
For a Linux installation the trust store and password need to be added to the JVM command line used to start the StackState server process.

Copy the new trust store into `/opt/stackstate/etc`. Now edit (or create if it does not yet exist) `/opt/stackstate/etc/processmanager/processmanager-properties-overrides.conf` and add this line:

```javascript
properties.sts-jvm-args = "-Djavax.net.ssl.trustStore=/opt/stackstate/etc/custom_cacerts -Djavax.net.ssl.trustStoreType=jks -Djavax.net.ssl.trustStorePassword=changeit"
```

Finally restart StackState to use the new settings:
```
systemcl restart stackstate
```

## Retrieve certificate via the browser

With the Chrome browser it is possible to download the certificate directly from the browser. Due to different versions the steps involved may be slightly different in your case.

1. Navigate to the URL you need the certificate from
2. Click on the padlock icon in the location bar
3. Click on "Certificate"
4. Select "Details"
5. Select "Export" 
6. Save using the default export file type (Base64 ASCII encoded)
  