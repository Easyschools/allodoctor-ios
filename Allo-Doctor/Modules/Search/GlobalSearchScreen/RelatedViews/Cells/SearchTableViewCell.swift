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
    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
