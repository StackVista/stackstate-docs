---
description: SUSE Observability Self-hosted
---

# Prepare air-gapped SUSE Observability deployment

Installing in an air-gapped environment, where there is no internet access available, requires some extra preparation steps before SUSE Observability can be installed. 

1. [Configure Helm on your local machine](./stackstate_installation.md#configure-helm)
2. [Download and copy the SUSE Observability Helm chart](./stackstate_installation.md#download-and-copy-the-stackstate-helm-chart)
3. [Copy the SUSE Observability docker images](./stackstate_installation.md#copy-the-stackstate-docker-images)
4. [Prepare local docker registry configuration](./stackstate_installation.md#prepare-local-docker-registry-configuration)

Note that step 2 requires a Docker registry that's available to the Kubernetes cluster and can store all SUSE Observability docker images.

## Configure Helm

Configure Helm on your local machine to be able to pull the SUSE Observability Helm chart.

```bash
helm repo add stackstate https://helm.stackstate.io
helm repo update
```

## Download and copy the SUSE Observability helm chart

{% hint style="info" %}
Make sure to first run `helm repo update` again to have the latest version of the Helm chart available.
{% endhint %}

Download the latest SUSE Observability helm chart like this:

```bash
helm pull stackstate/stackstate-k8s
```

This results in a file like this `stackstate-k8s-1.0.4.tgz`. Copy this file (using scp, sftp or any other tool available) to the system from which SUSE Observability will be installed.

## Copy the SUSE Observability docker images

{% hint style="info" %}
Make sure to first run `helm repo update` again to have the latest version of the Helm chart available.
{% endhint %}

Download the `copy_images.sh` bash script from the [SUSE Observability Helm chart Github repository](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate-k8s/installation) and make it executable:

```bash
chmod +x copy_images.sh
```

The script can copy images directly from SUSE Observability's Quay.io registry to your internal registry. If the internal registry isn't accessible from a computer that has direct internet access an intermediate step is needed.

{%tabs %}
{% tab title="Copy direct to local registry" %} 
To copy the images directly from the SUSE Observability registry to the internal registry run the script like this to copy the images to the registry at `registry.acme.com:5000`:

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
# Produce a list of all SUSE Observability images in the stackstate_images.txt file
STS_REGISTRY_USERNAME=noop STS_REGISTRY_PASSWORD=noop ./copy_images.sh -t -d noop | cut -d' ' -f2 > stackstate_images.txt

# Authenticate to the SUSE Observability quay.io repositories using the credentials provided by SUSE Observability
docker login quay.io

# Save all images to the local file system
mkdir images
while read image; do
  name=$(echo "$image" | cut -d'/' -f3)
  docker pull --platform linux/amd64 "$image"
  docker save "$image" -o "images/${name}.tar"
done < stackstate_images.txt

# Now copy images to the air-gapped environment, for example using scp or sftp. Also copy the stackstate_images.txt file

# On a computer inside the air-gapped environment load, re-tag and push the images, this uses registry.acme.com:5000 as the internal registry
while read image; do
  name=$(echo "$image" | cut -d'/' -f3)
  target_image="registry.acme.com:5000/stackstate/$name"
  docker load -i "images/${name}.tar"
  docker tag "$image" "$target_image"
  docker push "$target_image"
done < stackstate_images.txt
```

{% endtab %}
{% endtabs %}

## Prepare local Docker registry configuration

In preparation for the installation of SUSE Observability create a `local-docker-registry.yaml` values file that will be used during the Helm installation of SUSE Observability. Include the following configuration in that file, replacing the `registry.acme.com:5000` with your internal docker registry where the docker images have been uploaded in the ealier steps.

```yaml
global:
  imageRegistry: registry.acme.com:5000
elasticsearch:
  prometheus-elasticsearch-exporter:
    image:
      repository: registry.acme.com:5000/stackstate/elasticsearch-exporter
victoria-metrics-0:
  server:
    image:
      repository: registry.acme.com:5000/stackstate/victoria-metrics
victoria-metrics-1:
  server:
    image:
      repository: registry.acme.com:5000/stackstate/victoria-metrics
```

## See also

* [Air-gapped agent installation](./agent_install.md)
