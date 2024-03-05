---
description: StackState SaaS
---

# Template functions

## Overview

StackState Template JSON (STJ) and StackState Template YAML (STY) incorporate several custom handlebars functions that can be used, for example, to get existing nodes from the graph, create new nodes or join texts together. The available StackState functions are described below.

## StackState handlebars functions

### `add`

Adds number variables together.

#### Arguments

Two or more number variables.

#### Examples

{% tabs %}
{% tab title="Template" %}
```text
{{# add a b c }}
```
{% endtab %}

{% tab title="Data" %}
```text
[ a: 1, b: 2, c: 3 ]
```
{% endtab %}

{% tab title="Result" %}
```text
6
```
{% endtab %}
{% endtabs %}

### `concat`

The `concat` function concatenates two values:

```text
concat "Type=ComponentType;Name=" element.type.name
```

### `get`

The `get` function finds a node of a certain type by its unique identifier without needing to specify the type of the node. The function finds a node in a nested way, first finding the identifier and then finding the type and name in the scope of the first resolved node.

```text
get <identifier> Type=<type>;Name=<name>
```

#### Examples

* Resolve the `Production` `Environment` using:

  ```text
  get "urn:stackpack:aws:environment:production"
  ```

* Resolve the `Parameters` `metrics` from the CheckFunction identified by `urn:stackpack:aws:check_function:basic` using:

  ```text
  get "urn:stackpack:aws:check_function:basic" "Type=Parameter;Name=metrics"
  ```

### `getFirstExisting`

Gets the first node from a list of node identifiers \(URNs\).

#### Arguments

Two or more URNs strings.

#### Examples

{% tabs %}
{% tab title="Template" %}
```text
{{ getFirstExisting "urn:stackpack:aws:domain:Old" "urn:stackpack:aws:domain:New" }}
```
{% endtab %}

{% tab title="Data" %}
This example assumes `urn:stackpack:aws:Old:` doesn't exist, whereas `urn:stackpack:aws:domain:New` does exist.
{% endtab %}

{% tab title="Result" %}
```text
urn:stackpack:aws:domain:New
```
{% endtab %}
{% endtabs %}

### `getOrCreate`

The `getOrCreate` function first tries to resolve a node by its identifier and then by the fallback create-identifier. If none are found, the function will create a node using the specified `Type` and `Name` arguments and the newly created node will be identified with the create-identifier value.

```text
getOrCreate <identifier> <create-identifier> Type=<type>;Name=<name>
```

Note that:

* `getOrCreate` works only with the following \(simple\) types: Environment, Layer, Domain, ComponentType and RelationType.
* `create-identifier` must be a value in the `"urn:system:auto"` namespace.

We strongly encourage to use `get` and `getOrCreate` as resolving nodes by identifier is safer than by name due to the unique constraint enforced in the `identifier` values.

#### Examples

Find the `Production` `Environment` by its identifier and fallback identifier, or otherwise create it:

```text
getOrCreate "urn:stackpack:aws:environment:production" "urn:system:auto:stackpack:aws:environment:production" "Type=Environment;Name=Production"
```

### `identifier`

The `identifier` function creates an identifier out of an identifier prefix, a component type and a component name.

```text
identifier "urn:stackpack:common" "ComponentType" element.type.name
```

### `include`

{% hint style="warning" %}
This function will only work when the template is loaded from a StackPack.
{% endhint %}

Includes the content of another file inside this template. This can come in handy when template files become exceedingly large, when working with images or when you want to reuse the same template fragments in multiple locations.

#### Arguments

```text
include "<filename>" "<encoding>"
```

* **filename** - The name of the file to include from the StackPack. The file must exist in the `provisioning` directory or one of its subdirectories.
* **encoding** \(optional, default = `handlebars`\) - Choice of:
   * `handlebars` - Included file will be interpreted as StackState Templated JSON.
   * `identity` - Included file will be not be interpreted, but simply will be included as text.
   * `base64` - Included file will be loaded using a BASE64 encoding. This is possible for the image types: `png`, `jpg`, `gif` and `svg`.


