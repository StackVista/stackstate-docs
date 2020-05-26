---
title: Script API - Http
kind: Documentation
---

Sometimes it may be useful to process the retrieved topology or telemetry data using an external tool, for example, to perform analysis using a custom python script or an ML library. This can be accomplished by deploying the external tool as a microservice with a REST API and have StackState interface with it using the Analytics environment.

StackState can use the standard HTTP operations:

* `get`

* `put`

* `post`

* `delete`

* `options`

* `head`

* `patch`

### Function: `get`

Submit HTTP get request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](/develop/scripting/time) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header

**Return type:**

* Async: HttpScriptApiTextResponse or HttpScriptApiJsonResponse if `.jsonResponse()` is used.

Example:

```
Http.get("http://localhost:8080/api/service")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```
### Function: `put`

Submit HTTP put request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](/develop/scripting/time) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.
*  `.contentType(contentType: String)` -  specify the content type (e.g. "application/text").
*  `.textRequest(text: String)` - specify the text of the request.
*  `.jsonRequest(json: Goovy.lang.Closures)` - specify the json of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder)
*  `.jsonBody()` - get the body of the json response.
*  `.jsonResponse()`  - get the json response.
*  `.textResponse()`  - get the text response.


**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```
Http.put("http://localhost:8080/api/service")
  .timeout("30s")
  .param("name", "value")
  .header("name", "value")
  .contentType("application/text")
  .textRequest("{'property', 'value'}")
  .jsonResponse()
```

### Function: `post`

Submit HTTP post request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](/develop/scripting/time) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.
*  `.contentType(contentType: String)` -  specify the content type (e.g. "application/text").
*  `.textRequest(text: String)` - specify the text of the request.
*  `.jsonRequest(json: Goovy.lang.Closures)` - specify the json of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder)
*  `.jsonBody()` - get the body of the json response.
*  `.jsonResponse()`  - get the json response.
*  `.textResponse()`  - get the text response.


**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```
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

### Function: `delete`

Submit HTTP delete request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](/develop/scripting/time) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```
Http.delete("http://localhost:8080/api/service")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```
### Function: `options`

Submit HTTP options request.

```
Http.options("http://localhost:8080/api/service")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```

### Function: `patch`

Submit HTTP patch request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](/develop/scripting/time) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header.
*  `.contentType(contentType: String)` -  specify the content type (e.g. "application/text").
*  `.textRequest(text: String)` - specify the text of the request.
*  `.jsonRequest(json: Goovy.lang.Closures)` - specify the json of the request. This will wrap the given closure with a [JsonBuilder](http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html#_jsonbuilder)
*  `.jsonBody()` - get the body of the json response.
*  `.jsonResponse()`  - get the json response.
*  `.textResponse()`  - get the text response.


**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:

```
Http.patch("http://localhost:8080/api/service")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
    .textRequest("{'property', 'value'}")
```

### Function: `head`

Submit HTTP head request.

**Args:**

* `uri` - uri of the HTTP server.

**Builder methods:**

* `.timeout(time: Duration)` - make the request timeout after [time](/develop/scripting/time) has elapsed.
* `.param(name: String, value: String)` - specify the query.
* `.header(name: String, value: String)` - specify the header

**Return type:**

* `AsyncScriptResult[HttpScriptApiTextResponse]` or `AsyncScriptResult[HttpScriptApiJsonResponse]` if `.jsonResponse()` is used.

Example:


```
Http.head("http://localhost:8080/api/service")
    .timeout("30s")
    .param("name", "value")
    .header("name", "value")
```
