//
//  ChatWithUsView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/09/2024.
//

import UIKit
class ChatWithUsView:UIView{
    @IBOutlet weak var chatwthUsButton: UnderlinedButton!
    var onChatWithUsButtonTapped: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    @IBAction func chatWithUsAction(_ sender: Any) {
        onChatWithUsButtonTapped?()
    }
    private func commonInit() {
        guard let xibView = Bundle.main.loadNibNamed("ChatWithUsView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        xibView.frame = self.bounds
        addSubview(xibView)
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    }
}
