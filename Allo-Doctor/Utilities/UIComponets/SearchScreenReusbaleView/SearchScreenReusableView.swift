//
//  SearchScreenReusableView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/09/2024.
//

import Foundation
import UIKit
class SearchScreenReusableView:UIView{
    @IBOutlet weak var dropDownView: CustomDropDownList!
    @IBOutlet weak var backNavigation: UIButton!
    let dropDown = CustomDropDownList()
    var backNavButtonTapped = PassthroughSubject<Void, Never>()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 30.0)
    }
    
}
extension SearchScreenReusableView{
    private func commonInit() {

        // Set the image and title insets to simulate image padding

        guard let xibView = Bundle.main.loadNibNamed("SearchScreenReusableView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        xibView.frame = self.bounds
        addSubview(xibView)
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let imagePadding: CGFloat = 5.0
        backNavigation.imageEdgeInsets = UIEdgeInsets(top: 0, left: -imagePadding, bottom: 0, right: imagePadding)
        backNavigation.titleEdgeInsets = UIEdgeInsets(top: 0, left: imagePadding, bottom: 0, right: -imagePadding)
        backNavigation.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        dropDown.frame = CGRect(x: 20, y: 100, width: 300, height: 30)
        dropDown.items = ["Cairo, Al-Maadi", "Giza", "Alexandria", "Luxor", "Aswan"]
        
        // Handle the selected item
        dropDown.didSelectItem = { selectedItem in
            print("User selected: \(selectedItem)")
        }
        
        // Add the dropdown view to the main view
        self.dropDownView.addSubview(dropDown)

    }

}
