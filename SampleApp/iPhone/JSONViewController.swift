//
//  JSONViewController.swift
//  SampleApp
//
//  Created by apple on 20/05/21.
//

import UIKit
import Multisearch

class JSONViewController: UIViewController {
    @IBOutlet weak var textViewJson: UITextView!
    var  detailsResponseItem: DetailsResponseItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let detailsResponseItem = detailsResponseItem {
            textViewJson.text = detailsResponseItem.description
            textViewJson.scrollRangeToVisible(NSRange(location: 0, length: 0))
        }
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
