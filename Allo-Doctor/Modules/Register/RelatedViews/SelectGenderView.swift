//
//  SelectGenderView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/09/2024.
//

import UIKit

class SelectGenderView: UIView {
    
    let maleRadioButton = RadioButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    let femaleRadioButton = RadioButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    private let maleLabel: UILabel = {
        let label = UILabel()
        label.text = "Male"
        return label
    }()
    
    private let femaleLabel: UILabel = {
        let label = UILabel()
        label.text = "Female"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Create horizontal stack view to contain radio buttons and labels
        let maleStackView = UIStackView(arrangedSubviews: [maleRadioButton, maleLabel])
        maleStackView.spacing = 8
        maleStackView.alignment = .center
        
        let femaleStackView = UIStackView(arrangedSubviews: [femaleRadioButton, femaleLabel])
        femaleStackView.spacing = 8
        femaleStackView.alignment = .center
        
        let containerStackView = UIStackView(arrangedSubviews: [maleStackView, femaleStackView])
        containerStackView.spacing = 32
        containerStackView.axis = .horizontal
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStackView)
        
        // Constraints for the container stack view
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Add action to each button to handle group selection
        maleRadioButton.addTarget(self, action: #selector(selectMale), for: .touchUpInside)
        femaleRadioButton.addTarget(self, action: #selector(selectFemale), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func selectMale() {
        maleRadioButton.isSelectedState = true
        femaleRadioButton.isSelectedState = false
    }
    
    @objc private func selectFemale() {
        maleRadioButton.isSelectedState = false
        femaleRadioButton.isSelectedState = true
    }
}
