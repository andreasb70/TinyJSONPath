# TinyJSONPath

TinyJSONPath is a tiny, pragmatic implementation of JSONPath-like access to a JSON object.

*It is no full implementation of the official JSONPath specification!*

However, it offers enough functionality for the most common use-cases when reading small JSON files.

TinyJSONPath is written in Swift 4 and the included XCode project was compiled using XCode 10.1 running on a macOS 10.14 machine.

## Usage

Initialize a TinyJSONPath object with a Data object containing valis JSON:

```
let jsonPath = TinyJSONPath(json: json)
```

Check the status of the parsing:

```
if jsonPath.isValid {
    // Do something
} else {
    // Something's wrong...
    print("JSON parsing failed: \(jsonPath.lastError ?? "")")
}
```

Access the JSON properies using the path syntax:

```
if let res = jsonPath.evalPath(path: "store.book.*.author") {
   print(res)
}
```

## Path Syntax

The path syntax is using the usual dot-notation, e.g.

Example
```
{
  "address": {
     "name": "John"
  }
}
```

`address.name` will access the property "name" in the object "address" and therefore returns "John".

### Arrays

TinyJSONPath allows to access all or specific array elements:

- '*': Delivers all array elements
- '[1]': Delivers array element at index 1
- '[3,5,9]: Delivers the array elements at indices 3, 5 and 9

Example
```
{
  "animals": [
     { "name": "dog" },
     { "name": "cat" },
     { "name": "fish" }
  ]
}
```

- `animals.*.name` returns an array ["dog", "cat", "fish"]
- `animals.[0].name` returns *"dog"*
- `animals.[0,2].name` returns an array ["dog", "fish"]

### Special operators

- `@count` returns the number of elements in an array or the number of properies in a object
- `@keys` returns all keys (properties) in a object

Example
```
{
  "animals": [
     { "name": "dog", "legs": 4 },
     { "name": "cat", "legs": 4 },
     { "name": "fish", "legs": 0 }
  ]
}
```

- `animals.@count` returns 3
- `animals.[0].@keys` returns an array ["name", "legs"]
- `animals.[0].@count` returns 2
