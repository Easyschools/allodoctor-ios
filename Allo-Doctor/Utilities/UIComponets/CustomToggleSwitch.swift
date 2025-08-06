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
    private let scrollView = UIScrollView()
    
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
    
    private var stackViewWidthConstraint: NSLayoutConstraint?

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
        
        configureLayoutForOptionCount(optionsArray.count)
        updateUI()
    }
    
    private func configureLayoutForOptionCount(_ count: Int) {
        // Remove existing width constraint
        if let widthConstraint = stackViewWidthConstraint {
            widthConstraint.isActive = false
        }
        
        if count <= 2 {
            // For 1-2 options: fill equally, no scrolling
            stackView.distribution = .fillEqually
            scrollView.isScrollEnabled = false
            
            // Make stack view fill the scroll view width
            stackViewWidthConstraint = stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            stackViewWidthConstraint?.isActive = true
            
        } else {
            // For 3+ options: natural sizing, enable scrolling
            stackView.distribution = .fill
            scrollView.isScrollEnabled = true
            
            // Let stack view size itself based on content
            stackViewWidthConstraint = stackView.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor)
            stackViewWidthConstraint?.isActive = true
            
            // Ensure buttons size to their content
            for button in buttons {
                button.setContentHuggingPriority(.required, for: .horizontal)
                button.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
        }
        
        // Layout immediately and scroll if needed
        layoutIfNeeded()
        
        if count > 2 {
            scrollToSelectedButton()
        }
    }

    private func commonInit() {
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = CustomborderColor.cgColor
        layer.masksToBounds = true
        
        // Configure scroll view
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure stack view
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add scroll view to main view
        addSubview(scrollView)
        
        // Add stack view to scroll view
        scrollView.addSubview(stackView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Stack view constraints (width will be set dynamically)
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
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
        
        // Only scroll if we have 3+ options
        if buttons.count > 2 {
            scrollToSelectedButton()
        }
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
    
    // Scroll to the selected button to keep it visible
    private func scrollToSelectedButton() {
        guard selectedIndex < buttons.count, buttons.count > 2 else { return }
        
        DispatchQueue.main.async {
            let selectedButton = self.buttons[self.selectedIndex]
            let buttonFrame = selectedButton.frame
            
            // Calculate the ideal scroll position to center the button
            let scrollViewWidth = self.scrollView.frame.width
            let buttonCenter = buttonFrame.midX
            let idealScrollX = buttonCenter - (scrollViewWidth / 2)
            
            // Ensure we don't scroll beyond the content bounds
            let maxScrollX = max(0, self.stackView.frame.width - scrollViewWidth)
            let scrollX = max(0, min(idealScrollX, maxScrollX))
            
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentOffset = CGPoint(x: scrollX, y: 0)
            }
        }
    }

    // Public function to set the selected index
    func setSelectedIndex(_ index: Int) {
        guard index >= 0 && index < buttons.count else { return }
        selectedIndex = index
    }
}
