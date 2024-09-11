//
//  Custombutton.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 04/09/2024.
//

import UIKit
enum Languages {
    case english
    case arabic
}
final class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

      
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }

}
extension CustomButton {
    func setupButton(color:UIColor,font:UIFont.TextStyle,title:String,borderColor:UIColor,textColor:UIColor) {
        setTitle(title, for:.normal )
        setTitleColor(textColor, for: .normal)
        backgroundColor      = color
        layer.cornerRadius   = Dimensions.borderRaduis.rawValue
        layer.borderWidth    = Dimensions.borderWidth.rawValue
        layer.borderColor    = borderColor.cgColor
            }

    
}
extension CustomButton {
    func configureImage(for language:Languages) {
        let image = UIImage.tickSquare
        setImage(image, for: .normal)
        
        switch language {
        case .english:
            contentHorizontalAlignment = .right
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
            
        case .arabic:
            contentHorizontalAlignment = .left
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
           
        }
    }
}

