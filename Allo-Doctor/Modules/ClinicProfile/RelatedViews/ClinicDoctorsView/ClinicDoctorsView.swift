//
//  ClinicDoctorsView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit


class ClinicDoctorsView: UIView {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    var doctorsPublisher: AnyPublisher<[ClinicDoctor], Never>?
    
    // You can add your UI components here
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        // Add your UI setup here
    }
    
    // MARK: - Data Binding
    func bindData() {
        doctorsPublisher?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] doctors in
                self?.updateUI(with: doctors)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with doctors: [ClinicDoctor]) {
        // Handle the received doctors data here
        // For now, we'll just print the number of doctors
        print("Received \(doctors.count) doctors")
        
        // You can update your UI components or perform any other operations with the doctors data here
    }
}
