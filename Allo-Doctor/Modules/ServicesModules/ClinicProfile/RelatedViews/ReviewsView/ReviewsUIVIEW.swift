//
//  ReviewsUIVIEW.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/10/2024.
//

import UIKit
class ReviewsUIView:UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
   
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
      
        
    }
    private func commonInit(){
        self.addXibSubview(named: ClinicProfileViews.reviewsView.rawValue)

    }
}
