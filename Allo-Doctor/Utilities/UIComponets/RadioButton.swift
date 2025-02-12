//
//  RadioButton.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/09/2024.
//

import UIKit

class RadioButton: UIButton {

    // MARK: - Properties
    var isSelectedState: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    // Colors for selected and unselected states
    private let selectedColor: UIColor = .appColor
    private let unselectedColor: UIColor = .lightGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Setup
    private func setupButton() {
        self.layer.cornerRadius = frame.size.width / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = unselectedColor.cgColor
        self.backgroundColor = .clear
        updateUI()  // Initial UI setup
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        isSelectedState.toggle()
    }
    
    private func updateUI() {
        if isSelectedState {
            self.layer.borderColor = selectedColor.cgColor
            self.backgroundColor = .appColor  // Blue color inside
        } else {
            self.layer.borderColor = unselectedColor.cgColor
            self.backgroundColor = .clear  // Empty inside
        }
    }
}
