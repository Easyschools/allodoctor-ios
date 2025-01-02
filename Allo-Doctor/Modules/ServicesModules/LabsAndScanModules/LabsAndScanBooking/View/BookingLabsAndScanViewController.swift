//
//  BookingLabsAndScanViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/10/2024.
//

import UIKit

class BookingLabsAndScanViewController: BaseViewController<BookingLabsAndScanViewModel> {
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var adressTextfield: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewDidLayoutSubviews() {
        setupUIViewController()
    }
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
        
    }
    

    @IBAction func bookingConfirmationAction(_ sender: Any) {
        viewModel.createBooking()
    }
    

}
extension BookingLabsAndScanViewController{
    private func setupUIViewController(){
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: Dimensions.upperViewBorderRaduis.rawValue)
    }
}
