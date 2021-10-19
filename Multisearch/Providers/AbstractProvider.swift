//
//  AbstractProvider.swift
//  Multisearch
//
//  Created by apple on 24/04/21.
//

import UIKit

protocol AbstractProvider {
    init(_ config: ProviderConfig)
    typealias ProviderHandler = (_ userResponse: [AutocompleteResponseItem]?, _ error: APIClient.Error?) -> Void

    func getQueryParam() -> [URLQueryItem]

    func search(_ input: String, completionBlock: @escaping (_ userResponse: [AutocompleteResponseItem]?, _ error: APIClient.Error?) -> Void)

    func details( _ placeid: String, completionBlock: @escaping (_ userResponse: DetailsResponseItem?, _ error: APIClient.Error?) -> Void)
}
