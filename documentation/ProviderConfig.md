# ProviderConfig

Configuration for search provider
This stores possible information to call search/detail apis from Woosmap or Google

``` swift
public class ProviderConfig 
```

## Initializers

### `init(searchType:key:fallbackBreakpoint:minInputLength:param:)`

Created new provider configuration

``` swift
public init(searchType: SearchProviderType, key: String, fallbackBreakpoint: Double? = nil, minInputLength: Int? = nil, param: ConfigParam? = nil) 
```

#### Parameters

  - searchType: search type. Search api intent to call
  - key: Authentication key to be able to call the API.
  - fallbackBreakpoint: A number between 0 and 1 corresponding to the threashold of fallback. A value of 0 indicates that the results must contain at least one perfect match while 1 will match anything. If no value is specified, default values are applied for each API (1 for store, 0,4 for localities, 0,5 for address, 1 for places)
  - minInputLength: Empty result will be sent by the API and no fallback will be triggered if the input length does not reach the minInputLength value
  - param: Restriction on API call to minimize result in list

### `init(searchType:key:ignoreFallbackBreakpoint:minInputLength:param:)`

Created new provider configuration

``` swift
public init(searchType: SearchProviderType, key: String, ignoreFallbackBreakpoint: Bool, minInputLength: Int? = nil, param: ConfigParam? = nil) 
```

#### Parameters

  - searchType: search type. Search api intent to call
  - key: Key for search api
  - ignoreFallbackBreakpoint: In case of ignoreFallbackBreakpoint is true, it will add the result in *autocompleteMulti* routine without checking score of list items
  - minInputLength: This is a cap on search string. Any Search string length less than this will be ignored while calling *autocompleteXXX* routine
  - param: Restriction on API call to minimize result in list

### `init(searchType:key:)`

Created new provider configuration

``` swift
public init(searchType: SearchProviderType, key: String) 
```

#### Parameters

  - searchType: Search type. Search api intent to call
  - key: Key for search api
