//
//  HospitalProfileView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 26/12/2024.
//

import UIKit
import Combine

class HospitalProfileView: UIView {
    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var hospitalAdress: UITextView!
    @IBOutlet weak var dynamicContentHeight: NSLayoutConstraint!
    @IBOutlet weak var aboutHospital: UITextView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let nibName = String(describing: type(of: self))
        guard let nibView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else {
            fatalError("Failed to load \(nibName) from nib.")
        }
        nibView.frame = self.bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(nibView)
    }

    // Bind the hospital data to update the view
    func bindData(to publisher: AnyPublisher<OneDayCareHospitals?, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hospitalData in
                guard let self = self, let hospitalData = hospitalData else { return }
                self.updateUI(with: hospitalData)
            }
            .store(in: &cancellables)
    }

    private func updateUI(with hospitalData: OneDayCareHospitals) {
        // Update the UI with the hospital data
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
          
            aboutHospital.text = hospitalData.descriptionAr
        }
        else{
        
            aboutHospital.text = hospitalData.descriptionEn
        }
        hospitalAdress.text = hospitalData.address
        // Configure other UI elements like collection view, etc.
    }
}
