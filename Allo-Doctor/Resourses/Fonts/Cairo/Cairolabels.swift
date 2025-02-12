//
//  Cairolabels.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/09/2024.
//

import Foundation
import UIKit

@IBDesignable
class CairoBold: UILabel {
    
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
        self.font = UIFont(name: "Cairo-Bold", size: fontSize)
    }
    
}
class CairoMeduim: UILabel {
    
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
        self.font = UIFont(name: "Cairo-Medium", size: fontSize)
        self.numberOfLines = 0
    }
    
}
class CairoRegular: UILabel {
    
    @IBInspectable var fontSize: CGFloat = 12 {
        didSet {
            updateView()
            self.numberOfLines = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
        self.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
        
    }
    private func updateView() {
        self.font = UIFont(name: "Cairo-Regular", size: fontSize)
       
    }
    
}


class CairoLight: UILabel {
    
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
        self.font = UIFont(name: "Cairo-Light", size: fontSize)
    }
    
}
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
        self.font = UIFont(name: "Cairo-SemiBold", size: fontSize)
        self.numberOfLines = 0
    }
    
}
