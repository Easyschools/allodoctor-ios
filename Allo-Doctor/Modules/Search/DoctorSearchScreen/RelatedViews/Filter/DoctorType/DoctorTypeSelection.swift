//
//  DoctorTypeSelection.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 25/12/2024.
//

import UIKit


// MARK: - Doctor Type Selection
class DoctorTypeSelectionControl: UIView {
    enum DoctorType: String {
        case consultant = "Consultant"
        case specialist = "Specialist"
    }
    
    private let consultantButton: UIButton
    private let specialistButton: UIButton

    var selectedType: DoctorType? {
        didSet {
            updateButtonStates()
        }
    }
    
    var onTypeSelected: ((DoctorType?) -> Void)?
    
    override init(frame: CGRect) {
        consultantButton = UIButton(type: .custom)
        specialistButton = UIButton(type: .custom)
        super.init(frame: frame)
        setupButtons()
        setupLayout()
        updateButtonStates()
    }
    
    required init?(coder: NSCoder) {
        consultantButton = UIButton(type: .custom)
        specialistButton = UIButton(type: .custom)
        super.init(coder: coder)
        setupButtons()
        setupLayout()
    }
    
    private func setupButtons() {
        consultantButton.setTitle(AppLocalizedKeys.Consultant.localized, for: .normal)
        specialistButton.setTitle(AppLocalizedKeys.Specialist.localized, for: .normal)
        
        [consultantButton, specialistButton].forEach { button in
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
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setImage(imageForState(selected: false), for: .normal)
            button.addTarget(self, action: #selector(typeButtonTapped(_:)), for: .touchUpInside)
        }
        
        updateButtonStates()
    }
    
    private func setupLayout() {
        addSubview(consultantButton)
        addSubview(specialistButton)
        
        consultantButton.translatesAutoresizingMaskIntoConstraints = false
        specialistButton.translatesAutoresizingMaskIntoConstraints = false
        
        let isRTL = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        
        if isRTL {
            NSLayoutConstraint.activate([
                specialistButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                specialistButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                specialistButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
                
                consultantButton.leadingAnchor.constraint(equalTo: specialistButton.trailingAnchor, constant: 20),
                consultantButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                consultantButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
                consultantButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 120)
            ])
        } else {
            NSLayoutConstraint.activate([
                consultantButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                consultantButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                consultantButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
                
                specialistButton.leadingAnchor.constraint(equalTo: consultantButton.trailingAnchor, constant: 20),
                specialistButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                specialistButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
                specialistButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 120)
            ])
        }
    }
    
    private func updateButtonStates() {
        
        let isConsultantSelected = selectedType == .consultant
        let isSpecialistSelected = selectedType == .specialist
       
        consultantButton.setImage(imageForState(selected: isConsultantSelected), for: .normal)
        specialistButton.setImage(imageForState(selected: isSpecialistSelected), for: .normal)
        
        consultantButton.setTitleColor(isConsultantSelected ? .appColor : .gray, for: .normal)
        specialistButton.setTitleColor(isSpecialistSelected ? .appColor : .gray, for: .normal)
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
    
    @objc private func typeButtonTapped(_ sender: UIButton) {
        selectedType = sender == consultantButton ? .consultant : .specialist
        onTypeSelected?(selectedType)
    }
    
    func getSelectedType() -> DoctorType? {
        return selectedType
    }
}
