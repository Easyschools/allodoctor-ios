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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
    }
 
    
    
}
extension MessageTableViewCell{
    func setupCell(message:String,messageType:messageType){
        self.message.text = message
        if messageType == .reciver {
            self.message.textAlignment = .right
            self.contentView.backgroundColor = .greishWhiteF2F2F2
            self.message.textColor = .black
        }
        else {
            self.message.textAlignment = .left
            self.contentView.backgroundColor =  .appColor
            self.message.textColor = .white
        }
    }
}
