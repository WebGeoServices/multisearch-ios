# Configuring Address Provider

A provider is a wrapper around a Woosmap API or a Google API which will be called to return the result for a query or get details of a place. Each provider must be created from a provider configuration and this provider must then be passed to `MultiSearch` object by calling `MultiSearch.addProvider` method.

To create a configuration for Address provider use

```swift
let addressProvider = ProviderConfig(searchType: .address,
                                             key: woosmapKey)
```

### Required Parameters
Certain parameters are required to create a address provider configuration. 

**type**: Type of the provider. Passed as `SearchProviderType` enum. In this case type will be `SearchProviderType.address`

---

**key**: Your project’s private key. This key identifies your Woosmap Project for purposes of quota management.

### Optional Parameters

**minInputLength**: Minimum input length of the search string. Empty result will be sent by the API and no callback will be triggered if the input length does not reach the minInputLength value. If no value is specified, library will ignore minimum input length and call the API starting from first character of the search string. 

---

**fallbackBreakpoint**: Float value (between 0 and 1): When the suggestion score is lower than the fallbackBreakpoint value set, the library will stop calling the corresponding provider and switch to the next one (depending on the provider order). <br/>Default value for Address provider is `0.5`

---

**ignoreFallbackBreakpoint**: When value is set to true, library will ignore `fallbackBreakpoint` for the given provider and will continue to provide a suggestion.

---

**component**: A grouping of places to which you would like to restrict your results. Currently, you can use components to filter over countries. Countries must be passed as a two character, [ISO 3166-1 Alpha-2 compatible country code.](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes) Component can be added to configuration builder using following code:

```swift
    let regionComponent:Component = Components(country: ["fr","gb"],
                                               language: "fr")
    
```

---

**language**: The language code, indicating in which language the results should be returned, if possible. Searches are also biased to the selected language; results in the selected language may be given a higher ranking. If language is not supplied, the address service will use the default language of each country. No language necessary for `postal_code` request.

