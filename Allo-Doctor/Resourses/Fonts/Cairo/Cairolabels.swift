//
//  Cairolabels.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/09/2024.
//

import Foundation
import UIKit

@IBDesignable
class CairoSemiBold: UILabel {
    
    @IBInspectable var fontSize: CGFloat = 12 {
        didSet {
            updateView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    private func updateView() {
        // Use the fontSize property instead of hardcoding the size
        self.font = UIFont(name: "Cairo-SemiBold", size: fontSize)
    }
}
