//
//  SearchScreenTableViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/11/2024.
//

import UIKit

class SearchScreenTableViewCell: UITableViewCell {

    @IBOutlet weak private var dataLabel: CairoMeduim!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.applyDropShadow()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
    }
    func setup(withLabelName text: String) {
           dataLabel.text = text
       }
}

