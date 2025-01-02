//
//  PharmacyOrderViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/11/2024.
//

import UIKit
class PharmacyOrderViewController: BaseViewController<PharmacyOrderViewModel> {
    @IBOutlet weak var orderSummaryView: UIView!
    @IBOutlet weak var navigationBackButton: CustomNavigationBackButton!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var adressView: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        adressView.applyDropShadow()
        orderSummaryView.applyDropShadow()
        paymentView.applyDropShadow()
        couponView.applyDropShadow()  
        navigationBackButton.tintColor = .black
        navigationBackButton.setTitleColor(.black, for: .normal)
        viewModel.createOrder()
    }
      
    override func setupUI() {
       
    }
   
    @IBAction func selectAdressViewAction(_ sender: Any) {
        let viewModel = UserAdressSelectViewModel()
        let contentViewController = UserAdressSelectViewController(viewModel: viewModel)
        contentViewController.dismissalSubject
            .sink { [weak self] in
                self?.viewModel.coordinator?.showMapView(screenType: .userAddress)

            }
            .store(in: &cancellables)
        let sheetController = FWIPNSheetViewController(controller: contentViewController, sizes: [.percent(0.5)])
  
        // Present the sheet
        present(sheetController, animated: true, completion: nil)
    }
    @IBAction func navigateBackAction(_ sender: Any) {
    }
    
    @IBAction func confirmOrderAction(_ sender: Any) {
//        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
   
        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.proceedActionPublisher
                   .sink { [weak self] _ in
  
                       self?.dismiss(animated: true)
                       
                   }
                   .store(in: &cancellables)
               // Add it to the view controller's view
         view.addSubview(confirmationView)
    }
}
