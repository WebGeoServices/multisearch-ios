# DetailsResponseItem

Expose detail info for given location. This class has geometry information and properties of the given location

``` swift
public class DetailsResponseItem: NSObject 
```

## Inheritance

`NSObject`

## Properties

### `api`

Type of search provider Store | Localities | Address |  Places

``` swift
public let api: SearchProviderType
```

### `id`

Location’s id or suggestion’s id used to link the suggestion to the. Item identifier

``` swift
public let id: String
```

### `formattedAddress`

Complete address of the location.  String containing the human-readable address of this item

``` swift
public let formattedAddress: String
```

### `name`

Location’s name

``` swift
public let name: String
```

### `types`

List of location’s types .  Array of feature types describing the given item (like locality or postal\_town)

``` swift
public let types: [String]
```

### `item`

Item returned by the API “as is”.

``` swift
public let item: [String: Any]
```

### `jsonStructure`

Structure of data in JSON String format

``` swift
public var jsonStructure: String? 
```

### `geometry`

Data about the geographic coordinate

``` swift
public var geometry: GeometryDetail? 
```

Item geometry ({location:{lat, lng}})

### `addressComponents`

Location’s address divided in several components.

``` swift
public var addressComponents: [AddressComponent] 
```

### `description`

Json String format of class structure

``` swift
public override var description: String 
```
