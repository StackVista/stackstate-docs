---
title: Id Extraction
kind: Documentation
---

Id extraction is used in the synchronization process to turn external data into External Topology. It extracts the unique identity and identifiers for components. With the external data being send, the Id Extractor can produce the following information:

- a `type` - for the component/relation for differentiation in later steps
- an `externalId` - is the identifier with which the element is easily identifiable in the external source
- `identifiers` (multiple) - a set of identifiers that identify the object internally in StackState.

![Id extractor](/images/guides/concepts/idextractor.png)

Below you can find an Id Extractor function:

```
map = struct.asReadonlyMap()

externalId = map["externalId"]
type = map["typeName"].toLowerCase()
identifiers = map["data"].get("identifiers", [])

return Sts.createId(externalId, new HashSet([externalId] + identifiers), type)
```