#### Examples

* Include a script in a StackPack:

{% tabs %}
{% tab title="Template" %}
```yaml
_type: CheckFunction
description: Converts AWS state to StackState run state
identifier: urn:stackpack:aws:shared:check-function:aws-event-run-state
name: AWS event run state
parameters:
  - _type: Parameter
    multiple: false
    name: events
    required: true
    system: false
    type: EVENT_STREAM
returnTypes:
  - RUN_STATE
script: "{{ include "./scripts/AWS event run state.groovy" }}"
```
{% endtab %}

{% tab title="Data" %}
The file `/provisioning/script/AWS event run state.groovy` in the AWS StackPack contains `return RUNNING`
{% endtab %}

{% tab title="Result" %}
```yaml
_type: CheckFunction
description: Converts AWS state to StackState run state
identifier: urn:stackpack:aws:shared:check-function:aws-event-run-state
name: AWS event run state
parameters:
  - _type: Parameter
    multiple: false
    name: events
    required: true
    system: false
    type: EVENT_STREAM
returnTypes:
  - RUN_STATE
script: "return RUNNING"
```
{% endtab %}
{% endtabs %}

* Include an image:

{% tabs %}
{% tab title="Template" %}
```yaml
_type: ComponentType
identifier: urn:stackpack:aws:shared:component-type:aws.cloudformation
name: aws.cloudformation
iconbase64: "{{ include "./icons/aws.cloudformation.png" "base64" }}"
```
{% endtab %}

{% tab title="Data" %}
The file `/provisioning/icons/aws.cloudformation.png` is an image of the AWS CloudFormation logo.
{% endtab %}

{% tab title="Result" %}
```yaml
_type: ComponentType
identifier: urn:stackpack:aws:shared:component-type:aws.cloudformation
name: aws.cloudformation
iconbase64: data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAYAfkYAhBBGAIQQCgAhhAJACKEAEEIoAIQQCgAhhAJACKEAEEIoAIQQCgAhhAJACKEAEEIoAIQQCgAhhAJACKEAEEL65P8BEaL9HlGPnesAAAAASUVORK5CYII
```
{% endtab %}
{% endtabs %}

### `join`

Joins array or map data as a text usign a separator, prefix and suffix. This is especially handy when producing JSON arrays.

#### Arguments

```text
# join <iteratee> "<separator>" "<prefix>" "<suffix>"
```

1. **iteratee** - the element to repeat and join together.
2. **separator** - the text that is used to separate the elements.
3. **prefix** \(optional\) - text that is placed at the beginning of the joined text.
4. **suffix** \(optional\) - text is appended at the end of the joined text.

#### Examples

* Join an array of labels to create a JSON array of objects:

{% tabs %}
{% tab title="Template" %}
```text
{{# join labels "," "[" "]" }}
{
  "_type": "Label",
  "name": "{{this}}"
}
{{/ join }}
```
{% endtab %}

{% tab title="Data" %}
```text
[ labels: [ 
    "hello", 
    "world" 
] ]
```
{% endtab %}

{% tab title="Result" %}
```text
[{
  "_type": "Label",
  "name": "hello"
},{
  "_type": "Label",
  "name": "world"
}]
```
{% endtab %}
{% endtabs %}

* Join a map of labels to create a JSON array of objects:

{% tabs %}
{% tab title="Template" %}
```text
{{# join labels "," "[" "]" }}
{
  "_type": "Label",
  "name": "{{key}}:{{this}}"
}
{{/ join }}
```
{% endtab %}

{% tab title="Data" %}
```text
[ labels: [ 
    "key1": "hello", 
    "key2": "world" 
] ]
```
{% endtab %}

{% tab title="Result" %}
```text
[{
  "_type": "Label",
  "name": "key1:hello"
},{
  "_type": "Label",
  "name": "key2:world"
}]
```
{% endtab %}
{% endtabs %}

## See also

* [Using StackState templating](using_stackstate_templating.md)

