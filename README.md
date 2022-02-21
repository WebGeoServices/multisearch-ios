## Install SDK

You can install the SDK in four different ways.

{:.info}
We recommend installing the SDK via [Swift Package Manager](https://swift.org/package-manager/).

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

{:.info}
If Xcode has not automatically added the correct path(s), add a project-relative path to your framework.


## wgs-multisearch-ios

Uses:

Initialize the library
``` swift
      let objMultiSearchLib = MultiSearch(debounceTime: 0)
      let localitiesProvider = ProviderConfig(searchType: .localities,
                                                    key: "woos-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx",
                                                    fallbackBreakpoint: 0.7,
                                                    minInputLength: 1,
                                                    param: ConfigParam(
                                                        components: Components(country: ["FR"]),
                                                                            types: ["locality","country", "postal_code"]))
        
        let addressProvider = ProviderConfig(searchType: .address,
                                                    key: "woos-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx",
                                                    fallbackBreakpoint: 0.8,
                                                    minInputLength: 1,
                                                    param: ConfigParam(
                                                        components: Components(country: ["FR"],
                                                                                    language: "fr")))
        
        
        let storeProvider = ProviderConfig(searchType: .store,
                                                    key: "woos-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx",
                                                    fallbackBreakpoint: 0)
        
        let placesProvider = ProviderConfig(searchType: .places,
                                                    key: "<<google places key>>",
                                                    fallbackBreakpoint: 0.7,
                                                    minInputLength: 1,
                                                    param: ConfigParam(
                                                        components: Components(country: ["FR"])))
                                        
        //Order for calling multisearch api
        objMultiSearchLib.addProvider(config: storeProvider)
        objMultiSearchLib.addProvider(config: localitiesProvider)
        objMultiSearchLib.addProvider(config: addressProvider)
        objMultiSearchLib.addProvider(config: placesProvider)
```

Getting List result
``` swift
        //Sample 1
        objMultiSearchLib.autocompleteMulti(input: "paris") { (result, error) in
            
        }
        
        //Sample 2
        objMultiSearchLib.autocompleteAddress(input: "paris") { (result, error) in
        
        }
        
        //Sample 3
        objMultiSearchLib.autocompleteLocalities(input: "paris") { (result, error) in
        
        }
        
        //Sample 4
        objMultiSearchLib.autocompleteStore(input: "paris") { (result, error) in
        
        }
        
        //Sample 5
        objMultiSearchLib.autocompletePlaces(input: "paris") { (result, error) in
        
        }
```

Getting Detail result
``` swift
      //get Detail
        let autoComplete = AutoComplete()
        objSearch.details(id: "UGFyaXMsIMOObGUtZGUtRnJhbmNlLCBGcmFuY2U=", provider: .store) { (locationinfo, error) in
            
        }
```
