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

    // Callback for button taps
    var onToggle: ((Int) -> Void)?

    // Public function to set the toggle options
    func setToggleOptions(_ options: Any) {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        var optionsArray: [String] = []

        if let singleOption = options as? String {
            optionsArray.append(singleOption)
        } else if let multipleOptions = options as? [String] {
            optionsArray = multipleOptions
        } else {
            print("Invalid options type. Must be String or [String].")
            return
        }

        for (index, option) in optionsArray.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(option, for: .normal)
            button.tag = index
            button.titleLabel?.font = UIFont(name: "Cairo-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
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
        setSelectedIndex(sender.tag)
        onToggle?(sender.tag)
    }

    private func updateUI() {
        UIView.animate(withDuration: 0.3) {
            for (index, button) in self.buttons.enumerated() {
                if index == self.selectedIndex {
                    button.backgroundColor = self.selectedBackgroundColor
                    button.setTitleColor(self.selectedTextColor, for: .normal)
                    button.titleLabel?.font = UIFont(name: "Cairo-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
                } else {
                    button.backgroundColor = self.defaultBackgroundColor
                    button.setTitleColor(self.defaultTextColor, for: .normal)
                    button.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
                }
            }
        }
    }

    // Public function to set the selected index
    func setSelectedIndex(_ index: Int) {
        guard index >= 0 && index < buttons.count else { return }
        selectedIndex = index
    }
}
