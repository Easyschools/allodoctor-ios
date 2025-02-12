//
//  OperationConfirmedViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/11/2024.
//

import UIKit

class OperationConfirmedViewController: BaseViewController<OperationConfirmedViewModel> {
    @IBOutlet weak var upperView: UIView!
    
    @IBOutlet weak var hospitalNumber: CairoRegular!
    @IBOutlet weak var date: CairoRegular!
    @IBOutlet weak var hospitalAddress: CairoRegular!
    @IBOutlet weak var hospitalName: CairoBold!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func continueAction(_ sender: Any) {
        viewModel.showProcdure()
    }
    override func bindViewModel() {
       
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    override func setupUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
                self.hospitalName.text = self.viewModel.hospitalData.infoService?.nameAr
                self.hospitalAddress.text = self.viewModel.hospitalData.infoService?.address
            } else {
                self.hospitalName.text = self.viewModel.hospitalData.infoService?.nameEn
                self.hospitalAddress.text = self.viewModel.hospitalData.infoService?.address
            }
            
            self.hospitalNumber.text = "19777"
            self.date.text = self.viewModel.date.formatDateToMonth()
        }
        
        
    }
} 
