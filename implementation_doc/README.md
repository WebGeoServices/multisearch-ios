# Woosmap MultiSearch iOS Framework
Smart search of multiple places and addresses APIs
### Overview
---
Woosmap MultiSearch iOS is a native framework designed to return location suggestions by calling several autocomplete services. This library makes location searches more efficient and cost-effective by allowing you to easily combine Woosmap Localities API, Woosmap Address API, Woosmap Search API (stores) and Google Places APIs (Places Autocomplete and Places Details).

> **No Interface Provided**
>
> This library does not provide any user interface but focuses on querying autocomplete services. However, it is quite easy to display results on your own.

### How are autocomplete services combined?
---
Autocomplete services are requested in your desired order. Most often, only the first service will be queried. In some cases, for instance when searching for street addresses, Woosmap Localities can be insufficient.

By comparing the user input to the returned results and computing a string matching score between these two values, the library can automatically switch to the next autocomplete service and thereby provide suggestions that better suits the needs.

### Installation
---
You can install the SDK in four different ways.

> **Note**
> 
> We recommend installing the SDK via [Swift Package Manager](https://swift.org/package-manager/).

### Swift Package Manager

To integrate Woosmap Geofencing SDK into your project using [Swift Package Manager](https://swift.org/package-manager/),
you can add the library as a dependency in Xcode (11 and above) –
see [adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)
on Apple documentation. The package repository URL is:

```
https://github.com/Woosmap/multisearch-ios
```

### CocoaPods

Install [CocoaPods](https://cocoapods.org), a dependency manager for Cocoa projects. If you don't have an existing Podfile, run pod init in your project directory. Add the following to your Podfile:
 For usage and installation instructions, visit their website. To integrate Woosmap Geofencing SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
pod 'Multisearch', :git => 'https://github.com/Woosmap/multisearch-ios'
```

### Importing the Framework manually

1. Unzip MultiSearch-\<version\>.zip.
2. Import the MultiSearch.framework folder into your Xcode project.

> **Note**
> 
> If Xcode has not automatically added the correct path(s), add a project-relative path to your framework.

### The `MultiSearch` Object

---

The class that represents the wrapper to autocomplete services.

When instantiating the `Multisearch`  object, you need, at least, to specify your desired autocomplete services’ API keys and the order in which these services will be called:

### Specify `debounceTime`
---
Debounce time is the  amount of time in miliseconds the autocomplete function will wait after the last received call before executing it. If 0 is specified then autocomplete function will not wait for the execution call.

Create `MultiSearch` object
```swift
    import Multisearch
    private let objSearch = MultiSearch.init(debounceTime: 100)
```

Create `ProviderConfig` objects and add provider to `MultiSearch` object.

```swift
   let localitiesProvider = ProviderConfig(searchType: .localities,
                                            key: <<woosmap_private_key>>)

    let addressProvider = ProviderConfig(searchType: .address,
                                         key: <<woosmap_private_key>>)

    let storeProvider = ProviderConfig(searchType: .store,
                                       key: <<woosmap_private_key>>)

    let placesProvider = ProviderConfig(searchType: .places,
                                        key: <<google_api_web_key>>)

    // Order for calling multisearch api
    objSearch.addProvider(config: localitiesProvider)
    objSearch.addProvider(config: storeProvider)
    objSearch.addProvider(config: addressProvider)
    objSearch.addProvider(config: placesProvider)
```

### Setting up callback
---

`MultiSearch` routine returns the autocomplete and details results using block function. This block returns expected results or a Woosmap error.

- **`SearchCompletionHandler`**: This callback will be invoked once MultiSearch finishes any of it's autocomplete methods. This block has two parameters:<br/>
**1)** List of `AutocompleteResponseItem` objects. Value will be null if any exception has occurred.<br/>
**2)** `WoosmapException` exception object. Will be null if there was no exception during the execution.<br/>

- **`DetailCompletionHandler`**: This callback will be invoked once MultiSearch finishes any of it's details methods.This block has two parameters:<br/>
**1)** `DetailsResponseItem` object. Value will be null if any exception has occurred.<br/>
**2)** `WoosmapException` exception object. Will be null if there was no exception during the execution.


### Retrieve suggestions
---

You can retrieve suggestions from the user input by calling the `autocompleteMulti` method:

```swift
  objSearch.autocompleteMulti(input: "paris") { (results, error) in

    }
```

### Get Details
---

Finally, to get the suggestion details when a user selects one from the pick list, call the `details` method. This method accepts two parameters:<br/>

- **`id`**: id of the item retrieved from `autocompleteXXXX` method.
- **`apiType`**: Underlying API type which will be called to fetch the details. Accepts enum of `SearchProviderType` type.

```swift
objSearch.details(id: "UGFyaXMsIMOObGUtZGUtRnJhbmNlLCBGcmFuY2U=", provider: .store) { (locationinfo, error) in

        }
```

### Configure the Woosmap MultiSearch
---
The library requires to set a `key` for each available API in your MultiSearch implementation, whether it’s a Woosmap API or for Google Places API.

> Please refer to the [documentation](https://developers.woosmap.com/support/api-keys/) to get an API Key if necessary.


### API options
---
Additionally, for each provider configuration you can apply the same optional parameters as defined in the corresponding provider documentation.

- [Address Provider](/implementation_doc/address_config.md)
- [Store Provider](/implementation_doc/store_config.md)
- [Localities Provider](/implementation_doc/localities_config.md)
- [Places Provider](/implementation_doc/places_config.md)

Set the optional parameters for the providers
```swift
   let localitiesProvider = ProviderConfig(searchType: .localities,
                                            key: woosmapKey,
                                            minInputLength: 1,
                                            param: ConfigParam(
                                                components: Components(country: ["FR"]),
                                                types: ["locality", "country", "postal_code"]))

    let addressProvider = ProviderConfig(searchType: .address,
                                         key: woosmapKey,
                                         fallbackBreakpoint: 0.8,
                                         minInputLength: 1,
                                         param: ConfigParam(
                                            components: Components(country: ["FR"]),
                                                                    language: "fr"))

    let storeProvider = ProviderConfig(searchType: .store,
                                       key: woosmapKey,
                                       ignoreFallbackBreakpoint: true,
                                       minInputLength: 1)

    let placesProvider = ProviderConfig(searchType: .places,
                                        key: googleApiKey,
                                        fallbackBreakpoint: 0.7,
                                        minInputLength: 1,
                                        param: ConfigParam(
                                            components: Components(country: ["FR"]), 
                                                                  language: "it"))

    // Order for calling multisearch api
    objSearch.addProvider(config: localitiesProvider)
    objSearch.addProvider(config: storeProvider)
    objSearch.addProvider(config: addressProvider)
    objSearch.addProvider(config: placesProvider)
```

APIs will be called based on the order in which they were provided to `MultiSearch` object. In above code snippet following will be the order of the APIs:<br/>
`LOCALITIES` &#8594; `STORE` &#8594; `ADDRESS` &#8594; `PLACES`

### Fallback configuration
---
Fallback system enables to switch from one provider to another. This system is flexible and can be manually adjusted for each provider in order to be efficient for each of your specific use cases.

Three parameters have an impact on the fallback:

**minInputLength**: Autocomplete service will return an empty result and no fallback will be triggered until the input length reaches the `minInputLength` value.

**fallbackBreakpoint**: Float value (between 0 and 1): When the suggestion score is lower than the `fallbackBreakpoint` value set, the library will stop calling the corresponding provider and switch to the next one (depending on the provider order).

A default value is defined for each provider:

| Provider | Default Value |
| ------ | ------ |
| `SearchProviderType.LOCALITIES` | `0.4` |
| `SearchProviderType.STORE` | `1` |
| `SearchProviderType.ADDRESS` | `0.5` |
| `SearchProviderType.PLACES` | `1` |

**ignoreFallbackBreakpoint**: When value is set to true, library will ignore `fallbackBreakpoint` for the given provider and will continue to provide a suggestion.

### How is the score calculated?
---
The score could be considered as a [Levenshtein Distance](https://en.wikipedia.org/wiki/Levenshtein_distance) between those two strings: the input from the user and the value (`description`) of a returned autocomplete item. We use the fuzzy searching JavaScript library [Fuse.js](https://fusejs.io/).

Generally speaking, fuzzy searching (formerly known as approximate string matching) is the technique of finding strings that are approximately equal to a given pattern (rather than exactly).

Have a look at the [Fuse.js scoring explanation](https://fusejs.io/concepts/scoring-theory.html) for more details.

---

### [API Reference](../documentation/Home.md)
