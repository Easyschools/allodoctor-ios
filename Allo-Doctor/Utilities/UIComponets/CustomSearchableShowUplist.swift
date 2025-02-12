//
//  CustomSearchableShowUplist.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 22/09/2024.
//

import Foundation
import UIKit

class CustomSearchableDropDownList: UIView {
    
    private let textField = UITextField()
    private var arrowImageView = UIImageView(image: UIImage(systemName: "chevron.up"))
    
    var didSelectItem: ((String) -> Void)?
    var items: [String] = [] {
        didSet {
            filteredItems = items
        }
    }
    private var filteredItems: [String] = []
    
    private var dropdownTableView: UITableView?
    private var dropdownBackgroundView: UIView?
    
    private var dropdownHeight: CGFloat = 200

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        textField.placeholder = "Search city and area"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.delegate = self
        addSubview(textField)
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.tintColor = .black
        addSubview(arrowImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            textField.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -10),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func toggleDropdown() {
        if dropdownTableView == nil {
            showDropdown()
            animateArrow(up: false)
        } else {
            hideDropdown()
        }
    }
    
    private func showDropdown() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let backgroundView = UIView(frame: window.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideDropdown))
        backgroundView.addGestureRecognizer(tapGesture)
        window.addSubview(backgroundView)
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        
        backgroundView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: topAnchor, constant: -5),
            tableView.heightAnchor.constraint(lessThanOrEqualToConstant: dropdownHeight)
        ])
        
        self.dropdownTableView = tableView
        self.dropdownBackgroundView = backgroundView
        tableView.reloadData()
    }
    
    @objc private func hideDropdown() {
        animateArrow(up: true)
        
        dropdownTableView?.removeFromSuperview()
        dropdownTableView = nil
        dropdownBackgroundView?.removeFromSuperview()
        dropdownBackgroundView = nil
    }
    
    func setDropdownHeight(_ height: CGFloat) {
        dropdownHeight = height
    }
    
    private func animateArrow(up: Bool) {
        let rotationAngle: CGFloat = up ? 0 : .pi
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
    
    private func filterItems(with searchText: String) {
        if searchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        dropdownTableView?.reloadData()
    }
}

extension CustomSearchableDropDownList: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "dropdownCell")
        cell.textLabel?.text = filteredItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = filteredItems[indexPath.row]
        textField.text = selectedItem
        didSelectItem?(selectedItem)
        hideDropdown()
    }
}

extension CustomSearchableDropDownList: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            filterItems(with: updatedText)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if dropdownTableView == nil {
            showDropdown()
            animateArrow(up: false)
        }
    }
}
