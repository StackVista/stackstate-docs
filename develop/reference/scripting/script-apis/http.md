---
description: StackState Self-hosted v5.1.x 
---

# HTTP - script API

Sometimes it may be useful to process the retrieved topology or telemetry data using an external tool. For example, to perform analysis using a custom Python script, a cloud service or a Machine Learning framework. StackState can call out to any external service via HTTP using the functions in this script API.

{% hint style="info" %}
To execute scripts using the HTTP script API in the StackState UI analytics environment, a user must have the permission `execute-restricted-scripts`. For details, see the [analytics page permissions](../../../../configure/security/rbac/rbac_permissions.md#analytics-page-permissions).
{% endhint %}

## Function: `HTTP.get(uri: String)`

Submit HTTP get request.

### Args

* `uri` - uri of the HTTP server.

### Builder methods

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.

### Return type

* Async: HttpScriptApiTextResponse or HttpScriptApiJsonResponse if `.jsonResponse()` is used.

### Examples

```text
Http.get("https://www.google.com/?q=apples")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```

## Function: `HTTP.put(uri: String)`

Submit HTTP put request.

### Args

* `uri` - uri of the HTTP server.

### Builder methods

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.
* `.contentType(contentType: String)` -  specify the content type, for example "application/text".
* `.textRequest(text: String)` - specify the text of the request.
* `.jsonRequest(json: Goovy.lang.Closures)` - specify the JSON of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder).
* `.jsonBody()` - get the body of the JSON response.
* `.jsonResponse()`  - get the JSON response.

### Return type

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

### Examples

```text
Http.put("http://http_server:8080/api")
  .timeout("30s")
  .param("name", "value")
  .header("name", "value")
  .contentType("application/text")
  .textRequest("{'property', 'value'}")
  .jsonResponse()
```

## Function: `HTTP.post(uri: String)`

Submit HTTP post request.

### Args

* `uri` - uri of the HTTP server.

### Builder methods

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.
* `.contentType(contentType: String)` -  specify the content type, for example "application/text".
* `.textRequest(text: String)` - specify the text of the request.
* `.jsonRequest(json: Goovy.lang.Closures)` - specify the JSON of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder).
* `.jsonBody()` - get the body of the JSON response.
* `.jsonResponse()` - get the JSON response.

### Return type

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

### Examples

```text
Http.post("http://http_server:8080/api")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
    .jsonRequest {
    basicProperty "value"
    objectProperty {
    basicProperty 42.0
    }
    listProperty (["list item"])
}.jsonBody()
```

## Function: `HTTP.delete(uri: String)`

Submit HTTP delete request.

### Args

* `uri` - uri of the HTTP server.

### Builder methods

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.

### Return type

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

### Examples

```text
Http.delete("http://http_server:8080/api")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```

## Function: `HTTP.options(uri: String)`

Submit HTTP options request.

### Args

* `uri` - uri of the HTTP server.

### Examples

```text
Http.options("http://http_server:8080/api")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```

## Function: `HTTP.patch(uri: String)`

Submit HTTP patch request.

### Args

* `uri` - uri of the HTTP server.

### Builder methods

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.
* `.contentType(contentType: String)` -  specify the content type, for example "application/text".
* `.textRequest(text: String)` - specify the text of the request.
* `.jsonRequest(json: Goovy.lang.Closures)` - specify the JSON of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder).
* `.jsonBody()` - get the body of the JSON response.
* `.jsonResponse()`  - get the JSON response.

### Return type

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

### Examples

```text
Http.patch("http://http_server:8080/api")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
    .textRequest("{'property', 'value'}")
```

## Function: `HTTP.head(uri: String)`

Submit HTTP head request.

### Args

* `uri` - uri of the HTTP server.

### Builder methods

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.

### Return type

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

### Examples

```text
Http.head("http://http_server:8080/api")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```

