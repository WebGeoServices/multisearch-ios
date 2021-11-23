//
//  Constants.swift
//  Multisearch
//
//  Created by apple on 05/05/21.
//

import UIKit

internal class Constants {
    static let URLWoosMap = "api.woosmap.com"
    static let URLGoogleMap = "maps.googleapis.com"
    static let URLLocalitiesAPI = "/localities/autocomplete/"
    static let URLLocalitiesDetailAPI = "/localities/details/"
    static let URLAddressAPI = "/address/autocomplete/json"
    static let URLAddressDetailAPI = "/address/details/json"
    static let URLStoreAPI = "/stores/autocomplete/"
    static let URLStoreDetailAPI = "/stores/search/"
    static let URLPlacesAPI = "/maps/api/place/autocomplete/json"
    static let URLPlacesDetailAPI = "/maps/api/place/details/json"

    static let formatNotMatching = "Format is not matching"
    static let invalidRequest = "invalid request"
    static let statusFailed = "Status failed!"
    static let apiFailed = "API Failed"
    static let noInternet = "No Internet"
    static let missingErrorInfo = "Missing Error information"
    static let badRequest = "Bad Request"
    static let unableToProcessErrorRequest = "Unable to process error request"
    static let failedGooglePlacesRequest = "Unable to process google places request at this time"
    static let failedLocalitiesRequest = "Unable to process localities request at this time"
    static let failedAddressRequest = "Unable to process address request at this time"
    static let failedStoreRequest = "Unable to process store request at this time"

}
