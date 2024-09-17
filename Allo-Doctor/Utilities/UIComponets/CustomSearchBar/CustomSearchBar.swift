//
//  CustomSearchBar.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 15/09/2024.
//

import UIKit
import Combine
class CustomSearchBar: UIView {
    @IBOutlet weak var navButton: UIButton!
    @IBAction func searchAction(_ sender: Any) {
        
    }
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    var navButtonTapped = PassthroughSubject<Void, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let xibView = Bundle.main.loadNibNamed("CustomSearchBar", owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        xibView.frame = self.bounds
        addSubview(xibView)
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        searchButton.setTitle("", for: .normal)
        searchTextfield.addPadding(By: 16, for: .left)

        // Ensure button is visible and tappable
        navButton.removeTarget(nil, action: nil, for: .allEvents)
        navButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    }
    
    @objc func buttonTapped() {
        navButtonTapped.send()
    }}
