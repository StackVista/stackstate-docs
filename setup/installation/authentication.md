---
title: Configuring authentication
kind: Documentation
---

# Configuring authentication

Out of the box, StackState is configured with [file-based authentication](authentication.md#configuring-file-based-authentication), which authenticates users against a file on the server. In addition to this mode, StackState can also authenticate users against the following authentication servers:

* [LDAP](authentication.md#configuring-the-ldap-authentication-server)
* [KeyCloak OIDC](authentication.md#configuring-the-keycloak-oidc-authentication-server)

When a user is authenticated, the user has one of two possible roles in StackState:

* **guest users** - able to see information but make no changes
* **administrators** - able to see and change all configuration

StackState uses the file `etc/application_stackstate.conf` in the StackState installation directory for authentication configuration. After changing this file restart StackState for any changes to take effect.

## Default username and password

StackState is configured by default with the following administrator account:

* username: `admin`
* password: `topology-telemetry-time`

## Turning off authentication

If StackState runs without authentication, anyone who has access to the StackState URL will be able to use the product without any restrictions.

To turn off authentication completely, use the following configuration setting:

```javascript
stackstate.api.authentication.enabled = false
```

Note that in the [HOCON configuration format](https://github.com/lightbend/config/blob/master/HOCON.md) this has exactly the same meaning as:

```javascript
stackstate { api { authentication { enabled = false } } }
```

## Configuring file-based authentication

Here is an example of `authentication` that configures a user `admin/password` and a user `guest/password`. Place it within the `stackstate { api {` block of the `etc/application_stackstate.conf`. Make sure to remove the line `authentication.enabled = false` to `authentication.enabled = false` in the `application_stackstate.conf` file. Restart StackState to make the change take effect.

```javascript
authentication {
  enabled  = true

  basicAuth = false

  # Amount of time to keep a session when a user does not log in
  sessionLifetime = 7d

  authServer {
    authServerType = "stackstateAuthServer"

    stackstateAuthServer {
      # echo -n "password" | md5sum
      # Open http://www.md5.net/md5-generator/
      # Enter your password and press submit, you will get an MD5 Hash
      # Set the MD5 Hash into `auth.password`
      logins = [
        { username = "admin", password: "5f4dcc3b5aa765d61d8327deb882cf99", roles = ["stackstate-admin"] }
        { username = "guest", password: "5f4dcc3b5aa765d61d8327deb882cf99", roles = ["stackstate-guest"] }
      ]
    }
  }
  adminGroups = ["stackstate-admin"]
  guestGroups = ["stackstate-guest"]
}
```

Configuration field explanation:

1. **sessionLifeTime** - when users log into StackState, they start a session with StackState during which they can access the system. This setting controls the duration of those sessions.
2. **authServer** - configures the authentication server StackState uses. It's configuration is specified below.
3. **password** - the user's password in MD5 hash format.
4. **roles** - the list of roles the user is a member of.
5. **adminGroups** - the list of groups whose members StackState grants administrative privileges.
6. **guestGroups** - the list of groups whose members have guest access privileges\(read-only\) in StackState.

## Configuring the LDAP authentication server

Here is an example of an authentication configuration that uses a localhost LDAP server. Place it within the `stackstate { api {` block of the `etc/application_stackstate.conf`. Make sure to change the line `authentication.enabled = false` to `authentication.enabled = true` in the `application_stackstate.conf` file. Restart StackState to make the change take effect.

```javascript
authentication {
  enabled  = true

  basicAuth = false

  # Amount of time to keep a session when a user does not log in
  sessionLifetime = 7d

  authServer {
    authServerType = "ldapAuthServer"

    ldapAuthServer {
      connection {
        host = localhost
        port = 8000
        # ssl {
        #    sslType = ssl
        #    trustCertificatesPath = "/var/lib/ssl/sts-ldap.pem"
        #    trustStorePath = "/var/lib/ssl/cacerts"
        # }
        bindCredentials {
           dn = "administrator@stackstate.com"
           password = "password"
         }
      }
      userQuery {
        parameters = [
          { ou : management }
          { o : stackstate }
          { cn: people }
          { dc : example }
          { dc : com }
        ]
        usernameKey = cn
      }
      groupQuery {
        parameters = [
          { ou : groups }
          { o : stackstate }
          { cn: people }
          { dc : example }
          { dc : com }
        ]
        rolesKey = cn
        groupMemberKey = member
      }
    }
  }
  guestGroups = ["stackstate-guest"]
  adminGroups = ["stackstate-admin"]
}
```

Configuration field explanation:

1. **sessionLifeTime** - when users log into StackState, they start a session with StackState during which they can access the system. This setting controls the duration of those sessions.
2. **authServer** - configures the authentication server StackState uses. It's configuration is specified below.
3. **ldapAuthServer** - LDAP configuration requires information about connecting to the LDAP server and how to query the server for users.
   * _**query, userQuery and groupQuery**_ - The set of parameters inside correspond to the base dn of your LDAP for where users and groups can be found. The first one is used for authenticating users in StackState, while the second is used for retrieving the group of that user to determine if the user is an admin or a guest.
   * _**sslType**_ - the type of LDAP secure connection `ssl` \| `startTls`
   * _**trustCertificatesPath**_ - optional, path to the trust store on the StackState server. Formats PEM, DER and PKCS7 are supported.
   * _**trustStorePath**_ - optional, path to the trust store on the StackState server.
   * \(if both `trustCertificatesPath` and `trustStorePath` are specified, `trustCertificatesPath` takes precedence\)
   * _**bindCredentials**_ - used to authenticate StackState to LDAP server.
   * _**usernameKey**_ - the name of the attribute that stores the username.
   * _**groupMemberKey**_ - the name of the attribute that indicates whether a user is a member of a group. The constructed LDAP filter follows this pattern: `({groupMemberKey}=email=admin@sts.com,ou=management,o=stackstate,cn=people,dc=example,dc=com)`.
   * _**rolesKey**_ - the name of the attribute that stores the group name.
4. **adminGroups** - the list of roles whose members StackState grants administrative privileges.
5. **guestGroups** - the list of groups whose members have guest access privileges\(read-only\) in StackState.

Please note that StackState can check for user files in LDAP main directory as well as in all subdirectories. To do that StackState LDAP configuration requires `bind credentials` configured. Bind credentials are used to authenticate StackState to LDAP server, only after that StackState passes the top LDAP directory name for the user that wants to login to StackState.

After editing the config file with the required LDAP details, move on to the [subject configuration doc](../../configure/subject_configuration.md). With subjects created, you can start [setting up roles](../../configure/how_to_set_up_roles.md).

### Configuring the KeyCloak OIDC Authentication Server

In order to configure StackState to authenticate to an KeyCloak OIDC authentication server, you will need to configure both of them to be able to talk to each other. The following sections describe the respective setups.

#### Configuring StackState to authenticate against a KeyCloak OIDC Authentication Server

Here is an example of an authentication configuration that uses a running KeyCloak server. Place it within the `stackstate { api {` block of the `etc/application_stackstate.conf`. Make sure to change the line `authentication.enabled = false` to `authentication.enabled = true` in the `application_stackstate.conf` file. Restart StackState to make the change take effect.

```javascript
authentication {
  enabled  = true

  basicAuth = false

  authServer {
    authServerType = "keycloakAuthServer"

    keycloakAuthServer {
      clientId = stackstate
      secret = 8051a2e4-e367-4631-a0f5-98fc9cdc564d
      keycloakBaseUri = "http://keycloak.acme.com:8011/auth"
      realm = acme
      redirectUri = "http://stackstate.acme.com:7070/loginCallback"
      authenticationMethod = "client_secret_basic"
      jwsAlgorithm = "RS256"
    }
  }
  guestGroups = ["stackstate-guest"]
  adminGroups = ["stackstate-admin"]
}
```

Configuration field explanation:

1. **clientId** - The ID of the KeyCloak client as configured in KeyCloak
2. **secret** - The secret attached to the KeyCloak client, which is used to authenticate this client to KeyCloak
3. **keycloakBaseUri** - The base URI for the KeyCloak instance
4. **realm** - The KeyCloak realm to connect to
5. **redirectUri** - The URI where the login callback endpoint of StackState is reachable
6. **authenticationMethod** - Set this to `client_secret_basic` which is the only supported value for now
7. **jwsAlgorithm** - Set this to `RS256`, which is the only supported value for now

The KeyCloak specific values can be obtained from the client configuration in KeyCloak.

#### Configuring a KeyCloak client for use with StackState

In order to connect StackState to KeyCloak, you need to add a new client configuration to the KeyCloak Authentication Server. The necessary settings for the client are:

1. **Client ID** - This is the ID of the client that is connecting, we recommend naming this `stackstate`
2. **Client Protocol** - Set this to `openid-connect`
3. **Access Type** - Set this to `confidential`, so that a secret is used to establish the connection between KeyCloak and StackState
4. **Standard Flow Enabled** - This should be `Enabled`
5. **Implicit Flow Enabled** - This should be `Disabled`
6. **Root URL** - This should point to the root location of StackState
7. **Valid redirect URIs** - This shoud be `/loginCallback/*`
8. **Base URL** - This should point to the root location of StackState

## REST API authentication

If you use StackState's REST API directly \(as opposed to via the GUI\) you can also enable authentication. The REST API supports basic authentication for authenticating users. StackState authenticates the user against either the configuration file or LDAP server as described above.

```javascript
authentication {
      enabled  = true

      basicAuth = false

      ...


    }
```

1. **basicAuth** - turn on or off basic authentication for the StackState REST API. Turn this setting on if you use the REST API from external scripts that can not use the HTML form-based login.

