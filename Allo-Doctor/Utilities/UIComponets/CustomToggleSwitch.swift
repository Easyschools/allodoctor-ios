//
//  CustomToggleSwitch.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 20/09/2024.
//
import UIKit

@IBDesignable
class CustomToggleSwitch: UIView {

    // Properties
    private var buttons: [UIButton] = []
    private let stackView = UIStackView()
    
    @IBInspectable var selectedBackgroundColor: UIColor = UIColor(red: 0.941, green: 0.965, blue: 1.0, alpha: 1.0) // Light blue
    @IBInspectable var defaultBackgroundColor: UIColor = .white
    
    @IBInspectable var selectedTextColor: UIColor = UIColor(red: 0.0, green: 0.478, blue: 0.851, alpha: 1.0) // Blue
    @IBInspectable var defaultTextColor: UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0) // Gray
    
    @IBInspectable var CustomborderColor: UIColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1.0) // Light gray
    
    private var selectedIndex: Int = 0 {
        didSet {
            updateUI()
        }
    }

    // Public function to set the toggle options
    func setToggleOptions(_ options: [String]) {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for (index, option) in options.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(option, for: .normal)
            button.tag = index
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(toggleTapped(_:)), for: .touchUpInside)
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

            stackView.addArrangedSubview(button)
            buttons.append(button)
        }

        updateUI()
    }

    private func commonInit() {
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = CustomborderColor.cgColor
        layer.masksToBounds = true
        
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        backgroundColor = defaultBackgroundColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    @objc private func toggleTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
    }

    private func updateUI() {
        for (index, button) in buttons.enumerated() {
            if index == selectedIndex {
                button.backgroundColor = selectedBackgroundColor
                button.setTitleColor(selectedTextColor, for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            } else {
                button.backgroundColor = defaultBackgroundColor
                button.setTitleColor(defaultTextColor, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            }
        }
    }
}
