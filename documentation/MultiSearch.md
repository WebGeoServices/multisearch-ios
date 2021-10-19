# MultiSearch

Woosmap Search

``` swift
public class MultiSearch 
```

## Nested Type Aliases

### `SearchCompletionHandler`

``` swift
public typealias SearchCompletionHandler = (_ userResponse: [AutocompleteResponseItem]?,
                                                _ error: WoosmapError?) -> Void
```

### `DetailCompletionHandler`

``` swift
public typealias DetailCompletionHandler = (_ result: DetailsResponseItem?,
                                                _ error: WoosmapError?) -> Void
```

## Initializers

### `init(debounceTime:)`

Create an instance for Woosmap search

``` swift
public init (debounceTime: Int ) 
```

#### Parameters

  - debounceTime: Snooze time for repeated search

## Methods

### `addProvider(config:)`

Configure Api provider for search option

``` swift
public func addProvider(config: ProviderConfig) 
```

This helps you to add new provider for multisearch sequence

#### Code

``` 
    let placesProvider = ProviderConfig(searchType: .places,
            key: "XXXXXXXXXXXXXXXXXXXXX_-XXXXXXX",
            fallbackBreakpoint: 0.7,
            minInputLength: 1,
            param: ConfigParam(
            components: Components.init(country: ["FR"])))
    //Order for calling multisearch api
    objSearch.addProvider(config: placesProvider)
```

> 

#### Parameters

  - config: configuration rules for each provider. Your result will be base of rules you

#### Throws

Does not throw any error

### `removeProvider(provider:)`

Remove specified provider from Multisearch

``` swift
public func removeProvider(provider: SearchProviderType) 
```

In case the specified provider is not configured with Multisearch, this function will do nothing.

#### Parameters

  - provider: Provider to be removed.

### `autocompleteMulti(input:completionBlock:)`

Searching  location address  in multiple available provider configure with multisearch

``` swift
public func autocompleteMulti(input: String,
                                  completionBlock: @escaping(SearchCompletionHandler)) 
```

Function return list of Locality info for given search string

#### Code

``` 
    objSearch.autocompleteMulti(input: "st") { (result, error) in
        if let callingError = error {
            print("failed to execute api \( callingError.localizedDescription ?? "-")")
        } else {
            print("fetching result")
            print(result?.count ?? 0)
            result?.forEach({ (item) in
            print("===============")
            print(item.api)
            print(item.id ?? "")
            print(item.types ?? "")
            print(item.matched_substrings ?? "")
            print(item.description )
            print(item.score ?? 0 )
            print("===============")
        })
    }
}
```

#### Parameters

  - input: String to be searched
  - completionBlock: Callback function to return search result list or Error code

#### Throws

  - Configuration missing
  - Api provider failed

#### Returns

Query the different autocomplete APIs defined in order in it added. Depending on the **fallbackBreakpoint** and the **minInputLength** defined for each API, if the first API does not send relevant enough results, it will query the next one, until results are relevant or no other API is in the list.

### `autocompleteAddress(input:completionBlock:)`

Search location info with Address provider

``` swift
public func autocompleteAddress(input: String, completionBlock: @escaping(SearchCompletionHandler)) 
```

Function return list of locality info for given search string

#### Code

``` 
    objSearch.autocompleteAddress(input: "st") { (result, error) in
        if let callingError = error {
            print("failed to execute api \( callingError.localizedDescription ?? "-")")
        } else {
            print("fetching result")
            print(result?.count ?? 0)
            result?.forEach({ (item) in
            print("===============")
            print(item.api)
            print(item.id ?? "")
            print(item.types ?? "")
            print(item.matched_substrings ?? "")
            print(item.description )
            print("===============")
        })
    }
}
```

#### Parameters

  - input: String to be searched
  - completionBlock: Callback function to return search results list or Error code

#### Throws

  - Error in case of missing configuration
  - Error in case of api failure

#### Returns

Internally calls Woosmap Address api and returns list of matching addresses

### `autocompleteLocalities(input:completionBlock:)`

Search location info with Localities provider

