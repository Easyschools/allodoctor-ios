//
//  OperationProcedureViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/11/2024.
//

import UIKit

class OperationProcedureViewController: BaseViewController<OperationProcedureViewModel> {
    
    @IBOutlet weak var descriptionConstraint: NSLayoutConstraint!
    @IBOutlet weak var estimatedDuration: CairoRegular!
    @IBOutlet weak var stayDuration: UILabel!
    @IBOutlet weak var operationDescription: UITextView!
    @IBOutlet weak var operationName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
    }
    
    private func setupTextView() {
        // Configure the text view
        operationDescription.isScrollEnabled = false
        operationDescription.textContainer.lineFragmentPadding = 0
        operationDescription.textContainerInset = .zero
    }
    
    @IBAction func continueAction(_ sender: Any) {
        viewModel.navToHome()
    }
    
    override func bindViewModel() {
        viewModel.getOperationProcedure()
        bindoperationProcedure()
    }
    
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    
    private func bindoperationProcedure() {
        viewModel.$operationProcedure
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setupUIView()
            }.store(in: &cancellables)
    }
    
    private func setupUIView() {
        let data = viewModel.operationProcedure
        
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
            stayDuration.text = data?.estimatedDurationAr ?? "غير متوفر"
            estimatedDuration.text = data?.estimatedDurationAr ?? "غير متوفر"
            operationName.text = data?.operation?.nameAr
            operationDescription.text = data?.descriptionAr ?? "غير متوفر"
        } else {
            stayDuration.text = data?.expectedHospitalStayEn ?? "Not Available"
            estimatedDuration.text = data?.estimatedDurationEn ?? "Not Available"
            operationName.text = data?.operation?.nameEn
            operationDescription.text = data?.descriptionEn ?? "Not Available"
        }
        
        // Update the height constraint after setting the text
        updateDescriptionHeight()
    }
    
    private func updateDescriptionHeight() {
        // Calculate the size needed for the text
        let size = operationDescription.sizeThatFits(CGSize(width: operationDescription.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        // Update the height constraint
        descriptionConstraint.constant = size.height
        
        // Force layout update
        view.layoutIfNeeded()
    }
}
