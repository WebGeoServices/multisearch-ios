# AutocompleteResponseItem

Formatted search result in this class structure

``` swift
public class AutocompleteResponseItem 
```

## Properties

### `score`

Score calculated from scoring routine. If scoring routine is not called, score will return null value

``` swift
public var score: Double?
```

### `description`

Contains the human-readable name for the returned result

``` swift
public let description: String
```

### `api`

Type:​ 'localities'|'address'|'store'|'places'
The api the result was retrieved from

``` swift
public let api: SearchProviderType
```

### `input`

Location info in key:​value format

``` swift
public let input: [String: Any]
```

### `jsonStructure`

Structure of data in JSON String format

``` swift
public var jsonStructure: String? 
```

### `id`

Data Identifier

``` swift
public var id: String? 
```

### `types`

Array of types that apply to this item.

``` swift
public var types: [String]? 
```

### `matchedSubstrings`

Contains an array with offset value and length. These describe the location of the entered term in the prediction result text, so that the term can be highlighted if desired.

``` swift
public var matchedSubstrings: [NSRange]? 
```

### `highlight`

HTML description in which the entered term in the prediction result text are in \<mark\>\</mark\> tags

``` swift
public var highlight: String 
```
