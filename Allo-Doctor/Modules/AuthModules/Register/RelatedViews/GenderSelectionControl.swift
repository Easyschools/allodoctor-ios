//
//  SelectGenderView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/09/2024.
//

import UIKit

class GenderSelectionControl: UIView {
    enum Gender: String {
        case male = "Male"
        case female = "Female"
    }
    
    private let maleButton: UIButton
    private let femaleButton: UIButton
    
    var selectedGender: Gender = .male {
        didSet {
            updateButtonStates()
        }
    }
    
    var onGenderSelected: ((Gender) -> Void)?
    
    // For programmatic initialization
    override init(frame: CGRect) {
        maleButton = UIButton(type: .custom)
        femaleButton = UIButton(type: .custom)
        
        super.init(frame: frame)
        
        setupButtons()
        setupLayout()
    }
    
    // This initializer is for using the control in a storyboard/XIB
    required init?(coder: NSCoder) {
        maleButton = UIButton(type: .custom)
        femaleButton = UIButton(type: .custom)
        
        super.init(coder: coder)
        
        setupButtons()
        setupLayout()
    }
    
    // Setting up buttons with padding and spacing
    private func setupButtons() {
        maleButton.setTitle(Gender.male.rawValue, for: .normal)
        femaleButton.setTitle(Gender.female.rawValue, for: .normal)
        
        // Adding image and adjusting padding for both buttons
        [maleButton, femaleButton].forEach { button in
            button.setTitleColor(.gray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setImage(imageForState(selected: false), for: .normal) // Initial unselected image
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5) // Padding between image and label
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0) // Padding from the left
            button.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        }
        
        updateButtonStates()
    }
    
    private func setupLayout() {
        addSubview(maleButton)
        addSubview(femaleButton)
        
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            maleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            maleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            femaleButton.leadingAnchor.constraint(equalTo: maleButton.trailingAnchor, constant: 20),
            femaleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            femaleButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
    }
    
    private func updateButtonStates() {
        // Update images and colors based on selection
        let isMaleSelected = selectedGender == .male
        maleButton.setImage(imageForState(selected: isMaleSelected), for: .normal)
        femaleButton.setImage(imageForState(selected: !isMaleSelected), for: .normal)
        
        // Change text color for selected and unselected states
        maleButton.setTitleColor(isMaleSelected ? .black : .black, for: .normal)
        femaleButton.setTitleColor(isMaleSelected ? .black : .black, for: .normal)
        
        // Set the unselected button to grey
        maleButton.tintColor = isMaleSelected ? .black : .black
        femaleButton.tintColor = isMaleSelected ? .black : .black
    }
    
    // Helper function to generate image for selected and unselected states
    private func imageForState(selected: Bool) -> UIImage {
        let size = CGSize(width: 30, height: 30)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            if selected{
                UIColor.greyA8A8A8.setStroke()
            }
            else{ UIColor.clear.setStroke()}
            context.cgContext.setLineWidth(2)
            context.cgContext.addEllipse(in: rect.insetBy(dx: 1, dy: 1))
            context.cgContext.drawPath(using: .stroke)
            
            if selected {
             
                let insetRect = rect.insetBy(dx: 5.5, dy: 5.5) // Increased inset for smaller inner circle
                UIColor.darkBlue295DA8.setFill() // Selected fill color
                context.cgContext.fillEllipse(in: insetRect)
            } else {
                UIColor.lightGreyD9D9D9.setFill() // Unselected state fully gray inside
                context.cgContext.fillEllipse(in: rect.insetBy(dx: 2, dy: 2)) // Fill with gray for unselected
            }
        }
    }
    
    @objc private func genderButtonTapped(_ sender: UIButton) {
        selectedGender = sender == maleButton ? .male : .female
        onGenderSelected?(selectedGender)
    }
    
    // New function to return the selected gender
    func getSelectedGender() -> Gender {
        return selectedGender
    }
}
