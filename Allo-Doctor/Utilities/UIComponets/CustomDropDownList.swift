//
//  CustomDropDownList.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/09/2024.
//

import UIKit

class CustomDropDownList: UIView {
    
    enum DropdownDirection {
        case up, down
    }
    
    let label = UILabel()
    private var arrowImageView = UIImageView(image: UIImage.dropDownArrow)
    
    var didSelectItem: ((String) -> Void)?
    var items: [String] = []
    private var filteredItems: [String] = []
    
    private var dropdownTableView: UITableView?
    private var dropdownBackgroundView: UIView?
    private var searchBar: UISearchBar?
    private var containerView: UIView?
    
    private var dropdownHeight: CGFloat = 200
    private var dropdownDirection: DropdownDirection = .down

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
        clipsToBounds = true
        
        label.text = "Tap to Select"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .greyA8A8A8
        label.font.withSize(12)
        addSubview(label)
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.tintColor = .black
        addSubview(arrowImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            label.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setDropdownDirection(_ direction: DropdownDirection) {
        dropdownDirection = direction
    }
    
    @objc private func toggleDropdown() {
        if dropdownTableView == nil {
            showDropdown()
            animateArrow(up: dropdownDirection == .up)
        } else {
            hideDropdown()
        }
    }
    
    private func showDropdown() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let backgroundView = UIView(frame: window.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideDropdown))
        backgroundView.addGestureRecognizer(tapGesture)
        window.addSubview(backgroundView)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.masksToBounds = true
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.alpha = 0
        backgroundView.addSubview(containerView)
        
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        containerView.addSubview(searchBar)
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        
        var containerConstraints: [NSLayoutConstraint] = []
        if dropdownDirection == .down {
            containerConstraints = [
                containerView.topAnchor.constraint(equalTo: bottomAnchor, constant: 5),
                containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                containerView.heightAnchor.constraint(lessThanOrEqualToConstant: dropdownHeight),
                
                searchBar.topAnchor.constraint(equalTo: containerView.topAnchor),
                tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ]
        } else {
            containerConstraints = [
                containerView.bottomAnchor.constraint(equalTo: topAnchor, constant: -5),
                containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                containerView.heightAnchor.constraint(lessThanOrEqualToConstant: dropdownHeight),
                
                searchBar.topAnchor.constraint(equalTo: containerView.topAnchor),
                tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ]
        }
        
        NSLayoutConstraint.activate(containerConstraints + [
            searchBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 56),
            
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        self.dropdownTableView = tableView
        self.dropdownBackgroundView = backgroundView
        self.searchBar = searchBar
        self.containerView = containerView
        self.filteredItems = items
        tableView.reloadData()
        
        UIView.animate(withDuration: 0.3) {
            backgroundView.alpha = 1
            containerView.alpha = 1
            containerView.transform = .identity
        }
    }
    
    @objc private func hideDropdown() {
        animateArrow(up: false)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.dropdownBackgroundView?.alpha = 0
            self.containerView?.alpha = 0
            self.containerView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.dropdownTableView?.removeFromSuperview()
            self.dropdownTableView = nil
            self.dropdownBackgroundView?.removeFromSuperview()
            self.dropdownBackgroundView = nil
            self.searchBar = nil
            self.containerView = nil
        }
    }
    
    func setDropdownHeight(_ height: CGFloat) {
        dropdownHeight = height
    }
    
    @objc private func cellTapped(_ gesture: UITapGestureRecognizer) {
        guard let cell = gesture.view as? UITableViewCell,
              let tableView = cell.superview as? UITableView,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let selectedItem = filteredItems[indexPath.row]
        label.text = selectedItem
        didSelectItem?(selectedItem)
        label.textColor = .black
        hideDropdown()
    }
    
    private func animateArrow(up: Bool) {
        let rotationAngle: CGFloat = up ? .pi : 0
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
}


extension CustomDropDownList: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "dropdownCell")
        cell.textLabel?.text = filteredItems[indexPath.row]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = filteredItems[indexPath.row]
        label.text = selectedItem
        didSelectItem?(selectedItem)
        hideDropdown()
    }
}

extension CustomDropDownList: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        dropdownTableView?.reloadData()
    }
}
