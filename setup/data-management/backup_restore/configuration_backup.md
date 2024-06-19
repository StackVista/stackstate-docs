---
description: StackState Self-hosted
---

# Configuration backup

## Overview

StackState configuration can be exported and imported. The import/export functionality can be used to automate the installation process or for backup purposes. An export and import can be made in the settings page of StackState's user interface by using the buttons 'Export Model' and 'Import Model'.

## Export configuration

An export of the StackState configuration can be obtained from the StackState UI, the [StackState CLI](../../cli/k8sTs-cli-sts.md) or using curl commands. 

### StackState CLI

{% hint style="info" %}
Note that the [lock status](../../../stackpacks/about-stackpacks.md#locked-configuration-items) of configuration items installed by a StackPack configuration won't be included in the export.
{% endhint %}

To export configuration using the `sts` CLI, run the command:

```text
# Output in terminal window
sts settings describe

# Export to file
sts settings describe --file <PATH_TO_FILE.sty>
```

### curl

{% hint style="info" %}
Note that the [lock status](../../../stackpacks/about-stackpacks.md#locked-configuration-items) of configuration items installed by a StackPack configuration won't be included in the export.
{% endhint %}

To export configuration using curl, follow the steps below. The `<api-token>` used for authorization is available on the **CLI** page in the StackState UI main menu:

```text
# Do actual request
curl -X POST \
  -H "Authorization: ApiToken <api-token>" \
  -H 'Content-Type: application/json;charset=UTF-8' \
  -d '{}' \
  "http://<HOST>/api/export?timeoutSeconds=300" > export.sty
```

### StackState UI

{% hint style="info" %}
Note that the [lock status](../../../stackpacks/about-stackpacks.md#locked-configuration-items) of configuration items installed by a StackPack configuration won't be included in the export.
{% endhint %}

To export configuration from the StackState UI:

1. Go to **Settings** &gt; **Import/Export** &gt; **Export Settings**
2. Click the button **STS-EXPORT-ALL**.

![Export configuration from the StackState UI](../../../.gitbook/assets/v51_export_configuration.png)

## Import configuration

### StackState CLI

{% hint style="info" %}
* Import is intended to be a one-off action - importing multiple times might result in duplicate configuration entries. This behavior applies to importing nodes without any identifier. 
* Note that the [lock status](../../../stackpacks/about-stackpacks.md#locked-configuration-items) of configuration items installed by a StackPack won't be included in configuration export files - **all configuration items will be unlocked after import**.
{% endhint %}

To import StackState configuration using the `sts` CLI, follow the steps below.

Before import, clear the StackState configuration by following the instructions at [clear stored data](/setup/data-management/clear_stored_data.md). 

```text
sts settings apply --file <PATH_TO_FILE.sty>
```

### curl

{% hint style="info" %}
* Import is intended to be a one-off action - importing multiple times might result in duplicate configuration entries. This behavior applies to importing nodes without any identifier. 
* Note that the [lock status](../../../stackpacks/about-stackpacks.md#locked-configuration-items) of configuration items installed by a StackPack won't be included in configuration export files - **all configuration items will be unlocked after import**.
{% endhint %}

To import StackState configuration using curl with authentication, follow the steps below.

Before import, clear the StackState configuration by following the instructions at [clear stored data](/setup/data-management/clear_stored_data.md). 

The `<api-token>` can be found on the **CLI** page in the StackState UI main menu.

```text
curl -X POST -d @export.sty \
  -H "Authorization: ApiToken <api-token>" \
  -H 'Content-Type: application/json;charset=UTF-8' \
  "http://<HOST>/api/import?timeoutSeconds=15"
```

### StackState UI

{% hint style="info" %}
* Import is intended to be a one-off action - importing multiple times might result in duplicate configuration entries. This behavior applies to importing nodes without any identifier. 
* Note that the [lock status](../../../stackpacks/about-stackpacks.md#locked-configuration-items) of configuration items installed by a StackPack won't be included in configuration export files - **all configuration items will be unlocked after import**.
{% endhint %}

Before import, clear the StackState configuration by following the instructions at [clear stored data](/setup/data-management/clear_stored_data.md).

To import StackState configuration in the StackState UI:

1. Go to **Settings** &gt; **Import/Export** &gt; **Import Settings**.
2. Choose the `*.sty` file that you want to import configuration from.
3. Click the button **START IMPORT**.

![Import configuration from the StackState UI](../../../.gitbook/assets/v51_import_configuration.png)

## Advanced import/export

### Individual configuration items

It's possible to export and import individual configuration items through the StackState user interface. For example, to export or export a component type:

1. Go to the **Settings** page and click **Component Types**.
2. To export an individual component type, click **Export as config**.
3. To import a configuration item, click **Import Model**.

### Idempotent import/export

There is a way to use identifiers and namespaces that come with them to perform a configuration update of the specific sets of nodes idempotently. This approach doesn't lead to duplicates, but checks for the changes within a specified namespace and applies them to existing nodes, including removing nodes, as well as allow for creating the new ones.

Node identifiers are specified in a following pattern: `urn:stackpack:{stackpack_name}:{type_name}:{object_name}`. The namespace effectively used by this process is `urn:stackpack:{stackpack_name}:`. If every configuration node has an identifier and they're all in the same namespace, then you can perform an idempotent update using following STS CLI commands:

#### export

```sh
sts settings describe --namespace urn:stackpack:{stackpack_name}:
```

#### import

```
curl -XPOST http://yourInstance/api/import?namespace=urn:stackpack:{stackpack_name} \
    --data @./filename \
    -H 'Content-Type: application/json'
```
