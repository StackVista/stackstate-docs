---
description: Functions to execute http requests.
---

# HTTP - script API

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

Sometimes it may be useful to process the retrieved topology or telemetry data using an external tool. For example, to perform analysis using a custom Python script, a cloud service or an Machine Learning framework. StackState can call out to any external service via HTTP using the functions in this script API.

## Function: `get`

Submit HTTP get request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.

**Return type:**

* Async: HttpScriptApiTextResponse or HttpScriptApiJsonResponse if `.jsonResponse()` is used.

Example:

```text
Http.get("https://www.google.com/?q=apples")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```

## Function: `put`

Submit HTTP put request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.
* `.contentType(contentType: String)` -  specify the content type, for example "application/text".
* `.textRequest(text: String)` - specify the text of the request.
* `.jsonRequest(json: Goovy.lang.Closures)` - specify the JSON of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder).
* `.jsonBody()` - get the body of the JSON response.
* `.jsonResponse()`  - get the JSON response.

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```text
Http.put("http://http_server:8080/api")
  .timeout("30s")
  .param("name", "value")
  .header("name", "value")
  .contentType("application/text")
  .textRequest("{'property', 'value'}")
  .jsonResponse()
```

## Function: `post`

Submit HTTP post request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.
* `.contentType(contentType: String)` -  specify the content type, for example "application/text".
* `.textRequest(text: String)` - specify the text of the request.
* `.jsonRequest(json: Goovy.lang.Closures)` - specify the JSON of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder).
* `.jsonBody()` - get the body of the JSON response.
* `.jsonResponse()` - get the JSON response.

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

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

## Function: `delete`

Submit HTTP delete request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```text
Http.delete("http://http_server:8080/api")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```

## Function: `options`

Submit HTTP options request.

```text
Http.options("http://http_server:8080/api")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```

## Function: `patch`

Submit HTTP patch request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.
* `.contentType(contentType: String)` -  specify the content type, for example "application/text".
* `.textRequest(text: String)` - specify the text of the request.
* `.jsonRequest(json: Goovy.lang.Closures)` - specify the JSON of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder).
* `.jsonBody()` - get the body of the JSON response.
* `.jsonResponse()`  - get the JSON response.

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```text
Http.patch("http://http_server:8080/api")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
    .textRequest("{'property', 'value'}")
```

## Function: `head`

Submit HTTP head request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```text
Http.head("http://http_server:8080/api")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```
