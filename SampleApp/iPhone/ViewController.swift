//
//  ViewController.swift
//  SampleApp
//
//  Created by apple on 19/04/21.
//

import UIKit
import Multisearch
import MaterialComponents.MaterialSnackbar
import MaterialComponents.MDCFilledTextField

class ViewController: UIViewController {
    private let objSearch = MultiSearch.init(debounceTime: 100)
    private var _hasSearchError: Bool = false
    private var hasSearchError: Bool {
        get {
            return _hasSearchError
        }
        set {
            _hasSearchError = newValue
            if _hasSearchError {
                txtAutoComplete.setUnderlineColor(UIColor.red, for: .normal)
                txtAutoComplete.setUnderlineColor(UIColor.red, for: .editing)
            } else {
                txtAutoComplete.setUnderlineColor(UIColor.green, for: .normal)
                txtAutoComplete.setUnderlineColor(UIColor.green, for: .editing)
            }
        }
    }
    private var displayResult: [AutocompleteResponseItem] = []

    @IBOutlet weak var txtAutoComplete: MDCFilledTextField!
    @IBOutlet weak var tableSearch: UITableView!
    @IBOutlet weak var lableSearchResultFrom: UILabel!
    @IBOutlet weak var lableSearchInfo: UILabel!
    @IBOutlet weak var lableSpace: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtAutoComplete.label.text = "Enter your destination"
        txtAutoComplete.setFilledBackgroundColor(UIColor.white, for: .normal)
        hasSearchError = false
        initSearch()

    }
    override func viewDidLayoutSubviews() {

    }
    private func initSearch() {

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
                                                components: Components(country: ["FR"]), language: "it"))
        // Order for calling multisearch api
        objSearch.addProvider(config: localitiesProvider)
        objSearch.addProvider(config: storeProvider)
        objSearch.addProvider(config: addressProvider)
        objSearch.addProvider(config: placesProvider)
    }

    private func showToast(message: String) {
        let action = MDCSnackbarMessageAction()
        let actionHandler = {() in
        }
        action.handler = actionHandler
        action.title = "CANCEL"
        let message = MDCSnackbarMessage(text: message)
        message.action = action
        MDCSnackbarManager.default.show(message)
    }
}

extension ViewController: UITextFieldDelegate {
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        hasSearchError = false
        lableSpace.isHidden = false
        lableSearchResultFrom.isHidden = true
        lableSearchInfo.isHidden = false
        tableSearch.isHidden = true
        return false
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let searchingfor = text.replacingCharacters(in: textRange,
                                                        with: string)
            if searchingfor == "" { // Reload result fast
                textField.text = ""
            }
            objSearch.autocompleteMulti(input: searchingfor) { (result, error) in
                if let callingError = error {
                    self.hasSearchError = true
                    self.showToast(message: callingError.localizedDescription ?? "" )
                    self.displayResult.removeAll()
                    self.tableSearch.reloadData()
                } else {
                    if let result = result {
                        self.displayResult = result
                        self.lableSearchResultFrom.text = "From  \(self.displayResult.first?.api.rawValue ?? "-")"
                        self.tableSearch.reloadData()
                    }
                    self.hasSearchError = false
                }
            }

        }
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayResult.count == 0 {
            lableSpace.isHidden = false
            if  txtAutoComplete.text != "" {
                lableSearchResultFrom.isHidden = false
                lableSearchInfo.isHidden = true
            } else {
                lableSearchResultFrom.isHidden = true
                lableSearchInfo.isHidden = false
            }
            lableSearchResultFrom.text = "No result"
            tableView.isHidden = true
        } else {
            lableSearchInfo.isHidden = true
            tableView.isHidden = false
            lableSearchResultFrom.isHidden = false
            lableSpace.isHidden = true
        }
        return displayResult.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier) as! SearchCell
        cell.design(locationInfo: displayResult[indexPath.row], selected: true)
        cell.delegate = self
        return cell
    }
}

extension ViewController: SearchCellDelegate {
    func didTapMap(cell: SearchCell) {
        self.view.endEditing(true)
        if let indexPath = tableSearch.indexPath(for: cell) {
            let selectedMap = displayResult[indexPath.row]
            if let id = selectedMap.id {
                objSearch.details(id: id, provider: selectedMap.api) { (result, error) in
                    if let callingError = error {
                        self.showToast(message: callingError.localizedDescription ?? "" )
                    } else {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        if let mapViewController = storyBoard.instantiateViewController(withIdentifier: "ID_MAP") as? MapViewController {
                            mapViewController.detailsResponseItem = result
                            self.navigationController?.pushViewController(mapViewController, animated: true)
                        }

                    }
                }
            }

        }
    }
}
