---
description: StackState Self-hosted v4.6.x
---

# Self-signed certificates

## Overview

StackState has several points of interaction with external systems, for example event handlers can call out to webhooks in other systems while plugins can retrieve data from external systems like Splunk or Elasticsearch. With the default configuration, StackState will not be able to communicate with these systems when they are secured with TLS using a self-signed certificate or a certificate that is not by default trusted by the JVM.

To mitigate this, StackState allows configuration of a custom trust store.

## Create a custom trust store

You need to have the custom TLS certificate available. If you don't have that, you will need to [retrieve it via the browser](self-signed-cert-1.md#retrieve-certificate-via-the-browser).

To convert an existing TLS certificate file to the format that is needed by StackState, you will need to use the keytool tool and the `cacerts` file that are included in the JVM \(Java Virtual Machine\) installation. You can run this on any machine, regardless of the type of operating system.

If you don't have the JVM installed on your computer, you can also [use a JVM docker image](self-signed-cert-1.md#using-a-docker-jvm) instead.

### Using an installed JVM

With the JVM installed on your computer and the certificate saved as a file `site.cert`, you can create a new trust store by taking the JVM's trust store and adding the extra certificate.

1. Create a working directory `workdir` and copy the certificate file `site.cert` to this directory.
2. Change directory to the `workdir` and make a copy of the `cacerts` file from your Java installation. `$JAVA_HOME` is an environment variable that contains the location of your Java installation. This is normally set when installing Java.

   ```bash
   cd workdir
   cp $JAVA_HOME/lib/security/cacerts ./custom_cacerts
   ```

3. Run the following keytool command to add the certificate. The required password is `changeit`. The alias needs to be a unique alias for the certificate, for example the domain name itself without any dots.

   ```bash
   keytool -import -keystore custom_cacerts -alias <a-name-for-the-certificate>  -file site.cert
   ```

4. The `custom_cacerts` store file will now include the `site.cert` certificate. You can verify that by searching for the alias in the output of

   ```bash
   keytool -list -keystore custom_cacerts
   ```

### Using a Docker JVM

If you do not have JVM installed on your computer, you can use a JVM Docker image. The certificate should be retrieved and saved as a file `site.cert`.

1. Create a working directory `workdir` and copy the certificate file `site.cert` to this directory.
2. Start the Java Docker container with the `workdir` mounted as a volume so it can be accessed:

   ```bash
   docker run -it -v `pwd`/workdir:/workdir  adoptopenjdk:11 bash
   ```

3. Change directory to the `workdir` and make a copy of the `cacerts` file:

   ```bash
   cd /workdir
   cp $JAVA_HOME/lib/security/cacerts ./custom_cacerts
   ```

4. Run the following keytool command to add the certificate. The required password is `changeit`. The alias needs to be a unique alias for the certificate, for example the domain name itself without any dots.

   ```bash
   keytool -import -keystore custom_cacerts -alias <a-name-for-the-certificate>  -file site.cert
   ```

5. The `custom_cacerts` store file will now include the `site.cert` certificate. You can verify that by searching for the alias in the output of

   ```bash
    keytool -list -keystore custom_cacerts
   ```

## Use a custom trust store

### Kubernetes

For Kubernetes installations, the trust store and the password can be specified as values. The trust store can only be specified from the helm command line as it is a file. We specify the password value in the same way, but it could also be provided via a `values.yaml` file.

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

For a Linux installation, the trust store and password need to be added to the JVM command line used to start the StackState server process.

1. Copy the new trust store into `/opt/stackstate/etc`. 
2. Edit \(or create if it does not yet exist\) the file `/opt/stackstate/etc/processmanager/processmanager-properties-overrides.conf` and add this line:

   ```javascript
    properties.sts-jvm-args = "-Djavax.net.ssl.trustStore=/opt/stackstate/etc/custom_cacerts -Djavax.net.ssl.trustStoreType=jks -Djavax.net.ssl.trustStorePassword=changeit"
   ```

3. Finally, restart StackState to use the new settings:

   ```text
    systemctl restart stackstate
   ```

## Retrieve certificate via the browser

The certificate can be directly downloaded from the Chrome browser. The steps involved may vary slightly depending on the version you are using:

1. Navigate to the URL you need the certificate from.
2. Click on the padlock icon in the location bar.
3. Click on **Certificate**.
4. Select **Details**.
5. Select **Export**.
6. Save using the default export file type \(Base64 ASCII encoded\).

