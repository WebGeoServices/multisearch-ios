//
//  SearchCell.swift
//  SampleApp
//
//  Created by apple on 10/05/21.
//

import UIKit
import Multisearch
protocol SearchCellDelegate: AnyObject {
    func didTapMap(cell: SearchCell)
}

class SearchCell: UITableViewCell {
    @IBOutlet weak var lblResult: UILabel!
    static let identifier = "searchcell"
    weak var delegate: SearchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onTapMap(_ sender: UIButton) {
        self.contentView.backgroundColor = UIColor.white
        delegate?.didTapMap(cell: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func touchedDown(_ sender: UIButton) {
        self.contentView.backgroundColor = UIColor.gray

    }
    @IBAction func touchedCancel(_ sender: UIButton) {
        self.contentView.backgroundColor = UIColor.white
    }

    public func design(locationInfo: AutocompleteResponseItem, selected: Bool) {
        self.contentView.backgroundColor = UIColor.white
        lblResult.text = locationInfo.description
        let att = NSMutableAttributedString(string: locationInfo.description)

        locationInfo.matchedSubstrings?.forEach({ (item) in
            att.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: item)
        })
        lblResult.attributedText = att
    }

}
