# Subjects

## Link your existing authentication provider to StackState RBAC

StackState is configured by default with file based authentication with predefined roles for Guests \(very limited permission level\), Power Users and Administrators \(full permission level\). To change the configuration to use LDAP authentication, see [authentication docs](../authentication/).

## Create a subject

Subjects can be created using the StackState CLI by passing a user or group name and an [STQL query](/develop/reference/stql_reference.md) to define the subject's scope.

```yaml
sts subject save <USER_OR_GROUP_NAME> `<STQL_QUERY>`
```
{% hint style="info" %}
* All operators in the STQL query \( such as `=` and `<`\) must be surrounded by spaces.
* For LDAP authentication, the subject name must exactly match a username or group name configured in LDAP (case-sensitive).
{% endhint %}

### Examples

* Create a subject `stackstate` with access to all elements that have the label `"StackState"`:
    ```text
    sts subject save stackstate 'label = "StackState"'
  
    ```
* Create a subject `stackstateManager` with access to elements of type `Business Applications` within the label `StackState`:
    ```text
    sts subject save stackstateManager 'label = "StackState" AND type = "Business Application"'
  
    ```