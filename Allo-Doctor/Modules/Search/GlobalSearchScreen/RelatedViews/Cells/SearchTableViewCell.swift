//
//  SearchTableViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/09/2024.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchedItemType: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.applyDropShadow()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16))
    }
    
   
    
}
