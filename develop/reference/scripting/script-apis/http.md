---
title: Script API - Http
kind: Documentation
description: Functions to execute http requests.
---

# Script API: Http

Sometimes it may be useful to process the retrieved topology or telemetry data using an external tool. For example, to perform analysis using a custom Python script, a cloud service or an Machine Learning framework. StackState can call out to any external service via HTTP using the functions in this script API.

## Function: `get`

Submit HTTP get request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](time.md) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header

**Return type:**

* Async: HttpScriptApiTextResponse or HttpScriptApiJsonResponse if `.jsonResponse()` is used.

Example:

```text
Http.get("http://localhost:8080/api/service")
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
* `.contentType(contentType: String)` -  specify the content type \(e.g. "application/text"\).
* `.textRequest(text: String)` - specify the text of the request.
* `.jsonRequest(json: Goovy.lang.Closures)` - specify the json of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder)
* `.jsonBody()` - get the body of the json response.
* `.jsonResponse()`  - get the json response.
* `.textResponse()`  - get the text response.

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```text
Http.put("http://localhost:8080/api/service")
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
* `.contentType(contentType: String)` -  specify the content type \(e.g. "application/text"\).
* `.textRequest(text: String)` - specify the text of the request.
* `.jsonRequest(json: Goovy.lang.Closures)` - specify the json of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder)
* `.jsonBody()` - get the body of the json response.
* `.jsonResponse()`  - get the json response.
* `.textResponse()`  - get the text response.

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```text
Http.post("http://localhost:8080/api/service")
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
* `.header(name: String, value: String)` - specify the header

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```text
Http.delete("http://localhost:8080/api/service")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```

## Function: `options`

Submit HTTP options request.

```text
Http.options("http://localhost:8080/api/service")
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
* `.contentType(contentType: String)` -  specify the content type \(e.g. "application/text"\).
* `.textRequest(text: String)` - specify the text of the request.
* `.jsonRequest(json: Goovy.lang.Closures)` - specify the json of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder)
* `.jsonBody()` - get the body of the json response.
* `.jsonResponse()`  - get the json response.
* `.textResponse()`  - get the text response.

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```text
Http.patch("http://localhost:8080/api/service")
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
* `.header(name: String, value: String)` - specify the header

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```text
Http.head("http://localhost:8080/api/service")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```

