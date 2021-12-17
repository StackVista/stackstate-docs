# Subjects

## Link your existing authentication provider to StackState RBAC

StackState is configured by default with file based authentication with predefined roles for Guests \(very limited permission level\), Power Users and Administrators \(full permission level\). To change the configuration to use LDAP authentication, see [authentication docs](../authentication/).

## How to make a new user, or a group, with scopes?

To create a new subject \(a group or a username\), you must follow the StackState CLI route below. When you create a subject, it has no permissions at first. All custom subjects need a scope by design, so they do not have access to the full topology. This is a security requirement that makes sure that users have access only to what they need.

## Create a subject

Subjects can be created using the StackState CLI by passing a subject name and an STQL query to define the subject's scope.

```yaml
sts subject save <SUBJECT_NAME> `<STQL_QUERY>`
```
{% hint style="info" %}
**Note**

* When passing an STQL query in a CLI command, all operators \( such as `=` and `<`\) need to be surrounded by spaces.
* For LDAP authentication, the subject name must exactly match a username or group name configured in LDAP (case-sensitive).
{% endhint %}

### Examples

* Create the subject `stackstate` with a scope that allows the user to see all elements with the label `"StackState"`:
```text
sts subject save stackstate 'label = "StackState"'
```
* Create the subject `stackstateManager` that has access to elements of type `Business Applications` within the label `StackState`:
```text
sts subject save stackstateManager 'label = "StackState" AND type = "Business Application"'
```