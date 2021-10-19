//
//  DetailsResponseItem.swift
//  Multisearch
//
//  Created by apple on 28/04/21.
//

import UIKit
/// Expose detail info for given location. This class has geometry information and properties of the given location
public class DetailsResponseItem: NSObject {
    /// Type of search provider Store | Localities | Address |  Places
    public let api: SearchProviderType

    /// Location’s id or suggestion’s id used to link the suggestion to the. Item identifier
    public let id: String

    /// Complete address of the location.  String containing the human-readable address of this item
    public let formattedAddress: String

    /// Location’s name
    public let name: String

    /// List of location’s types .  Array of feature types describing the given item (like locality or postal_town)
    public let types: [String]

    /// Item returned by the API “as is”.
    public let item: [String: Any]

    /// Structure of data in JSON String format
    public var jsonStructure: String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }

    /// Data about the geographic coordinate
    ///
    /// Item geometry ({location:{lat, lng}})
    public var geometry: GeometryDetail? {
        if let match = item["geometry"] as? [String: Any] {
            if (match["location"] as? [String: Any]) != nil {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: match, options: .prettyPrinted)
                    let geometryDetail = try JSONDecoder().decode(GeometryDetail.self, from: jsonData)
                    return GeometryDetail(location: Location(lat: geometryDetail.location.lat, lng: geometryDetail.location.lng))

                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                // Handle GeoJson format
                if let coordinates =  match["coordinates"] as? [Double] {
                    return GeometryDetail(location: Location(lat: coordinates[1], lng: coordinates[0]))
                }
            }
        }
        return nil
    }
    /// Location’s address divided in several components.
    public var addressComponents: [AddressComponent] {
        let validAddressComponent =  [ "locality",
                                       "street_number",
                                       "country",
                                       "route",
                                       "postal_code",
                                       "postal_codes" ]
        var addresspart: [AddressComponent] = []
        var caputreAddressComponent: [[String: Any]]?
        if let addresscomponents = item["address_components"] as? [[String: Any]] {
            caputreAddressComponent = addresscomponents
        } else {
            if let properties = item["properties"] as? [String: Any] {
                if let addresscomponents = properties["address_components"] as? [[String: Any]] {
                    caputreAddressComponent = addresscomponents
                }
            }
        }
        if let addresscomponents = caputreAddressComponent {
            addresscomponents.forEach { components in
                var shortName: [String] = []
                var longName: [String] = []
                var types: [String] = []
                if let componentTypes = components["types"] as? [String] {
                    types = componentTypes
                    types.indices.forEach {
                        if types[$0] == "postal_codes"{
                            types[$0] = "postal_code"
                        }
                    }
                }
                var isValidType = false
                types.forEach { tempType in
                    if isValidType == false {
                        if validAddressComponent.firstIndex(where: { validType in
                            return validType == tempType
                        }) != nil {
                            isValidType = true
                        }
                    }
                }
                if isValidType {
                    if let name = components["short_name"] as? String {
                        shortName = [name]
                    }
                    if let names = components["short_name"] as? [String] {
                        shortName = names
                    }
                    if let name = components["long_name"] as? String {
                        longName = [name]
                    }
                    if let names = components["long_name"] as? [String] {
                        longName = names
                    }

                    addresspart.append(AddressComponent(shortName: shortName,
                                                        types: types,
                                                        longName: longName))
                }
            }
        }
        return addresspart
    }
    /// Initialization of DetailsResponseItem
    /// - Parameters:
    ///   - api: Api type
    ///   - id: Identifier
    ///   - formattedAddress: Address
    ///   - name: name of address
    ///   - types: Type of address
    ///   - input: Full content of address
    internal init(api: SearchProviderType,
                  id: String,
                  formattedAddress: String,
                  name: String,
                  types: [String],
                  input: [String: Any] ) {
        self.api = api
        self.id = id
        self.formattedAddress = formattedAddress
        self.name = name
        self.types = types
        self.item = input
    }
    /// Json String format of class structure
    public override var description: String {
        var format: [String: Any?] = [:]
        format["id"] = id
        do {
            let jsonData = try JSONEncoder().encode(addressComponents)
            format["addressComponents"] = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]
        } catch let error {
            print(error.localizedDescription)
        }
        do {
            let jsonData = try JSONEncoder().encode(geometry)
            format["geometry"] = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        } catch let error {
            print(error.localizedDescription)
        }
        format["formattedAddress"] = formattedAddress
        format["name"] = name
        format["types"] = types
        format["item"] = item
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: format, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch let error {
            print(error.localizedDescription)
        }
        return "unable to print description"
    }
}

/// Geometry Information of Location
public class GeometryDetail: Codable {
    /// Location Info in (lat,Lng)
    public let location: Location
    /*
    /// Type of location
    private let locationType: String?

    /// Area covered by location (northeast,southwest)
    private let viewport: Viewport?

    /// Coding keys for decoder/encoder
    enum CodingKeys: String, CodingKey {
        case locationType = "location_type"
        case location, viewport
    }

    /// Geometry Information of address
    /// - Parameters:
    ///   - locationType: Type of location
    ///   - location: Lat/Lng of location
    ///   - viewport: View bound of location
    init(locationType: String? = nil,
         location: Location,
         viewport: Viewport? = nil) {
        self.locationType = locationType
        self.location = location
        self.viewport = viewport
    }
     /// Type of location
     private let locationType: String?
     */
    /// Created new geomatry info object
    /// - Parameter location: Lat/Lng of location
    init(location: Location) {
        self.location = location
    }
}

// MARK: - Location

/// Location point on map
public class Location: Codable {

    /// Latitude of location
    public let lat: Double

    /// Longitude of location
    public let lng: Double

    init(lat: Double, lng: Double) {
        self.lat = lat.roundToDecimal(8)
        self.lng = lng.roundToDecimal(8)
    }
}

// MARK: - Viewport

/// Location area on map
public class Viewport: Codable {

    /// NorthEast Location on map
    public let northeast: Location

    /// SouthWest location on map
    public let southwest: Location

    init(northeast: Location, southwest: Location) {
        self.northeast = northeast
        self.southwest = southwest
    }
}

/// Address components of details
public class AddressComponent: Codable {

    /// Short name array
    public let shortName: [String]

    /// Types array
    public let types: [String]

    /// Long name array
    public let longName: [String]

    enum CodingKeys: String, CodingKey {
        case shortName
        case types
        case longName
    }

    /// Create new address component for details
    /// - Parameters:
    ///   - shortName: name array
    ///   - types: type array
    ///   - longName: name array
    init(shortName: [String], types: [String], longName: [String]) {
        self.shortName = shortName
        self.types = types
        self.longName = longName
    }
}
