---
description: StackState Self-hosted
---

# Prepare air-gapped agent installation

When running in an air-gapped environment extra preparation is needed before the agent can be installed:

1. [Configure Helm on your local machine](./agent_install.md#configure-helm)
1. [download the agent helm chart](./agent_install.md#download-the-agent-helm-chart)
1. [copy the Agent docker images](./agent_install.md#copy-agent-docker-images)
2. [customize the helm command](./agent_install.md#customize-the-helm-command)

## Configure Helm

Configure helm on your local machine to be able to pull the StackState Helm chart.

```bash
helm repo add stackstate https://helm.stackstate.io
helm repo update
```

## Download the agent Helm chart

{% hint style="info" %}
Make sure to first run `helm repo update` again to have the latest version of the Helm chart available.
{% endhint %}

Download the latest agent helm chart like this:

```bash
helm pull stackstate/stackstate-k8s-agent
```

This results in a file like this `stackstate-k8s-agent-1.0.30.tgz`. Copy this file (using scp, sftp or any other tool available) to the system from which the agent will be installed.

## Copy agent Docker images

{% hint style="info" %}
Make sure to first run `helm repo update` again to have the latest version of the Helm chart available.
{% endhint %}

Download the `copy_images.sh` bash script from the [Agent Helm chart Github repository](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate-k8s-agent/installation) and make it executable:

```bash
chmod +x copy_images.sh
```

The script can copy images directly from StackState's Quay.io registry to your internal registry. If the internal registry isn't accessible from a computer that has direct internet access an intermediate step is needed.

{%tabs %}
{% tab title="Copy direct to local registry" %} 
To copy the images directly from the StackState registry to the internal registry run the script like this to copy the images to the registry at `registry.acme.com:5000`:

```bash
STS_REGISTRY_USERNAME=... STS_REGISTRY_PASSWORD=... DST_REGISTRY_USERNAME=... DST_REGISTRY_PASSWORD=...  ./copy_images.sh -d registry.acme.com:5000
```

The environment variables are used to setup authentication. If the destination registry doesn't require authentication the `DST_REGISTRY_*` variables can be omitted.

The script extracts all images from the Helm chart and copies the images to the local registry. Depending on the speed of the internet connection this might take a while.

{% endtab %}

{% tab title="Copy indirect" %} 

When it's impossible to directly copy the images to the internal registry the images can be listed using the `copy_images.sh` script. The best way to download, re-tag, and copy the images to the internal registry depends on the exact circumstances.

Here is an example way of working that uses the `copy_images.sh` script to produce a list of images and then uses bash scripting to download, re-tag and upload all images. Depending on the exact situation this may need be adapted.

```bash
# Produce a list of all StackState images in the stackstate_agent_images.txt file
STS_REGISTRY_USERNAME=noop STS_REGISTRY_PASSWORD=noop ./copy_images.sh -t -d noop | cut -d' ' -f2 > stackstate_agent_images.txt

# Authenticate to the StackState quay.io repositories using the credentials provided by StackState
docker login quay.io

# Save all images to the local file system
mkdir agent_images
while read image; do
  name=$(echo "$image" | cut -d'/' -f3)
  docker pull --platform linux/amd64 "$image"
  docker save "$image" -o "agent_images/${name}.tar"
done < stackstate_agent_images.txt

# Now copy images to the air-gapped environment, for example using scp or sftp. Also copy the stackstate_agent_images.txt file

# On a computer inside the air-gapped environment load, re-tag and push the images, this uses registry.acme.com:5000 as the internal registry
while read image; do
  name=$(echo "$image" | cut -d'/' -f3)
  target_image="registry.acme.com:5000/stackstate/$name"
  docker load -i "agent_images/${name}.tar"
  docker tag "$image" "$target_image"
  docker push "$target_image"
done < stackstate_agent_images.txt
```

{% endtab %}
{% endtabs %}

## Customize the Helm command

The StackState UI provides the exact commands to install the agent depending on the distribution but it assumes the internet is accessible. For air-gapped installations the command needs to be extended to use the local copy of the helm chart and to override the docker registry with the local registry. If the local docker registry requires authentication a custom image pull secret can be provided.

{% tabs %}
{% tab title="Registry without authentication" %}

This example uses the command for the standard Kubernetes distribution to show how to use a local copy of the Helm chart and add the extra registry argument. Please make sure to use the command that corresponds with your Kubernetes distribution as provided in the StackState UI and apply the same modifications (this example uses `registry.acme.com:5000` as the registry).

{% hint style="warning" %}
This command isn't the right command for your Kubernetes cluster. Instead, copy the command for your Kubernetes distribution from the installed Kubernetes StackPack in the UI. Then replace `stackstate-k8s/stackstate` with the `.tgz` file and add the image registry argument.
{% endhint %}

```bash
helm upgrade --install \
--namespace stackstate \
--create-namespace \
--set-string 'stackstate.apiKey'='<api-key>' \
--set-string 'stackstate.cluster.name'='acme-prod' \
--set-string 'stackstate.url'='https://stackstate.acme.local/receiver/stsAgent' \
--set-string 'logsAgent.enabled'='true' \
--set-string 'all.image.registry'="registry.acme.com:5000" \
--set-string 'global.imageRegistry'='registry.acme.com:5000' \
stackstate-k8s-agent ./stackstate-k8s-agent-1.0.30.tgz
```

The modifications are:

* Adding the last `--set-string` argument
* Replacing `stackstate/stackstate-k8s-agent` to reference the Helm chart with the Helm chart filename `./stackstate-k8s-agent-1.0.30.tgz`

{% endtab %}
{% tab title="Registry with authentication" %}

This example uses the command for the standard Kubernetes distribution to show how to use a local copy of the Helm chart and add the extra registry argument. Please make sure to use the command that corresponds with your Kubernetes distribution as provided in the StackState UI and apply the same modifications (this example uses `registry.acme.com:5000` as the registry):

{% hint style="warning" %}
This command isn't the right command for your Kubernetes cluster. Instead, copy the command for your Kubernetes distribution from the installed Kubernetes StackPack in the UI. Then replace `stackstate-k8s/stackstate` with the `.tgz` file and add the image registry and pull secret arguments.
{% endhint %}

```bash
helm upgrade --install \
--namespace stackstate \
--create-namespace \
--set-string 'stackstate.apiKey'='<api-key>' \
--set-string 'stackstate.cluster.name'='acme-prod' \
--set-string 'stackstate.url'='https://stackstate.acme.local/receiver/stsAgent' \
--set-string 'logsAgent.enabled'='true' \
--set-string 'all.image.registry'="registry.acme.com:5000" \
--set-string 'global.imageRegistry'='registry.acme.com:5000' \
--set-string 'global.imagePullSecrets[0]'="acme-registry-pull-secret-name" \
stackstate-k8s-agent ./stackstate-k8s-agent-1.0.30.tgz
```

The modifications are:

* Adding the last 2 `--set-string` arguments
* Replacing `stackstate/stackstate-k8s-agent` to reference the Helm chart with the Helm chart filename `./stackstate-k8s-agent-1.0.30.tgz`

{% endtab %}
{% endtabs %}
