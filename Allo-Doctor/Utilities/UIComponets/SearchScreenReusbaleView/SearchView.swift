//
//  SearchView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 19/09/2024.
//

import UIKit
class SearchView: UIView {
    
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let xibView = Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        xibView.frame = self.bounds
        addSubview(xibView)
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        searchButton.setTitle("", for: .normal)
        searchTextfield.addPadding(By: 16, for: .left)

      

    }
    
   }
