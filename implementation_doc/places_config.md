# Configuring Places Provider

A provider is a wrapper around a Woosmap API or a Google API which will be called to return the result for a query or get details of a place. Each provider must be created from a provider configuration and this provider must then be passed to `MultiSearch` object by calling `MultiSearch.addProvider` method.

To create a configuration for Places provider use

```swift
let placesProvider = ProviderConfig(searchType: .places,
                                            key: googleApiKey)
```

### Required Parameters
Certain parameters are required to create a Localities provider configuration. 

**type**: Type of the provider. Passed as `SearchProviderType` enum. In this case type will be `SearchProviderType.places`

---

**key**: Your Google Maps web project’s key. 

### Optional Parameters

**minInputLength**: Minimum input length of the search string. Empty result will be sent by the API and no callback will be triggered if the input length does not reach the minInputLength value. If no value is specified, library will ignore minimum input length and call the API starting from first character of the search string. 

---

**fallbackBreakpoint**: Float value (between 0 and 1): When the suggestion score is lower than the fallbackBreakpoint value set, the library will stop calling the corresponding provider and switch to the next one (depending on the provider order). <br/>Default value for Places provider is `1`

---

**ignoreFallbackBreakpoint**: When value is set to true, library will ignore `fallbackBreakpoint` for the given provider and will continue to provide a suggestion.

---

**searchType**: You may restrict results from a Place Autocomplete request to be of a certain type by passing a `types` parameter. The parameter specifies a type or a type collection, as listed in the supported types below. If nothing is specified, all types are returned. Multiple types can be passed using the "," as a separator.

```swift
let placesProvider = ProviderConfig(searchType: .places,
                                            key: googleApiKey,
                                            param: ConfigParam(types:["locality","postal_code","country"]))
   
```
---

**component**: A grouping of places to which you would like to restrict your results. Currently, you can use components to filter over countries. Countries must be passed as a two character, [ISO 3166-1 Alpha-2 compatible country code.](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes) Component can be added to configuration builder using following code:

```swift
let placesProvider = ProviderConfig(searchType: .places,
                                            key: googleApiKey,
                                            param: ConfigParam(
                                                components: Components(country: ["fr"])))
    
```

---

**language**: The language code, indicating in which language the results should be returned, if possible. Searches are also biased to the selected language; results in the selected language may be given a higher ranking. If language is not supplied, the Places service will use the default language of each country. No language necessary for `postal_code` request. You can specify the language to the provider configuration by: 

```swift
let placesProvider = ProviderConfig(searchType: .places,
                                            key: googleApiKey,
                                            param: ConfigParam(
                                                language: "fr"))
```

Check [Google Places API Documentation](https://developers.google.com/maps/documentation/places/web-service/autocomplete?hl=id#place_autocomplete_requests) for more details.

