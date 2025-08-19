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
//    func setupCell(message:String,messageType:messageType){
//            self.message.text = message
//            if messageType == .reciver {
//                self.message.textAlignment = .right
//                self.contentView.backgroundColor = .greishWhiteF2F2F2
//                self.message.textColor = .black
//            }
//            else {
//                self.message.textAlignment = .left
//                self.contentView.backgroundColor =  .appColor
//                self.message.textColor = .white
//            }
//        }
    
    func setupCell(message:String?,attachment: String?,messageType:messageType){
        self.message.text = message

        print("dataUrl isssssss: \(attachment ?? "not found photo")")

        if message != nil {
            contentView.isHidden = false

            imagView.isHidden = true
            self.message.isHidden = false
        }
        else if let url = URL(string: attachment ?? "https://allodoctor-backend.developnetwork.net/storage/attachments/HgZPKyl3BnmllMBJ6YuexjBqXUahwH13dWsY9Nj0.png" ) {
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
            if let url = URL(string: attachment ?? "https://allodoctor-backend.developnetwork.net/storage/attachments/HgZPKyl3BnmllMBJ6YuexjBqXUahwH13dWsY9Nj0.png") {
                // self.message.isEnabled = false
                imagView.kf.setImage(with: url)
            }

            // text
            self.message.textAlignment = .right
            self.contentView.backgroundColor = .greishWhiteF2F2F2
            self.message.textColor = .black
        }
        else {
            if let url = URL(string: attachment ?? "https://allodoctor-backend.developnetwork.net/storage/attachments/HgZPKyl3BnmllMBJ6YuexjBqXUahwH13dWsY9Nj0.png") {
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
