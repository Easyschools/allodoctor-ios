//
//  EmergencyView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/09/2024.
//

import UIKit
class EmergencyView:UIView{
    @IBOutlet weak var emergencyButton: UnderlinedButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let xibView = Bundle.main.loadNibNamed("EmergencyView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        xibView.frame = self.bounds
        addSubview(xibView)
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    }
}
