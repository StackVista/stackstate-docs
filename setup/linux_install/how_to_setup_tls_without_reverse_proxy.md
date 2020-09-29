# Set up TLS without reverse proxy

{% hint style="info" %}
StackState prefers Kubernetes!  
In the future we will move away from Linux support. Read about [installing StackState on Kubernetes](../kubernetes_install/).
{% endhint %}

This document provides the steps to set up TLS on StackState application side with no reverse proxy configured.

## Prerequisites

Prepare a TLS keypair in [PKCS12](https://en.wikipedia.org/wiki/PKCS_12) format. Certificate should include the hostname by which StackState will be accessed, e.g. `stackstate.infra.company.tld`.

## Configure StackState

### Step 1. Configure applications

**a.** Enable TLS for Web UI/API by configuring section `stackstate.api.tls` in `etc/application_stackstate.conf`:

```text
tls {
  enabled = true
  keystore {
    path = "/path/to/keystore.pfx"
    password = "password"
    storeType = "PKCS12"
  }
}
```

**b.** Enable TLS for topology/telemetry receiver by configuring a section `stackstate.tls` in `etc/stackstate-receiver/application.conf`:

```text
tls {
  enabled = true
  keystore {
    path = "/path/to/keystore.pfx"
    password = "password"
    storeType = "PKCS12"
  }
}
```

### Step 2. Configure the process manager

**a.** Configure health check URL \(`properties.receiver-healthcheckuri`\) in `etc/processmanager/processmanager-properties.conf` using `https` protocol and the hostname:

```text
 receiver-healthcheckuri = "https://stackstate.infra.company.tld:7077/health"
```

**b.** \(optional, if a self-signed certificate is used\) Make process manager trust self-signed certificate by adding the following settings under `server.akka` section in `etc/processmanager/processmanager-properties.conf`:

```text
ssl-config {
  trustManager = {
    stores = [
      {type: "PEM", path: "/path/to/certificate-authority.pem"},
    ]
  }
}
```

### Step 3. Configure Stackpacks configuration defaults

Configure the default receiver URL \(`stackstate.receiver.baseUrl`\) in `etc/application_stackstate.conf` using `https` protocol and the hostname:

```text
stackstate.receiver.baseUrl = "https://stackstate.infra.company.tld:7077"
```

### Step 4. Apply changes

Restart StackState to apply these changes:

```text
sudo systemctl restart stackstate.service
```

## Configure StackState Agent

### Option 1. Agent running in Docker

**a.** \(optional, for self-signed certificates\) Prepare a self-signed certificate to be mounted into the container:

```text
mkdir self-signed-certs
cd self-signed-certs
cp /path/to/certificate-authority.pem ./ca.crt
cp ./ca.crt ./ca-certificates.crt
```

**b.** Update the docker container parameters with:

* configured URLs with `https` and the hostname in environment variables for receiver endpoints
  * `STS_STS_URL=https://stackstate.infra.company.tld:7077/stsAgent`
  * `STS_APM_URL=https://stackstate.infra.company.tld:7077/stsAgent`
  * `STS_PROCESS_AGENT_URL=https://stackstate.infra.company.tld:7077/stsAgent`
* \(for self-signed\) mount prepared certificates into `/etc/ssl/certs` of a container

Example:

```text
docker run -ti --rm\
    -e STS_API_KEY=<api key>
    -v /path/to/self-signed-certs:/etc/ssl/certs \
    -e STS_STS_URL=https://stackstate.infra.company.tld:7077/stsAgent \
    -e STS_APM_URL=https://stackstate.infra.company.tld:7077/stsAgent \
    -e STS_PROCESS_AGENT_URL=https://stackstate.infra.company.tld:7077/stsAgent \
    stackstate/stackstate-agent-2:2.1.0
```

### Option 2. Agent running on machine

**a.** Update the receiver URLs using `https` and the hostname in `/etc/stackstate-agent/stackstate.yaml`:

```text
sts_url: https://stackstate.infra.company.tld:7077/stsAgent
process_sts_url: https://stackstate.infra.company.tld:7077/stsAgent
apm_sts_url: https://stackstate.infra.company.tld:7077/stsAgent
```

**b.** If a self-signed certificate is used, then import it with the default keystore of the operating system. Ubuntu:

```text
cp /path/to/certificate-authority.pem /usr/local/share/ca-certificates/stackstate.crt # extension .crt is important here
sudo update-ca-certificates
```

