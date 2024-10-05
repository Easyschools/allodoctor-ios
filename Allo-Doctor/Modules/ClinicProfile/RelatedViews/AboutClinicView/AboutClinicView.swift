//
//  AboutClinicView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit

class AboutClinicView: UIView {
    // MARK: - Private Outlets
    @IBOutlet weak var clinicDetails: CairoRegular!
    @IBOutlet weak private var clinicBranchesTableView: UITableView!
    @IBOutlet weak private var clinicSpecialityTableView: UITableView!
    @IBOutlet weak private var clinicBranchesDynamicString: NSLayoutConstraint!
    @IBOutlet weak private var clinicSpecialityDynamicString: NSLayoutConstraint!
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Setup Methods
    private func commonInit(){
        self.addXibSubview(named: "AboutClinicView")
        }
}
