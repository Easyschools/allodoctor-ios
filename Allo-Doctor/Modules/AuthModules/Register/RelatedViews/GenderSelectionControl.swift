//
//  SelectGenderView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/09/2024.
//
import UIKit

// MARK: - Gender Selection
class GenderSelectionControl: UIView {
    enum Gender: String {
        case male = "male"
        case female = "female"
    }
    
    private let maleButton: UIButton
    private let femaleButton: UIButton
    
    var selectedGender: Gender? {
        didSet {
            updateButtonStates()
        }
    }
    
    var onGenderSelected: ((Gender?) -> Void)?
    
    override init(frame: CGRect) {
        maleButton = UIButton(type: .custom)
        femaleButton = UIButton(type: .custom)
        super.init(frame: frame)
        setupButtons()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        maleButton = UIButton(type: .custom)
        femaleButton = UIButton(type: .custom)
        super.init(coder: coder)
        setupButtons()
        setupLayout()
    }
    
    private func setupButtons() {
        maleButton.setTitle(AppLocalizedKeys.male.localized, for: .normal)
        femaleButton.setTitle(AppLocalizedKeys.female.localized, for: .normal)
        
        [maleButton, femaleButton].forEach { button in
            let isRTL = UserDefaultsManager.sharedInstance.getLanguage() == .ar
            button.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
            if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: -8)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
            } else {
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
            }
            
            button.setTitleColor(.gray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setImage(imageForState(selected: false), for: .normal)
            button.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        }
        
        updateButtonStates()
    }
    
    private func setupLayout() {
        addSubview(maleButton)
        addSubview(femaleButton)
        
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        
        let isRTL = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        
        if isRTL {
            NSLayoutConstraint.activate([
                femaleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                femaleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                femaleButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                
                maleButton.leadingAnchor.constraint(equalTo: femaleButton.trailingAnchor, constant: 20),
                maleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                maleButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
                maleButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
            ])
        } else {
            NSLayoutConstraint.activate([
                maleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                maleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                maleButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                
                femaleButton.leadingAnchor.constraint(equalTo: maleButton.trailingAnchor, constant: 20),
                femaleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                femaleButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
                femaleButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
            ])
        }
    }
    
    private func updateButtonStates() {
        let isMaleSelected = selectedGender == .male
        let isFemaleSelected = selectedGender == .female
        
        maleButton.setImage(imageForState(selected: isMaleSelected), for: .normal)
        femaleButton.setImage(imageForState(selected: isFemaleSelected), for: .normal)
        
        maleButton.setTitleColor(isMaleSelected ? .appColor : .gray, for: .normal)
        femaleButton.setTitleColor(isFemaleSelected ? .appColor : .gray, for: .normal)
    }
    
    private func imageForState(selected: Bool) -> UIImage {
        let size = CGSize(width: 30, height: 30)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            context.cgContext.setLineWidth(2)
            context.cgContext.setStrokeColor(UIColor.appColor.cgColor)
            context.cgContext.addEllipse(in: rect.insetBy(dx: 1, dy: 1))
            context.cgContext.strokePath()
            
            if selected {
                context.cgContext.setFillColor(UIColor.appColor.cgColor)
                context.cgContext.fillEllipse(in: rect.insetBy(dx: 5, dy: 5))
            }
        }
    }
    
    @objc private func genderButtonTapped(_ sender: UIButton) {
        selectedGender = sender == maleButton ? .male : .female
        onGenderSelected?(selectedGender)
    }
    
    func getSelectedGender() -> Gender? {
        return selectedGender
    }
}
