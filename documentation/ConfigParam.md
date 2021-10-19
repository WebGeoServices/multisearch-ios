# ConfigParam

API configuration structure
This class helps to collect all query parameter required for api calls to fine tune results

``` swift
public class ConfigParam: Codable 
```

## Inheritance

`Codable`

## Initializers

### `init(components:)`

Creating ConfigParam with component

``` swift
public init(components: Components) 
```

#### Parameters

  - components: components

### `init(components:types:)`

Creating ConfigParam with components, types

``` swift
public init(components: Components, types: [String]) 
```

#### Parameters

  - components: component query
  - types: types query

### `init(components:types:language:query:data:extended:)`

Creating ConfigParam with components, types, tags, language

``` swift
public init(components: Components? = nil, types: [String]? = nil, language: String? = nil, query: String? = nil, data: DataFormat? = nil, extended: String? = nil  ) 
```

#### Parameters

  - components: component query
  - types: types query
  - tags: tags query
  - language: language query
