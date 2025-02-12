//
//  ConfirmationView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 12/11/2024.
//

import UIKit

class ConfirmationView: UIView {
    @IBOutlet weak private var messageLabel: CairoBold!
    @IBOutlet weak var proceedButton: CustomButton!
    @IBOutlet weak private var descriptionLabel: CairoRegular!
    var proceedActionPublisher = PassthroughSubject<Void, Never>()
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // Load the view from the XIB file
        guard let contentView = Bundle.main.loadNibNamed("ConfirmationView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        // Configure the content view's appearance
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add contentView as a subview
        addSubview(contentView)
        
        // Set the semi-transparent background
        messageLabel.text = AppLocalizedKeys.BookingConfirmed.localized
        descriptionLabel.text = AppLocalizedKeys.yourBookingHasBeenConfirmed.localized
        self.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    }
    @IBAction func proceedButtonAction(_ sender: Any) {
        proceedActionPublisher.send(())
    }
    func setupView(message:String,description:String){
        messageLabel.text = message
        descriptionLabel.text = description
    }
    func setupButton(message:String){
        proceedButton.setTitle(message, for:.normal)
    }
}