``` swift
public func autocompleteLocalities(
        input: String, completionBlock: @escaping(SearchCompletionHandler)) 
```

Function return list of localities info for given search string

#### Code

``` 
    objSearch.autocompleteLocalities(input: "st") { (result, error) in
        if let callingError = error {
            print("failed to execute api \( callingError.localizedDescription ?? "-")")
        } else {
            print("fetching result")
            print(result?.count ?? 0)
            result?.forEach({ (item) in
            print("===============")
            print(item.api)
            print(item.id ?? "")
            print(item.types ?? "")
            print(item.matched_substrings ?? "")
            print(item.description )
            print("===============")
        })
    }
}
```

#### Parameters

  - input: String to be searched
  - completionBlock: Callback function to return search result list or Error code

#### Throws

  - Error in case of missing configuration
  - Error in case of api failure

#### Returns

Search in Woosmap Localities api and return list of addresses

### `autocompletePlaces(input:completionBlock:)`

Search location info with Google Places provider

``` swift
public func autocompletePlaces(
        input: String, completionBlock: @escaping(SearchCompletionHandler)) 
```

Function returns a list of locality info for a given search string

#### Code

``` 
    objSearch.autocompletePlaces(input: "st") { (result, error) in
        if let callingError = error {
            print("failed to execute api \( callingError.localizedDescription ?? "-")")
        } else {
            print("fetching result")
            print(result?.count ?? 0)
            result?.forEach({ (item) in
            print("===============")
            print(item.api)
            print(item.id ?? "")
            print(item.types ?? "")
            print(item.matched_substrings ?? "")
            print(item.description )
            print("===============")
        })
    }
}
```

#### Parameters

  - input: String to be searched
  - completionBlock: Callback function to return search result list or Error code

#### Throws

  - Error in case of missing configuration
  - Error in case of api failure

#### Returns

Search in Google Places api and returns list of addresses

### `autocompleteStore(input:completionBlock:)`

Search location info with Store provider

``` swift
public func autocompleteStore(
        input: String, completionBlock: @escaping(SearchCompletionHandler)) 
```

Function return list of locality info for given search string

#### Code

``` 
    objSearch.autocompleteStore(input: "st") { (result, error) in
        if let callingError = error {
            print("failed to execute api \( callingError.localizedDescription ?? "-")")
        } else {
            print("fetching result")
            print(result?.count ?? 0)
            result?.forEach({ (item) in
            print("===============")
            print(item.api)
            print(item.id ?? "")
            print(item.types ?? "")
            print(item.matched_substrings ?? "")
            print(item.description )
            print("===============")
        })
    }
}
```

#### Parameters

  - input: String to be searched
  - completionBlock: Callback function to return search results list or Error code

#### Throws

  - Error in case of missing configuration
  - Error in case of api failure

#### Returns

Internally calls the Woosmap Store api and returns list of address

### `details(id:provider:completionBlock:)`

Query the details api to get details of an item.

``` swift
public func details(id: String,
                        provider: SearchProviderType,
                        completionBlock: @escaping(DetailCompletionHandler)) 
```

``` 
Query the details api to get details of an item.

- Parameter id: basic information for places
- Parameter provider: Looking api to call
- Parameter completionBlock: Return search result or Error code
- Returns: Return information of given places or error code in case the function fails.
- throws: Error In case of missing configuration
```

Function return Locality info for given placeid

#### Code

``` 
    objSearch.details(input: "s", provider:.place) { (result, error) in
        if let callingError = error {
            print("failed to execute api \( callingError.localizedDescription ?? "-")")
        } else {
            print("fetching result")
            print("===============")
            print(result.api)
            print(result.id ?? "")
            print(result.types ?? "")
            print(result.matched_substrings ?? "")
            print(result.description )
            print("===============")
    }
}
```

#### Parameters

  - id: basic information for places
  - provider: look for api to be called
  - completionBlock: Callback function to return Address info or Error code

#### Throws

  - Error in case of missing configuration
  - Error in case of api failure

#### Returns

Search in Woosmap Store api and return list of address
