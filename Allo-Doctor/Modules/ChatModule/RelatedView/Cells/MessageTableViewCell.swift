//
//  MessageTableViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/01/2025.
//

import UIKit
enum messageType{
    case sender
    case reciver
}
class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.applyDropShadow()
      
    }
    
    
}
extension MessageTableViewCell{
    func setupCell(message:String,messageType:messageType){
        self.message.text = message
        if messageType == .reciver {
            self.backgroundColor = .white
            self.message.textColor = .black
        }
        else {
            self.backgroundColor = .appColor
            self.message.textColor = .white
        }
    }
}
