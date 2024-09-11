//
//  DropdownTextFieldView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 08/09/2024.
//

import UIKit

class DropdownTextFieldView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    private let textField = UITextField()
    private let pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    
    private var options: [String] = []
    
    // Callback for selected value
    var onOptionSelected: ((String) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
        setupPickerView()
        setupToolbar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
        setupPickerView()
        setupToolbar()
    }
    
    // MARK: - Setup Methods
    private func setupTextField() {
        textField.placeholder = "Select Area"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        // Constraints
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Assign the picker as inputView
        textField.inputView = pickerView
        textField.inputAccessoryView = toolbar
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupToolbar() {
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
    }
    
    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = options[row]
        textField.text = selectedOption
        onOptionSelected?(selectedOption)
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        textField.resignFirstResponder()
    }
    
    // MARK: - Public API
    func setOptions(_ options: [String]) {
        self.options = options
        pickerView.reloadAllComponents()
    }
    
    func getSelectedOption() -> String? {
        return textField.text
    }
}
