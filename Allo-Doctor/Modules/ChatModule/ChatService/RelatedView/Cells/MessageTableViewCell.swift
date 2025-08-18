//
//  MessageTableViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/01/2025.
//

import UIKit
import Kingfisher

enum messageType{
    case sender
    case reciver
}
class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var stackVw: UIStackView!
    @IBOutlet weak var message: UILabel!

    @IBOutlet weak var imagView: UIImageView!

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
    func setupCell(message:String,dataUrl: String,messageType:messageType,chadId: String){
        self.message.text = message

        print("dataUrl isssssss: \(dataUrl),  chadId: \(chadId)")

        if message != "" {
            contentView.isHidden = false

            imagView.isHidden = true
            self.message.isHidden = false
        }
        else if let url = URL(string: dataUrl) {
            // self.message.isEnabled = false
            contentView.isHidden = false

            imagView.kf.setImage(with: url)

            self.message.isHidden = true
            imagView.isHidden = false


        }else{
            contentView.isHidden = true
            imagView.isHidden = true
            self.message.isHidden = true

        }

        if messageType == .reciver {

            // text
            self.message.textAlignment = .right
            self.contentView.backgroundColor = .greishWhiteF2F2F2
            self.message.textColor = .black
        }
        else {
            if let url = URL(string: dataUrl) {
                // self.message.isEnabled = false
                imagView.kf.setImage(with: url)
            }
            // text
            self.message.textAlignment = .left
            self.contentView.backgroundColor = .appColor
            self.message.textColor = .white
        }

    }
}
