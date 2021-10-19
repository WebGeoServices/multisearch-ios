# wgs-multisearch-ios

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
