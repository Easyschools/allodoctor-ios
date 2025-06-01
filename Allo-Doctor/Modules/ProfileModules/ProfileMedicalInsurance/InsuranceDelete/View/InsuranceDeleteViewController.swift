//
//  InsuranceDeleteViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 07/01/2025.
//

import UIKit
import Kingfisher
class InsuranceDeleteViewController: BaseViewController<InsuranceDeleteViewModel> {

    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var insuranceDescription: UILabel!
    @IBOutlet weak var insuranceName: UILabel!
    @IBOutlet weak var insuranceImage: CircularImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func bindViewModel() {
        bindData()
    }

    @IBAction func deleteButton(_ sender: Any) {
        viewModel.deleteInsurance()
    }
    @IBAction func navBackButton(_ sender: Any) {
        viewModel.navBack()
    }
    override func viewDidLayoutSubviews() {
        upperView.roundCorners([.bottomLeft,.bottomRight], radius: 25)
    }
    private func bindData(){
        viewModel.$userInsurance
                   .receive(on: DispatchQueue.main)
                   .sink { [weak self] insurance in
                       self?.setupUIView()
                   }.store(in: &cancellables)
        viewModel.$deleteState
                   .receive(on: DispatchQueue.main)
                   .sink { [weak self] status in
                       guard let status = status else { return }
                       switch status {
                       case .success:
                           self?.handleSucessViews()
                       case .failure:
                           AlertManager.showAlert(on: self!, title: AppLocalizedKeys.error.localized, message:  AppLocalizedKeys.somethingHappen.localized)
                       }
                   }.store(in: &cancellables)
           }
    
    
}
extension InsuranceDeleteViewController{
  func setupUIView(){
      let insuranceData = viewModel.userInsurance
      insuranceDescription.text = insuranceData?.email
      if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
          insuranceName.text = insuranceData?.nameAr
      }
      else{
          insuranceName.text = insuranceData?.nameEn}
      if let imageUrlString = insuranceData?.mainImage,
         let imageUrl = URL(string: imageUrlString) {
          insuranceImage.kf.setImage(
              with: imageUrl,
              placeholder: UIImage(named: "placeholder"), // Replace with your placeholder image name
              options: [.transition(.fade(0.2))] // Optional: Adds a fade effect while loading
          )
      } else {
          insuranceImage.image = UIImage(named: "placeholder") // Fallback image
      }
  }
}
extension InsuranceDeleteViewController{
    private func handleSucessViews(){
        
        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.setupView(message: AppLocalizedKeys.deletedSuccessfully.localized, description:  AppLocalizedKeys.insurancedeletedSuccessfully.localized)
        confirmationView.proceedActionPublisher
                   .sink { [weak self] _ in
                       self?.viewModel.navBack()
                   }
                   .store(in: &cancellables)
               // Add it to the view controller's view
         view.addSubview(confirmationView)
    }
    }

