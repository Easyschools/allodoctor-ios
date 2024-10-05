//
//  LabsAndScanProfileViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 25/09/2024.
//

import UIKit
import Kingfisher
class LabsAndScanProfileViewController: UIViewController {
    let coordintor = HomeCoordinator?.self
    @IBOutlet weak var searchForTestView: SearchView!
    @IBOutlet weak var upperView: CustomCornerRaduis!
    
    @IBOutlet weak var insuranceDropList: CustomDropDownList!
    @IBOutlet weak var labOrScanImage: UIImageView!
    private var imageUrl: String
    private var screenType: String
    var arrinsurance = ["AXA", "MisrInsurance", "Good liFE Insurance"]
    
    @IBAction func navBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Initializers
    init(imageUrl: String, screenType: String) {
        self.imageUrl = imageUrl
        self.screenType = screenType
      
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.imageUrl = ""  // Provide a default value
        self.screenType = ""
        super.init(coder: aDecoder)
    }
 
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the image using Kingfisher
        labOrScanImage.kf.setImage(with: URL(string: imageUrl))
        
        // Set placeholder text for the search text field
        searchForTestView.searchTextfield.placeholder = "Search for Lab test"
        
        // Configure the insurance drop-down list
        insuranceDropList.setDropdownHeight(200)
        insuranceDropList.items = arrinsurance
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
        setupShadow()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupShadow()
    }

}

// MARK: - Shadow Setup
extension LabsAndScanProfileViewController {
    func setupShadow() {
        // Ensure the view has a non-transparent background color
        upperView.backgroundColor = UIColor.white
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 30)
        upperView.applyDropShadow()

       
    }
}

 

